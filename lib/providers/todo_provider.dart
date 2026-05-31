import 'package:flutter/material.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/services/todo_service.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _service;
  List<Todo> _todos = [];

  TodoProvider(this._service);

  List<Todo> get todos => _todos;

  int get totalCount => _todos.length;
  int get completedCount => _todos.where((t) => t.isCompleted).length;
  int get pendingCount => totalCount - completedCount;

  bool get isEmpty => _todos.isEmpty;

  Future<void> loadTodos() async {
    _todos = await _service.getTodos();
    notifyListeners();
  }

  Future<void> addTodo({
    required String title,
    required String description,
  }) async {
    const uuid = Uuid();
    final todo = Todo(
      id: uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    await _service.addTodo(todo);
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> updateTodo({
    required String id,
    required String title,
    required String description,
  }) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final todo = _todos[index].copyWith(
        title: title,
        description: description,
        updatedAt: DateTime.now(),
      );
      await _service.updateTodo(todo);
      _todos[index] = todo;
      notifyListeners();
    }
  }

  Future<void> toggleTodo(String id) async {
    await _service.toggleTodo(id);
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    await _service.deleteTodo(id);
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> deleteAllTodos() async {
    await _service.deleteAllTodos();
    _todos.clear();
    notifyListeners();
  }

  Future<void> reorderTodos(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    final todo = _todos.removeAt(oldIndex);
    _todos.insert(newIndex, todo);
    await _service.saveTodos(_todos);
    notifyListeners();
  }
}
