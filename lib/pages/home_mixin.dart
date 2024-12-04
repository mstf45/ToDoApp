import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/custom_keys/keys.dart';
import 'package:todoapp/data/database.dart';
import 'package:todoapp/pages/home.dart';
import 'package:todoapp/util/dialog_box.dart';

mixin HomeMixinUsing on State<HomePage> {
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
    _updateSelectAllState();
    _updateVisibilityState();
  }

  void selectAllTasks() {
    setState(() {
      bool allSelected = db.toDoList.every((task) => task[1]);
      for (var i = 0; i < db.toDoList.length; i++) {
        if (db.toDoList[i][1] == true) {
          db.toDoList[i][1] = false;
        }
        db.toDoList[i][1] = !allSelected;
      }
      isSelect = !allSelected;
      db.updateDataBase();
      _updateVisibilityState();
    });
  }

  void _updateVisibilityState() {
    setState(() {
      isVisibllitiy = db.toDoList.any((task) => task[1]);
    });
  }

  final ScrollController scrollController = ScrollController();

  final _mybox = Hive.box(CustomKeys.myBoxName);
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_mybox.get(CustomKeys.loadData) == null) {
      db.createInitData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  final controller = TextEditingController();

  void saveNewTask() {
    setState(() {
      if (controller.text.isNotEmpty) {
        db.toDoList.insert(0, [controller.text, false]);
      }
      Navigator.of(context).pop();
      controller.clear();
      db.updateDataBase();
    });
  }

  void createNewTaskk() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DialogBox(
          controller: controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
    controller.clear();
  }

  void editTask(int index) {
    controller.text = db.toDoList[index][0];

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => DialogBox(
          controller: controller,
          onSave: () {
            setState(() {
              db.toDoList[index][0] = controller.text;
            });
            Navigator.of(context).pop();
            controller.clear();
            db.updateDataBase();
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void deleteTask(int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  db.toDoList.removeAt(index);
                });
                db.updateDataBase();
                Navigator.pop(context);
              },
              icon: Text(CustomKeys.deleteTaskButton1),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Text(CustomKeys.deleteTaskButton2),
            ),
          ],
          title: Text(CustomKeys.deleteTaskTitle),
          insetAnimationCurve: Curves.easeIn,
        );
      },
    );
  }

  bool isSelect = false;
  bool isVisibllitiy = false;
  bool onTaps = false;

  void deleteAllTasks() {
    setState(() {
      db.toDoList.removeWhere((task) => task[1] == true);
      isSelect = false;
      db.updateDataBase();
    });
  }

  void _updateSelectAllState() {
    setState(() {
      isSelect = db.toDoList.every((task) => task[1]);
    });
  }
}
