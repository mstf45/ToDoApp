part of '../../home_page.dart';

final class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final page = context.findAncestorStateOfType<HomePageState>()!;

    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          current.feedbackTick != previous.feedbackTick,
      listener: (context, state) {
        ProductToast.show(context, state.feedbackMessage,
            isError: state.feedbackIsError);
      },
      child: Scaffold(
        body: CustomScrollView(
          controller: page.scrollController,
          slivers: const [
            HomeAppBar(),
            HomeStatsBar(),
            HomeTodoList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: page.onAddPressed,
          child: const Icon(Icons.add, size: AppSizes.iconMedium),
        ),
      ),
    );
  }
}

final class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final page = context.findAncestorStateOfType<HomePageState>()!;

    return SliverAppBar(
      floating: true,
      pinned: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductText.h2(context, AppStrings.todayTasks),
          const SizedBox(height: AppSizes.gap8),
          const HomeTaskSubtitle(),
        ],
      ),
      actions: [
        const ThemeModeButton(),
        IconButton(
          tooltip: AppStrings.signOut,
          onPressed: () => unawaited(page.onSignOutPressed()),
          icon: const Icon(Icons.logout),
        ),
        BlocSelector<HomeCubit, HomeState, bool>(
          selector: (state) => state.totalCount > 0,
          builder: (context, hasTodos) {
            return Padding(
              padding: const AppPagePadding.menu(),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == AppStrings.deleteAllTasks) {
                    unawaited(page.onDeleteAllPressed());
                    return;
                  }
                  if (value == AppStrings.signOut) {
                    unawaited(page.onSignOutPressed());
                  }
                },
                itemBuilder: (context) {
                  return [
                    if (hasTodos)
                      PopupMenuItem<String>(
                        value: AppStrings.deleteAllTasks,
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: context.colorScheme.error,
                              size: AppSizes.iconSmall,
                            ),
                            const SizedBox(width: AppSizes.gap8),
                            const Text(AppStrings.deleteAllTasks),
                          ],
                        ),
                      ),
                    PopupMenuItem<String>(
                      value: AppStrings.signOut,
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: context.colorScheme.onSurface,
                            size: AppSizes.iconSmall,
                          ),
                          const SizedBox(width: AppSizes.gap8),
                          const Text(AppStrings.signOut),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

final class HomeTaskSubtitle extends StatelessWidget {
  const HomeTaskSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, int>(
      selector: (state) => state.totalCount,
      builder: (context, total) {
        return BlocSelector<SessionCubit, SessionState, String>(
          selector: (state) => state.user?.email ?? '',
          builder: (context, email) {
            final countLabel = '$total ${AppStrings.task}';
            final label = email.isEmpty
                ? countLabel
                : '$countLabel${AppStrings.subtitleSeparator}$email';
            return ProductText.caption(context, label);
          },
        );
      },
    );
  }
}
