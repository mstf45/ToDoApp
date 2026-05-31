import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/constants/app_strings.dart';
import 'package:todoapp/dialogs/add_edit_todo_dialog.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/providers/todo_provider.dart';
import 'package:todoapp/theme/app_theme.dart';

class ModernTodoTile extends StatelessWidget {
  final Todo todo;

  const ModernTodoTile({required this.todo, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Slidable(
        key: ValueKey(todo.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _editTodo(context),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: AppStrings.edit,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (_) => _deleteTodo(context),
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: AppStrings.delete,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: todo.isCompleted
                  ? AppTheme.primaryColor.withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: GestureDetector(
              onTap: () => context.read<TodoProvider>().toggleTodo(todo.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: todo.isCompleted
                        ? AppTheme.primaryColor
                        : Colors.white30,
                    width: 2,
                  ),
                  color: todo.isCompleted
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                ),
                child: todo.isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.white54,
              ),
            ),
            subtitle: todo.description.isNotEmpty
                ? Text(
                    todo.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white38,
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  )
                : null,
            trailing: PopupMenuButton(
              color: AppTheme.surfaceDark,
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => _editTodo(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: AppTheme.primaryColor, size: 18),
                      SizedBox(width: 8),
                      Text(AppStrings.edit, style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: () => _deleteTodo(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete, color: AppTheme.errorColor, size: 18),
                      SizedBox(width: 8),
                      Text(AppStrings.delete, style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editTodo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEditTodoDialog(todo: todo),
    );
  }

  void _deleteTodo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text(AppStrings.deleteTask),
        content: const Text(AppStrings.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel, style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              context.read<TodoProvider>().deleteTodo(todo.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.taskDeleted)),
              );
            },
            child: const Text(AppStrings.delete, style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
