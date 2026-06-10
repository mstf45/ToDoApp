import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/constants/app_strings.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/providers/todo_provider.dart';
import 'package:todoapp/theme/app_theme.dart';

class AddEditTodoDialog extends StatefulWidget {
  final Todo? todo;

  const AddEditTodoDialog({this.todo, super.key});

  @override
  State<AddEditTodoDialog> createState() => _AddEditTodoDialogState();
}

class _AddEditTodoDialogState extends State<AddEditTodoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return Dialog(
      backgroundColor: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? AppStrings.editTask : AppStrings.addNewTask,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: AppStrings.taskTitle,
                  prefixIcon: const Icon(Icons.title, color: AppTheme.primaryColor),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: AppStrings.taskDescription,
                  prefixIcon: const Icon(Icons.description, color: AppTheme.primaryColor),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      AppStrings.cancel,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _saveTask,
                    child: Text(isEditing ? AppStrings.update : AppStrings.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.emptyTitleError)),
      );
      return;
    }

    final provider = context.read<TodoProvider>();
    bool ok = true;

    if (widget.todo == null) {
      ok = await provider.addTodo(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
    } else {
      ok = await provider.updateTodo(
        id: widget.todo!.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
    }

    Navigator.pop(context);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.saveFailed)),
      );
    }
  }
}
