import 'package:material_ui/material_ui.dart';
import 'package:todoapp/core/theme/app_colors.dart';

final class AppColorScheme {
  const AppColorScheme._();

  static ColorScheme get light {
    return const ColorScheme.light().copyWith(
      primary: AppColors.brandPrimary,
      onPrimary: AppColors.darkOnSurface,
      secondary: AppColors.brandAccent,
      onSecondary: AppColors.lightOnSurface,
      error: AppColors.error,
      onError: AppColors.darkOnSurface,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
    );
  }

  static ColorScheme get dark {
    return const ColorScheme.dark().copyWith(
      primary: AppColors.brandPrimary,
      onPrimary: AppColors.darkOnSurface,
      secondary: AppColors.brandAccent,
      onSecondary: AppColors.darkBackground,
      error: AppColors.error,
      onError: AppColors.darkOnSurface,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
    );
  }
}
