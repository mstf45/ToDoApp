import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/context_extension.dart';
import 'package:todoapp/feature/home/home/cubit/home_cubit.dart';
import 'package:todoapp/feature/home/home/cubit/home_state.dart';
import 'package:todoapp/feature/home/home/model/todo.dart';
import 'package:todoapp/feature/home/home/view/widget/home_empty_state.dart';
import 'package:todoapp/feature/home/home/view/widget/home_todo_tile.dart';
import 'package:todoapp/product/constants/app_strings.dart';

final class HomeTodoList extends StatelessWidget {
  const HomeTodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, (bool, List<Todo>, List<Todo>)>(
      selector: (state) => (state.isLoading, state.unsyncedTodos, state.backedUpTodos),
      builder: (context, data) {
        final (isLoading, unsynced, backedUp) = data;
        if (isLoading) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (unsynced.isEmpty && backedUp.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: HomeEmptyState(),
          );
        }

        return SliverMainAxisGroup(
          slivers: [
            if (unsynced.isNotEmpty) ...[
              const SliverToBoxAdapter(
                child: HomeTodoSectionTitle(title: AppStrings.unsyncedNotes, emphasized: true),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => HomeTodoTile(key: ValueKey(unsynced[index].id), todo: unsynced[index]),
                  childCount: unsynced.length,
                ),
              ),
            ],
            if (backedUp.isNotEmpty) ...[
              if (unsynced.isNotEmpty)
                const SliverToBoxAdapter(
                  child: HomeTodoSectionTitle(title: AppStrings.savedNotes),
                ),
              SliverReorderableList(
                itemCount: backedUp.length,
                onReorderItem: (oldIndex, newIndex) {
                  unawaited(context.read<HomeCubit>().reorderTodos(oldIndex, newIndex));
                },
                itemBuilder: (context, index) {
                  final todo = backedUp[index];
                  return ReorderableDelayedDragStartListener(
                    key: ValueKey(todo.id),
                    index: index,
                    child: HomeTodoTile(todo: todo),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

final class HomeTodoSectionTitle extends StatelessWidget {
  const HomeTodoSectionTitle({required this.title, this.emphasized = false, super.key});

  final String title;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final color = emphasized ? context.appThemeExtension.warning : context.colorScheme.onSurface;
    return Padding(
      padding: const AppPagePadding.sectionTitle(),
      child: Text(
        title,
        style: context.appTextTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
