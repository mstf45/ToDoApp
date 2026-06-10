import 'package:flutter/material.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/services/todo_service.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _service;
  List<Todo> _todos = [];
  bool _isLoading = false;

  TodoProvider(this._service);

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;

  int get totalCount => _todos.length;
  int get completedCount => _todos.where((t) => t.isCompleted).length;
  int get pendingCount => totalCount - completedCount;

  bool get isEmpty => _todos.isEmpty;

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _todos = await _service.getTodos();
    } catch (e) {
      // ignore: avoid_print
      print('Error loading todos: $e');
      _todos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearTodos() {
    _todos = [];
    notifyListeners();
  }

  Future<bool> addTodo({
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
    final ok = await _service.addTodo(todo);
    if (ok) {
      _todos.add(todo);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateTodo({
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
      final ok = await _service.updateTodo(todo);
      if (ok) {
        _todos[index] = todo;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> toggleTodo(String id) async {
    final ok = await _service.toggleTodo(id);
    if (ok) {
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(
          isCompleted: !_todos[index].isCompleted,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  Future<bool> deleteTodo(String id) async {
    final ok = await _service.deleteTodo(id);
    if (ok) {
      _todos.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteAllTodos() async {
    final ok = await _service.deleteAllTodos();
    if (ok) {
      _todos.clear();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> reorderTodos(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    final todo = _todos.removeAt(oldIndex);
    _todos.insert(newIndex, todo);
    final ok = await _service.saveTodos(_todos);
    if (ok) {
      notifyListeners();
      return true;
    }
    // revert local change on failure
    _todos.removeAt(newIndex);
    _todos.insert(oldIndex, todo);
    return false;
  }
}
