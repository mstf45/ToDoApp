part of '../home_page.dart';

mixin HomePageMixin on State<HomePage> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onAddPressed() {
    unawaited(AddEditTodoSheet.show(context));
  }

  Future<void> onDeleteAllPressed() async {
    final shouldDelete = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text(AppStrings.deleteAllTasks),
          content: const Text(AppStrings.confirmDeleteAll),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(AppStrings.delete),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true || !mounted) return;
    await context.read<HomeCubit>().deleteAllTodos();
  }

  Future<void> onSignOutPressed() async {
    final shouldSignOut = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text(AppStrings.signOut),
          content: const Text(AppStrings.confirmSignOut),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(AppStrings.signOut),
            ),
          ],
        );
      },
    );
    if (shouldSignOut != true || !mounted) return;
    await context.read<SessionCubit>().signOut();
  }
}
