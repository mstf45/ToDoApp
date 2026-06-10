import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/constants/app_strings.dart';
import 'package:todoapp/dialogs/add_edit_todo_dialog.dart';
import 'package:todoapp/providers/auth_provider.dart';
import 'package:todoapp/providers/todo_provider.dart';
import 'package:todoapp/theme/app_theme.dart';
import 'package:todoapp/widgets/modern_todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  bool _hasLoadedTodos = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedTodos) {
      _hasLoadedTodos = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<TodoProvider>().loadTodos();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Consumer2<AuthProvider, TodoProvider>(
        builder: (context, authProvider, todoProvider, child) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(context, authProvider, todoProvider),
              if (todoProvider.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                )
              else if (!todoProvider.isEmpty) ...[
                _buildStatsBar(todoProvider),
                SliverReorderableList(
                  onReorder: (oldIndex, newIndex) async {
                    final ok =
                        await todoProvider.reorderTodos(oldIndex, newIndex);
                    if (!ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(AppStrings.saveFailed)),
                      );
                    }
                  },
                  itemBuilder: (context, index) {
                    final todo = todoProvider.todos[index];
                    return ReorderableDelayedDragStartListener(
                      key: ValueKey(todo.id),
                      index: index,
                      child: ModernTodoTile(todo: todo),
                    );
                  },
                  itemCount: todoProvider.todos.length,
                ),
              ] else
                SliverFillRemaining(
                  child: _buildEmptyState(context),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  SliverAppBar _buildAppBar(
    BuildContext context,
    AuthProvider authProvider,
    TodoProvider todoProvider,
  ) {
    return SliverAppBar(
      backgroundColor: AppTheme.bgDark,
      elevation: 0,
      floating: true,
      pinned: false,
      toolbarHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.todayTasks,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 2),
          Text(
            authProvider.user?.displayName ?? authProvider.user?.email ?? '',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${todoProvider.totalCount} ${AppStrings.task}',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white54,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      titleSpacing: 16,
      actions: [
        if (!todoProvider.isEmpty)
          PopupMenuButton(
            color: AppTheme.surfaceDark,
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => _showDeleteAllDialog(context, todoProvider),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline,
                        color: AppTheme.errorColor, size: 18),
                    SizedBox(width: 8),
                    Text(AppStrings.deleteAllTasks,
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        IconButton(
          onPressed: () {
            authProvider.signOut();
            todoProvider.clearTodos();
          },
          icon: const Icon(Icons.logout),
          tooltip: AppStrings.logout,
        ),
      ],
    );
  }

  Widget _buildStatsBar(TodoProvider todoProvider) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.15),
                AppTheme.accentColor.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              _StatItem(
                label: AppStrings.total,
                value: todoProvider.totalCount.toString(),
                color: Colors.white,
                icon: Icons.list,
              ),
              _VerticalDivider(),
              _StatItem(
                label: AppStrings.completed,
                value: todoProvider.completedCount.toString(),
                color: AppTheme.successColor,
                icon: Icons.check_circle,
              ),
              _VerticalDivider(),
              _StatItem(
                label: AppStrings.pending,
                value: todoProvider.pendingCount.toString(),
                color: AppTheme.warningColor,
                icon: Icons.schedule,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset(
              'assets/lottie/success.json',
              repeat: false,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.noTasks,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.addFirstTask,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddEditTodoDialog(),
    );
  }

  void _showDeleteAllDialog(BuildContext context, TodoProvider todoProvider) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(AppStrings.deleteAllTasks),
        content: const Text(AppStrings.confirmDeleteAll),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              final ok = await todoProvider.deleteAllTodos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(ok
                        ? AppStrings.allTasksDeleted
                        : AppStrings.saveFailed)),
              );
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      color: Colors.white.withOpacity(0.1),
    );
  }
}
