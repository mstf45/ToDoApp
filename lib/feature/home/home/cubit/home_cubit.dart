import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/feature/home/home/cubit/home_state.dart';
import 'package:todoapp/feature/home/home/model/todo.dart';
import 'package:todoapp/product/application/session_cubit.dart';
import 'package:todoapp/product/application/session_state.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/logger/app_logger.dart';
import 'package:todoapp/product/service/todo_service.dart';
import 'package:uuid/uuid.dart';

final class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._todoService, this._sessionCubit) : super(const HomeState()) {
    _subscription = _sessionCubit.stream.listen(_onSession);
    _syncSubscription = _todoService.syncEvents.listen(_onSyncEvent);
    _onSession(_sessionCubit.state);
  }

  final ITodoService _todoService;
  final SessionCubit _sessionCubit;
  final Uuid _uuid = const Uuid();
  late final StreamSubscription<SessionState> _subscription;
  late final StreamSubscription<TodoSyncStatus> _syncSubscription;
  String? _uid;
  bool _waitingForSync = false;

  void _onSession(SessionState session) {
    if (session.status != SessionStatus.authenticated) {
      if (session.status == SessionStatus.unknown) return;
      _uid = null;
      emit(const HomeState(isLoading: false));
      return;
    }

    final uid = session.user?.uid ?? '';
    if (uid.isEmpty || uid == _uid) return;
    _uid = uid;
    emit(state.copyWith(todos: const [], isLoading: true));
    unawaited(loadTodos());
  }

  Future<void> loadTodos() async {
    final uid = _uid;
    if (uid == null || uid.isEmpty) return;
    try {
      final todos = await _todoService.getTodos(uid);
      final unsyncedIds = await _todoService.unsyncedIds(uid);
      if (isClosed || _uid != uid) return;
      emit(state.copyWith(todos: todos, unsyncedIds: unsyncedIds, isLoading: false));
    } on Exception catch (e, stackTrace) {
      AppLogger.error(AppStrings.todosLoadFailed, e, stackTrace);
      if (isClosed || _uid != uid) return;
      _feedback(AppStrings.todosLoadFailed, isError: true);
    }
  }

  Future<void> addTodo({
    required String title,
    required String description,
  }) async {
    final todo = Todo(
      id: _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      createdAt: DateTime.now(),
    );
    final next = List<Todo>.of(state.todos)..insert(0, todo);
    await _persist(next);
  }

  Future<void> updateTodo({
    required String id,
    required String title,
    required String description,
  }) async {
    final next = state.todos
        .map(
          (todo) => todo.id == id
              ? todo.copyWith(
                  title: title.trim(),
                  description: description.trim(),
                  updatedAt: DateTime.now(),
                )
              : todo,
        )
        .toList();
    await _persist(next);
  }

  Future<void> toggleTodo(String id) async {
    final next = state.todos
        .map(
          (todo) => todo.id == id
              ? todo.copyWith(
                  isCompleted: !todo.isCompleted,
                  updatedAt: DateTime.now(),
                )
              : todo,
        )
        .toList();
    await _persist(next);
  }

  Future<void> deleteTodo(String id) async {
    final next = state.todos.where((todo) => todo.id != id).toList();
    await _persist(next, feedback: AppStrings.taskDeleted);
  }

  Future<void> deleteAllTodos() async {
    await _persist(const [], feedback: AppStrings.allTasksDeleted);
  }

  Future<void> reorderTodos(int oldIndex, int newIndex) async {
    final backedUp = List<Todo>.of(state.backedUpTodos);
    if (oldIndex < 0 || oldIndex >= backedUp.length) return;
    final todo = backedUp.removeAt(oldIndex);
    backedUp.insert(newIndex, todo);
    await _persist(<Todo>[...state.unsyncedTodos, ...backedUp]);
  }

  Future<void> _persist(List<Todo> next, {String feedback = ''}) async {
    final uid = _uid;
    if (uid == null || uid.isEmpty) {
      _feedback(AppStrings.todoActionFailed, isError: true);
      return;
    }
    try {
      final savedLocally = await _todoService.saveTodos(uid, next);
      final unsyncedIds = await _todoService.unsyncedIds(uid);
      if (isClosed || _uid != uid) return;
      final announceOffline = savedLocally && !_waitingForSync;
      if (savedLocally) _waitingForSync = true;
      final message = feedback.isNotEmpty
          ? feedback
          : announceOffline
              ? AppStrings.savedLocally
              : '';
      if (message.isEmpty) {
        emit(state.copyWith(todos: next, unsyncedIds: unsyncedIds, isLoading: false));
        return;
      }
      emit(
        state.copyWith(
          todos: next,
          unsyncedIds: unsyncedIds,
          isLoading: false,
          feedbackMessage: message,
          feedbackTick: state.feedbackTick + 1,
          feedbackIsError: false,
        ),
      );
    } on Exception catch (e, stackTrace) {
      AppLogger.error(AppStrings.todoActionFailed, e, stackTrace);
      if (isClosed) return;
      if (_uid != uid) return;
      _feedback(AppStrings.todoActionFailed, isError: true);
    }
  }

  void _onSyncEvent(TodoSyncStatus status) {
    if (isClosed) return;
    if (status == TodoSyncStatus.pending) {
      if (_waitingForSync) return;
      _waitingForSync = true;
      _feedback(AppStrings.savedLocally, isError: false);
      return;
    }
    if (status != TodoSyncStatus.synced) return;
    unawaited(_showSyncedNotes());
  }

  Future<void> _showSyncedNotes() async {
    final uid = _uid;
    if (uid == null || uid.isEmpty) return;
    final unsyncedIds = await _todoService.unsyncedIds(uid);
    if (isClosed || _uid != uid) return;
    final announce = _waitingForSync;
    _waitingForSync = false;
    if (!announce) {
      emit(state.copyWith(unsyncedIds: unsyncedIds));
      return;
    }
    emit(
      state.copyWith(
        unsyncedIds: unsyncedIds,
        isLoading: false,
        feedbackMessage: AppStrings.todosSynced,
        feedbackTick: state.feedbackTick + 1,
        feedbackIsError: false,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await _syncSubscription.cancel();
    return super.close();
  }

  void _feedback(String message, {required bool isError}) {
    emit(
      state.copyWith(
        isLoading: false,
        feedbackMessage: message,
        feedbackTick: state.feedbackTick + 1,
        feedbackIsError: isError,
      ),
    );
  }
}
