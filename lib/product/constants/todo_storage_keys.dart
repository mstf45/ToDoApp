final class TodoStorageKeys {
  const TodoStorageKeys._();

  static const String todos = 'todos';

  static String todosFor(String uid) => 'todos_$uid';

  static String pendingFor(String uid) => 'todos_pending_$uid';

  static String unsyncedFor(String uid) => 'todos_unsynced_$uid';
}
