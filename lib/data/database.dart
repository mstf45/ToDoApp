import 'package:hive/hive.dart';
import 'package:todoapp/custom_keys/keys.dart';

class ToDoDataBase {
  List toDoList = [];
  final _mybox = Hive.box(CustomKeys.myBoxName);

  void createInitData() {
    toDoList = [];
  }

  void loadData() {
    toDoList = _mybox.get(CustomKeys.loadData);
  }

  void updateDataBase() {
    _mybox.put(CustomKeys.updateDataBase, toDoList);
  }
}