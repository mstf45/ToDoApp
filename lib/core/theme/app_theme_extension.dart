import 'package:material_ui/material_ui.dart';
import 'package:todoapp/core/theme/app_colors.dart';

@immutable
final class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.brandPrimary,
    required this.success,
    required this.warning,
    required this.shimmer,
    required this.surfaceElevated,
  });

  final Color brandPrimary;
  final Color success;
  final Color warning;
  final Color shimmer;
  final Color surfaceElevated;

  static const AppThemeExtension light = AppThemeExtension(
    brandPrimary: AppColors.brandPrimary,
    success: AppColors.success,
    warning: AppColors.warning,
    shimmer: AppColors.lightSurfaceElevated,
    surfaceElevated: AppColors.lightSurfaceElevated,
  );

  static const AppThemeExtension dark = AppThemeExtension(
    brandPrimary: AppColors.brandPrimary,
    success: AppColors.success,
    warning: AppColors.warning,
    shimmer: AppColors.shimmer,
    surfaceElevated: AppColors.darkSurfaceElevated,
  );

  @override
  AppThemeExtension copyWith({
    Color? brandPrimary,
    Color? success,
    Color? warning,
    Color? shimmer,
    Color? surfaceElevated,
  }) {
    return AppThemeExtension(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      shimmer: shimmer ?? this.shimmer,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      shimmer: Color.lerp(shimmer, other.shimmer, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
    );
  }
}
