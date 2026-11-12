import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/core/theme/app_durations.dart';
import 'package:todoapp/feature/home/home/model/todo.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/constants/firestore_paths.dart';
import 'package:todoapp/product/constants/todo_storage_keys.dart';
import 'package:todoapp/product/logger/app_logger.dart';
import 'package:todoapp/product/service/connectivity_service.dart';
import 'package:todoapp/product/service/impl/connectivity_service_impl.dart';
import 'package:todoapp/product/service/todo_service.dart';

final class TodoServiceImpl implements ITodoService {
  TodoServiceImpl({
    FirebaseFirestore? firestore,
    IConnectivityService? connectivity,
  }) : _firestore = firestore,
       _connectivity = connectivity ?? ConnectivityServiceImpl();

  final FirebaseFirestore? _firestore;
  final IConnectivityService _connectivity;
  final StreamController<TodoSyncStatus> _syncEvents = StreamController<TodoSyncStatus>.broadcast();

  SharedPreferences? _prefs;
  StreamSubscription<bool>? _connectivitySubscription;
  Timer? _retryTimer;
  Future<void> _queue = Future<void>.value();
  String? _activeUid;
  int _revision = 0;

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  @override
  Stream<TodoSyncStatus> get syncEvents => _syncEvents.stream;

  @override
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    if (_connectivitySubscription != null) return;
    try {
      await _connectivity.isOnline;
    } on Exception catch (error, stackTrace) {
      AppLogger.error(AppStrings.todoSyncFailed, error, stackTrace);
      return;
    }
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (online) {
        final uid = _activeUid;
        if (!online || uid == null || !_isPending(uid)) return;
        unawaited(syncPending(uid));
      },
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.error(AppStrings.todoSyncFailed, error, stackTrace);
      },
    );
  }

  @override
  Future<List<Todo>> getTodos(String uid) async {
    _activeUid = uid;
    final local = _readLocal(uid);
    if (_isPending(uid)) {
      try {
        await syncPending(uid);
      } on Exception catch (error, stackTrace) {
        AppLogger.error(AppStrings.todoSyncFailed, error, stackTrace);
      }
      return _readLocal(uid);
    }

    final legacy = _readLegacy();
    try {
      final remote = await _readRemote(uid);
      if (remote.isEmpty && legacy.isNotEmpty && local.isEmpty) {
        await _writeLocal(uid, legacy);
        await _setPending(uid, true);
        await _preferences.remove(TodoStorageKeys.todos);
        await syncPending(uid);
        return _readLocal(uid);
      }
      await _writeLocal(uid, remote);
      await _clearUnsynced(uid);
      if (legacy.isNotEmpty) await _preferences.remove(TodoStorageKeys.todos);
      return remote;
    } on Exception catch (error, stackTrace) {
      AppLogger.error(AppStrings.todosLoadFailed, error, stackTrace);
      if (_isConnectionProblem(error) || local.isNotEmpty || legacy.isNotEmpty) {
        return local.isNotEmpty ? local : legacy;
      }
      rethrow;
    }
  }

  @override
  Future<List<String>> unsyncedIds(String uid) async {
    return List<String>.of(_readUnsynced(uid));
  }

  @override
  Future<bool> saveTodos(String uid, List<Todo> todos) async {
    _activeUid = uid;
    final previousIds = _readLocal(uid).map((todo) => todo.id).toSet();
    final added = [for (final todo in todos) if (!previousIds.contains(todo.id)) todo.id];
    _revision++;
    await _writeLocal(uid, todos);
    await _rememberUnsynced(uid, todos, added);
    await _setPending(uid, true);
    try {
      final status = await syncPending(uid);
      return status != TodoSyncStatus.synced;
    } on Exception catch (error) {
      if (_isConnectionProblem(error)) return true;
      rethrow;
    }
  }

  @override
  Future<TodoSyncStatus> syncPending(String uid) {
    _activeUid = uid;
    return _enqueue(() => _syncNow(uid));
  }

  Future<TodoSyncStatus> _syncNow(String uid) async {
    if (!_isPending(uid)) return TodoSyncStatus.idle;

    final revision = _revision;
    final snapshot = List<Todo>.of(_readLocal(uid));
    if (!await _serverReachable(uid)) {
      _scheduleRetry(uid);
      _emit(TodoSyncStatus.pending);
      return TodoSyncStatus.pending;
    }
    try {
      await _upload(uid, snapshot);
      if (revision != _revision || !_isPending(uid)) {
        _scheduleRetry(uid);
        return TodoSyncStatus.pending;
      }
      await _setPending(uid, false);
      await _clearUnsynced(uid);
      _retryTimer?.cancel();
      AppLogger.info('todos uploaded uid=$uid count=${snapshot.length}');
      _emit(TodoSyncStatus.synced);
      return TodoSyncStatus.synced;
    } on Exception catch (error, stackTrace) {
      AppLogger.error(AppStrings.todoSyncFailed, error, stackTrace);
      if (!_isConnectionProblem(error)) rethrow;
      _scheduleRetry(uid);
      _emit(TodoSyncStatus.pending);
      return TodoSyncStatus.pending;
    }
  }

  Future<T> _enqueue<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then((_) {}, onError: (Object _) {});
    return result;
  }

  void _scheduleRetry(String uid) {
    _retryTimer?.cancel();
    _retryTimer = Timer(AppDurations.syncRetry, () {
      unawaited(syncPending(uid));
    });
  }

  void _emit(TodoSyncStatus status) {
    if (_syncEvents.isClosed) return;
    _syncEvents.add(status);
  }

  Future<void> _upload(String uid, List<Todo> todos) async {
    final collection = _todos(uid);
    if (todos.isNotEmpty) {
      final batch = _db.batch();
      for (var index = 0; index < todos.length; index++) {
        final todo = todos[index];
        batch.set(collection.doc(todo.id), {
          ...todo.toMap(),
          FirestorePaths.sortIndex: index,
        });
      }
      await batch.commit().timeout(AppDurations.remoteSync);
      await _db.waitForPendingWrites().timeout(AppDurations.serverAck);
    }

    try {
      await _deleteRemoteTodosMissingFrom(collection, todos);
    } on Exception catch (error, stackTrace) {
      if (todos.isEmpty) rethrow;
      AppLogger.error(AppStrings.todoSyncFailed, error, stackTrace);
    }
  }

  Future<void> _deleteRemoteTodosMissingFrom(
    CollectionReference<Map<String, dynamic>> collection,
    List<Todo> todos,
  ) async {
    final existing = await collection.get(const GetOptions(source: Source.server)).timeout(AppDurations.remoteSync);
    final ids = todos.map((todo) => todo.id).toSet();
    final batch = _db.batch();
    var hasDelete = false;
    for (final doc in existing.docs) {
      if (ids.contains(doc.id)) continue;
      batch.delete(doc.reference);
      hasDelete = true;
    }
    if (!hasDelete) return;
    await batch.commit().timeout(AppDurations.remoteSync);
  }

  CollectionReference<Map<String, dynamic>> _todos(String uid) {
    return _db.collection(FirestorePaths.userProfiles).doc(uid).collection(FirestorePaths.todos);
  }

  Future<bool> _serverReachable(String uid) async {
    try {
      await _todos(uid).limit(1).get(const GetOptions(source: Source.server)).timeout(AppDurations.serverAck);
      return true;
    } on Exception catch (error, stackTrace) {
      AppLogger.error(AppStrings.todoSyncFailed, error, stackTrace);
      if (_isConnectionProblem(error)) return false;
      rethrow;
    }
  }

  Future<List<Todo>> _readRemote(String uid) async {
    final snapshot = await _todos(uid)
        .orderBy(FirestorePaths.sortIndex)
        .get(const GetOptions(source: Source.server))
        .timeout(AppDurations.remoteSync);
    return snapshot.docs.map((doc) => Todo.fromMap(doc.data())).toList();
  }

  List<Todo> _readLocal(String uid) {
    final stored = _preferences.getStringList(TodoStorageKeys.todosFor(uid)) ?? const <String>[];
    return stored.map(Todo.fromJson).toList();
  }

  List<Todo> _readLegacy() {
    final stored = _preferences.getStringList(TodoStorageKeys.todos) ?? const <String>[];
    return stored.map(Todo.fromJson).toList();
  }

  Future<void> _writeLocal(String uid, List<Todo> todos) async {
    final encoded = todos.map((todo) => todo.toJson()).toList();
    await _preferences.setStringList(TodoStorageKeys.todosFor(uid), encoded);
  }

  List<String> _readUnsynced(String uid) {
    return _preferences.getStringList(TodoStorageKeys.unsyncedFor(uid)) ?? const <String>[];
  }

  Future<void> _rememberUnsynced(String uid, List<Todo> todos, List<String> added) async {
    final alive = todos.map((todo) => todo.id).toSet();
    final next = <String>[
      for (final id in <String>{..._readUnsynced(uid), ...added})
        if (alive.contains(id)) id,
    ];
    if (next.isEmpty) {
      await _clearUnsynced(uid);
      return;
    }
    await _preferences.setStringList(TodoStorageKeys.unsyncedFor(uid), next);
  }

  Future<void> _clearUnsynced(String uid) async {
    await _preferences.remove(TodoStorageKeys.unsyncedFor(uid));
  }

  bool _isPending(String uid) {
    return _preferences.getBool(TodoStorageKeys.pendingFor(uid)) ?? false;
  }

  Future<void> _setPending(String uid, bool value) async {
    if (!value) {
      await _preferences.remove(TodoStorageKeys.pendingFor(uid));
      return;
    }
    await _preferences.setBool(TodoStorageKeys.pendingFor(uid), true);
  }

  SharedPreferences get _preferences {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('TodoServiceImpl.init must be called before use.');
    }
    return prefs;
  }
}

bool _isConnectionProblem(Object error) {
  if (error is TimeoutException) return true;
  if (error is FirebaseException) {
    const codes = <String>{
      'unavailable',
      'network-request-failed',
      'deadline-exceeded',
      'cancelled',
      'aborted',
    };
    return codes.contains(error.code);
  }
  return true;
}
