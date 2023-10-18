import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do_list/data/database.dart';
import 'package:to_do_list/util/dialog_box.dart';
import 'package:to_do_list/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mybox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();
  @override
  void initState() {
    if (_mybox.get('TODOLIST') == null) {
      db.createInitData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      _controller.text.isNotEmpty
          ? db.toDoList.add([_controller.text, false])
          : null;
      _controller.clear();
      Navigator.of(context).pop();
      db.updateDataBase();
    });
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff86A8cf),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff522B5B),
        centerTitle: true,
        title: const Text('Projelerim'),
        elevation: 0,
      ),
      body: db.toDoList.isNotEmpty
          ? ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFuntion: (context) => deleteTask(index),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Lottie.asset(
                      'assets/lottie/success.json',
                    ),
                  ),
                  Text(
                    'Yeni Proje Eklemek İçin \n + \n Butonuna Basınız.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline6?.fontSize,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Yeni Not Ekle',
        elevation: 0,
        backgroundColor: const Color(0xff06142e),
        onPressed: createNewTask,
        label: Row(
          children: [
            Text(
              'Yeni Bir Proje Yaz ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
              ),
            ),
            const Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}
