import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/components/color_components.dart';
import 'package:todoapp/custom_keys/keys.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFuntion;
  Function(BuildContext)? editFuntion;
  void Function()? onPressed;
  ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFuntion,
    required this.editFuntion,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding:
          const EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10),
      child: Slidable(
        dragStartBehavior: DragStartBehavior.down,
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              spacing: 7,
              label: CustomKeys.slidableLabelEdit,
              onPressed: editFuntion,
              icon: Icons.edit,
              backgroundColor:
                  ColorCustom.todotileSlidableActionbackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              spacing: 7,
              label: CustomKeys.slidableLabelDelete,
              onPressed: deleteFuntion,
              icon: Icons.delete,
              backgroundColor:
                  ColorCustom.todotileSlidableActionbackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          height: taskName.characters.length > 30 ? 200 : 150,
          width: width,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: ColorCustom.toditilecontainercolor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: taskCompleted,
                    onChanged: onChanged,
                    activeColor: ColorCustom.todotilechectboxactiveColor,
                  ),
                  const Text(''),
                  const Spacer(),
                  IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      onPressed != true
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      textAlign: TextAlign.start,
                      taskName,
                      style: TextStyle(
                        decoration: taskCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationThickness: 2.5,
                        fontSize:
                            Theme.of(context).textTheme.titleLarge?.fontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
