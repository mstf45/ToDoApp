import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/models/todo_model.dart';

class TodoService {
  static const String _todosKey = 'todos';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Todo>> getTodos() async {
    final jsonList = _prefs.getStringList(_todosKey) ?? [];
    return jsonList.map((json) => Todo.fromJson(json)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final jsonList = todos.map((todo) => todo.toJson()).toList();
    await _prefs.setStringList(_todosKey, jsonList);
  }

  Future<void> addTodo(Todo todo) async {
    final todos = await getTodos();
    todos.add(todo);
    await saveTodos(todos);
  }

  Future<void> updateTodo(Todo todo) async {
    final todos = await getTodos();
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos[index] = todo;
      await saveTodos(todos);
    }
  }

  Future<void> deleteTodo(String id) async {
    final todos = await getTodos();
    todos.removeWhere((t) => t.id == id);
    await saveTodos(todos);
  }

  Future<void> toggleTodo(String id) async {
    final todos = await getTodos();
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final todo = todos[index];
      todos[index] = todo.copyWith(
        isCompleted: !todo.isCompleted,
        updatedAt: DateTime.now(),
      );
      await saveTodos(todos);
    }
  }

  Future<void> deleteAllTodos() async {
    await _prefs.remove(_todosKey);
  }
}
