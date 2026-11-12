import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:todoapp/core/theme/app_opacities.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/context_extension.dart';
import 'package:todoapp/core/theme/product_text.dart';
import 'package:todoapp/feature/home/home/cubit/home_cubit.dart';
import 'package:todoapp/feature/home/home/cubit/home_state.dart';
import 'package:todoapp/feature/home/home/model/todo.dart';
import 'package:todoapp/feature/home/home/view/widget/add_edit_todo_sheet.dart';
import 'package:todoapp/product/constants/app_strings.dart';

final class TodoDetailPage extends StatelessWidget {
  const TodoDetailPage({required this.todoId, super.key});

  final String todoId;

  static Future<void> open(BuildContext context, {required String todoId}) {
    return Navigator.of(context).push<void>(
      CupertinoPageRoute<void>(builder: (_) => TodoDetailPage(todoId: todoId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) {
        final hadTodo = previous.todos.any((todo) => todo.id == todoId);
        final hasTodo = current.todos.any((todo) => todo.id == todoId);
        return hadTodo && !hasTodo;
      },
      listener: (context, state) {
        Navigator.of(context).pop();
      },
      child: BlocSelector<HomeCubit, HomeState, Todo?>(
        selector: (state) => _todoById(state.todos, todoId),
        builder: (context, todo) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.todoDetail),
              actions: [
                if (todo != null)
                  IconButton(
                    tooltip: AppStrings.edit,
                    onPressed: () =>
                        unawaited(AddEditTodoSheet.show(context, todo: todo)),
                    icon: const Icon(Icons.edit),
                  ),
              ],
            ),
            body: todo == null
                ? const SizedBox.shrink()
                : TodoDetailBody(todo: todo),
          );
        },
      ),
    );
  }
}

final class TodoDetailBody extends StatelessWidget {
  const TodoDetailBody({required this.todo, super.key});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final completed = todo.isCompleted;
    final accent = completed
        ? context.appThemeExtension.success
        : context.appThemeExtension.brandPrimary;
    final description = todo.description.trim();

    return ListView(
      padding: const AppPagePadding.all24(),
      children: [
        Row(
          children: [
            Icon(
              completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: accent,
              size: AppSizes.iconMedium,
            ),
            const SizedBox(width: AppSizes.gap8),
            Text(
              completed ? AppStrings.completed : AppStrings.pending,
              style: context.appTextTheme.titleSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.gap24),
        ProductText.h2(context, todo.title),
        const SizedBox(height: AppSizes.gap16),
        Text(
          description.isEmpty ? AppStrings.noDescription : description,
          style: context.appTextTheme.bodyLarge?.copyWith(
            color: description.isEmpty
                ? context.colorScheme.onSurface.withValues(
                    alpha: AppOpacities.muted,
                  )
                : context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSizes.gap32),
        TodoDetailMeta(
          label: AppStrings.createdAt,
          value: formatTodoDate(todo.createdAt),
        ),
        if (todo.updatedAt != null) ...[
          const SizedBox(height: AppSizes.gap16),
          TodoDetailMeta(
            label: AppStrings.updatedAt,
            value: formatTodoDate(todo.updatedAt!),
          ),
        ],
      ],
    );
  }
}

final class TodoDetailMeta extends StatelessWidget {
  const TodoDetailMeta({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductText.caption(context, label),
        const SizedBox(height: AppSizes.gap8),
        Text(value, style: context.appTextTheme.bodyMedium),
      ],
    );
  }
}

Todo? _todoById(List<Todo> todos, String id) {
  for (final todo in todos) {
    if (todo.id == id) return todo;
  }
  return null;
}

String formatTodoDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day.$month.${local.year} $hour:$minute';
}
