import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoapp/core/theme/app_durations.dart';
import 'package:todoapp/core/theme/app_opacities.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/context_extension.dart';
import 'package:todoapp/feature/home/home/cubit/home_cubit.dart';
import 'package:todoapp/feature/home/home/model/todo.dart';
import 'package:todoapp/feature/home/home/view/todo_detail_page.dart';
import 'package:todoapp/feature/home/home/view/widget/add_edit_todo_sheet.dart';
import 'package:todoapp/product/constants/app_strings.dart';

final class TodoCheckMark extends StatelessWidget {
  const TodoCheckMark({required this.completed, required this.color, super.key});

  final bool completed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.check,
      width: AppSizes.checkbox,
      height: AppSizes.checkbox,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: AppSizes.borderWidth),
        color: completed ? color : Colors.transparent,
      ),
      child: completed ? Icon(Icons.check, size: AppSizes.checkIcon, color: context.colorScheme.onPrimary) : null,
    );
  }
}

final class HomeTodoTile extends StatelessWidget {
  const HomeTodoTile({required this.todo, super.key});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final brand = context.appThemeExtension.brandPrimary;
    final completed = todo.isCompleted;

    return Padding(
      padding: const AppPagePadding.tile(),
      child: Slidable(
        key: ValueKey(todo.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _edit(context),
              backgroundColor: brand,
              foregroundColor: context.colorScheme.onPrimary,
              icon: Icons.edit,
              label: AppStrings.edit,
              borderRadius: AppRadius.leftMedium,
            ),
            SlidableAction(
              onPressed: (_) => _confirmDelete(context),
              backgroundColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.onError,
              icon: Icons.delete,
              label: AppStrings.delete,
              borderRadius: AppRadius.rightMedium,
            ),
          ],
        ),
        child: Material(
          color: context.appThemeExtension.surfaceElevated,
          borderRadius: AppRadius.largeAll,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => unawaited(TodoDetailPage.open(context, todoId: todo.id)),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  SizedBox(
                    width: AppSizes.accentWidth,
                    child: ColoredBox(color: completed ? context.appThemeExtension.success : brand),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const AppPagePadding.tileContent(),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => unawaited(context.read<HomeCubit>().toggleTodo(todo.id)),
                            child: TodoCheckMark(
                              completed: completed,
                              color: completed ? context.appThemeExtension.success : brand,
                            ),
                          ),
                          const SizedBox(width: AppSizes.gap16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  completed ? AppStrings.completed : AppStrings.pending,
                                  style: context.appTextTheme.bodySmall?.copyWith(
                                    color: completed ? context.appThemeExtension.success : brand,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.gap8),
                                Text(
                                  todo.title,
                                  style: context.appTextTheme.titleMedium?.copyWith(
                                    decoration: completed ? TextDecoration.lineThrough : TextDecoration.none,
                                    decorationColor: context.colorScheme.onSurface.withValues(alpha: AppOpacities.hint),
                                    color: completed
                                        ? context.colorScheme.onSurface.withValues(alpha: AppOpacities.muted)
                                        : context.colorScheme.onSurface,
                                  ),
                                ),
                                if (todo.description.isNotEmpty) ...[
                                  const SizedBox(height: AppSizes.gap8),
                                  Text(
                                    todo.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.appTextTheme.bodySmall,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showMenu(context),
                            icon: Icon(
                              Icons.more_horiz,
                              color: context.colorScheme.onSurface.withValues(alpha: AppOpacities.icon),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) {
          return Padding(
            padding: const AppPagePadding.sheet(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.edit, color: context.appThemeExtension.brandPrimary),
                  title: const Text(AppStrings.edit),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _edit(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: context.colorScheme.error),
                  title: const Text(AppStrings.delete),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _confirmDelete(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _edit(BuildContext context) {
    unawaited(
      AddEditTodoSheet.show(context, todo: todo),
    );
  }

  void _confirmDelete(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text(AppStrings.deleteTask),
            content: const Text(AppStrings.confirmDelete),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  unawaited(context.read<HomeCubit>().deleteTodo(todo.id));
                },
                child: Text(AppStrings.delete, style: TextStyle(color: context.colorScheme.error)),
              ),
            ],
          );
        },
      ),
    );
  }
}
