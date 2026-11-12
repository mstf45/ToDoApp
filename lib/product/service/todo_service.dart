import 'package:todoapp/feature/home/home/model/todo.dart';

enum TodoSyncStatus { idle, pending, synced }

abstract interface class ITodoService {
  Future<void> init();

  Stream<TodoSyncStatus> get syncEvents;

  Future<List<Todo>> getTodos(String uid);

  Future<List<String>> unsyncedIds(String uid);

  /// Saves on the device first. Returns true when the list is still waiting
  /// for a connection before it can be uploaded.
  Future<bool> saveTodos(String uid, List<Todo> todos);

  Future<TodoSyncStatus> syncPending(String uid);
}
