import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/product_text.dart';
import 'package:todoapp/feature/home/home/cubit/home_cubit.dart';
import 'package:todoapp/feature/home/home/model/todo.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/widget/product_toast.dart';

final class AddEditTodoSheet extends StatefulWidget {
  const AddEditTodoSheet({this.todo, super.key});

  final Todo? todo;

  static Future<void> show(BuildContext context, {Todo? todo}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => AddEditTodoSheet(todo: todo),
    );
  }

  @override
  State<AddEditTodoSheet> createState() => AddEditTodoSheetState();
}

final class AddEditTodoSheetState extends State<AddEditTodoSheet> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  bool get isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo?.title ?? '');
    descriptionController = TextEditingController(text: widget.todo?.description ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void onSavePressed() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    if (title.isEmpty) {
      ProductToast.show(context, AppStrings.emptyTitleError, isError: true);
      return;
    }

    final cubit = context.read<HomeCubit>();
    final current = widget.todo;
    if (current == null) {
      unawaited(cubit.addTodo(title: title, description: description));
    } else {
      unawaited(cubit.updateTodo(id: current.id, title: title, description: description));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: const AppPagePadding.all24().copyWith(bottom: AppSizes.gap24 + keyboard),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductText.h3(context, isEditing ? AppStrings.editTask : AppStrings.addNewTask),
          const SizedBox(height: AppSizes.gap8),
          ProductText.body(context, AppStrings.noteSheetHint),
          const SizedBox(height: AppSizes.gap24),
          TextField(
            controller: titleController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: AppStrings.taskTitle,
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: AppSizes.gap16),
          TextField(
            controller: descriptionController,
            minLines: 3,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: AppStrings.taskDescription,
              prefixIcon: Icon(Icons.notes),
            ),
          ),
          const SizedBox(height: AppSizes.gap24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSavePressed,
              child: Text(isEditing ? AppStrings.update : AppStrings.add),
            ),
          ),
        ],
      ),
    );
  }
}
