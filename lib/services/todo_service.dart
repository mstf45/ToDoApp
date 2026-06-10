import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/services/auth_service.dart';

class TodoService {
  final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TodoService(this._authService);

  CollectionReference get _todosRef {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      throw StateError('User is not signed in.');
    }
    return _firestore.collection('users').doc(uid).collection('todos');
  }

  Future<List<Todo>> getTodos() async {
    try {
      final uid = _authService.currentUser?.uid;
      // ignore: avoid_print
      print('DEBUG: Getting todos for user: $uid');
      
      final snapshot = await _todosRef.orderBy('sortIndex').get();
      // ignore: avoid_print
      print('DEBUG: Retrieved ${snapshot.docs.length} documents from Firestore');
      
      final todos = <Todo>[];
      for (final doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          todos.add(Todo.fromFirestore(data));
        } catch (e) {
          // ignore: avoid_print
          print('DEBUG: Error parsing document ${doc.id}: $e');
        }
      }
      // ignore: avoid_print
      print('DEBUG: Successfully loaded ${todos.length} todos');
      return todos;
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print('DEBUG: FirebaseException in getTodos: ${e.code} - ${e.message}');
      if (e.code == 'permission-denied' ||
          (e.message != null && e.message!.contains('Missing or insufficient permissions'))) {
        // ignore: avoid_print
        print('Firestore permission denied: ${e.message}');
        return <Todo>[];
      }
      rethrow;
    } catch (e) {
      // ignore: avoid_print
      print('DEBUG: Unexpected error in getTodos: $e');
      rethrow;
    }
  }

  Future<bool> addTodo(Todo todo) async {
    try {
      final currentTodos = await getTodos().catchError((_) => <Todo>[]);
      final sortIndex = currentTodos.length;
      await _todosRef.doc(todo.id).set({
        ...todo.toFirestore(),
        'sortIndex': sortIndex,
      });
      return true;
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print('Firestore write failed (addTodo): ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Unexpected error in addTodo: $e');
      return false;
    }
  }

  Future<bool> updateTodo(Todo todo) async {
    try {
      await _todosRef.doc(todo.id).set(todo.toFirestore(), SetOptions(merge: true));
      return true;
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print('Firestore write failed (updateTodo): ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Unexpected error in updateTodo: $e');
      return false;
    }
  }

  Future<bool> toggleTodo(String id) async {
    try {
      final todos = await getTodos();
      final todo = todos.firstWhere((element) => element.id == id);
      final ok = await updateTodo(todo.copyWith(
        isCompleted: !todo.isCompleted,
        updatedAt: DateTime.now(),
      ));
      return ok;
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print('Firestore write failed (toggleTodo): ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Unexpected error in toggleTodo: $e');
      return false;
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      await _todosRef.doc(id).delete();
      return true;
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print('Firestore write failed (deleteTodo): ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Unexpected error in deleteTodo: $e');
      return false;
    }
  }

  Future<bool> deleteAllTodos() async {
    try {
      final snapshot = await _todosRef.get();
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return true;
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print('Firestore write failed (deleteAllTodos): ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Unexpected error in deleteAllTodos: $e');
      return false;
    }
  }

  Future<bool> saveTodos(List<Todo> todos) async {
    try {
      final batch = _firestore.batch();
      for (var i = 0; i < todos.length; i++) {
        final todo = todos[i];
        final docRef = _todosRef.doc(todo.id);
        batch.set(docRef, {
          ...todo.toFirestore(),
          'sortIndex': i,
        }, SetOptions(merge: true));
      }
      await batch.commit();
      return true;
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print('Firestore write failed (saveTodos): ${e.message}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Unexpected error in saveTodos: $e');
      return false;
    }
  }
}
