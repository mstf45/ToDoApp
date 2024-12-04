import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/components/color_components.dart';
import 'package:todoapp/custom_keys/keys.dart';
import 'package:todoapp/pages/home_mixin.dart';
import 'package:todoapp/util/todo_tile.dart';
import 'package:hidable/hidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeMixinUsing {
  @override
  Widget build(BuildContext context) {
    // final gelen = Provider.of<ColorProvider>(context);
    return Scaffold(
      backgroundColor: ColorCustom.scafoldbackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Visibility(
          visible: isVisibllitiy,
          child: IconButton(
            highlightColor: Colors.transparent,
            icon: const Icon(Icons.cancel),
            onPressed: () {
              selectAllTasks();
            },
          ),
        ),
        backgroundColor: db.toDoList.isNotEmpty
            ? ColorCustom.appbarbackgroundColor
            : ColorCustom.scafoldbackgroundColor,
        centerTitle: true,
        title: Text(
          CustomKeys.appbarTitle,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              if (isSelect) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      actions: [
                        IconButton(
                          onPressed: () {
                            deleteAllTasks();
                            Navigator.pop(context);
                          },
                          icon: Text(CustomKeys.deleteTaskButton1),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Text(
                            CustomKeys.deleteTaskButton2,
                          ),
                        ),
                      ],
                      title: Text(CustomKeys.cupertinoAlertDialog),
                      insetAnimationCurve: Curves.easeIn,
                    );
                  },
                );
              } else {
                selectAllTasks();
              }
            },
            icon: Icon(
              isSelect ? Icons.delete : Icons.check_circle,
            ),
            highlightColor: Colors.transparent,
          ),
        ],
      ),
      body: db.toDoList.isNotEmpty
          ? ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = db.toDoList.removeAt(oldIndex);
                  db.toDoList.insert(newIndex, item);
                  db.updateDataBase();
                });
              },
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  key: ValueKey(db.toDoList[index]),
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFuntion: (context) => deleteTask(index),
                  editFuntion: (p0) => editTask(index),
                  onPressed: () {},
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.text.isEmpty)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Lottie.asset(CustomKeys.assetsPath, repeat: false),
                    ),
                  Text(
                    CustomKeys.clearListAdd,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge?.fontSize,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Hidable(
        controller: scrollController,
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            tooltip: CustomKeys.tooltip,
            elevation: 0,
            backgroundColor: const Color(0xff06142e),
            onPressed: createNewTaskk,
            child: const Icon(
              Icons.add,
              color: ColorCustom.fabButtonbackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
