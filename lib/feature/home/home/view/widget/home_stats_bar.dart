import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/core/theme/app_opacities.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/app_text_styles.dart';
import 'package:todoapp/core/theme/context_extension.dart';
import 'package:todoapp/feature/home/home/cubit/home_cubit.dart';
import 'package:todoapp/feature/home/home/cubit/home_state.dart';
import 'package:todoapp/product/constants/app_strings.dart';

final class HomeStatsBar extends StatelessWidget {
  const HomeStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, (bool, int, int, int)>(
      selector: (state) => (state.showStats, state.totalCount, state.completedCount, state.pendingCount),
      builder: (context, data) {
        final (show, total, completed, pending) = data;
        if (!show) return const SliverToBoxAdapter(child: SizedBox.shrink());

        final brand = context.appThemeExtension.brandPrimary;
        return SliverToBoxAdapter(
          child: Padding(
            padding: const AppPagePadding.stats(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    brand.withValues(alpha: AppOpacities.soft),
                    brand.withValues(alpha: AppOpacities.divider),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppRadius.mediumAll,
                border: Border.all(color: brand.withValues(alpha: AppOpacities.border)),
              ),
              child: Padding(
                padding: const AppPagePadding.vertical16(),
                child: Row(
                  children: [
                    HomeStatItem(
                      label: AppStrings.total,
                      value: '$total',
                      color: context.colorScheme.onSurface,
                      icon: Icons.list,
                    ),
                    const HomeStatsDivider(),
                    HomeStatItem(
                      label: AppStrings.completed,
                      value: '$completed',
                      color: context.appThemeExtension.success,
                      icon: Icons.check_circle,
                    ),
                    const HomeStatsDivider(),
                    HomeStatItem(
                      label: AppStrings.pending,
                      value: '$pending',
                      color: context.appThemeExtension.warning,
                      icon: Icons.schedule,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

final class HomeStatItem extends StatelessWidget {
  const HomeStatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    super.key,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSizes.iconMedium),
          const SizedBox(height: AppSizes.gap8),
          Text(
            value,
            style: TextStyle(fontSize: AppTextStyles.statValueSize, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: AppSizes.gap8),
          Text(label, style: context.appTextTheme.bodySmall),
        ],
      ),
    );
  }
}

final class HomeStatsDivider extends StatelessWidget {
  const HomeStatsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.dividerWidth,
      height: AppSizes.dividerHeight,
      color: context.colorScheme.onSurface.withValues(alpha: AppOpacities.divider),
    );
  }
}
