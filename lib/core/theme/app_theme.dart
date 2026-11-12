import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:todoapp/core/theme/app_color_scheme.dart';
import 'package:todoapp/core/theme/app_colors.dart';
import 'package:todoapp/core/theme/app_opacities.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/app_text_styles.dart';
import 'package:todoapp/core/theme/app_theme_extension.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return _build(
      scheme: AppColorScheme.light,
      themeExtension: AppThemeExtension.light,
      scaffoldColor: AppColors.lightBackground,
      inputFill: AppColors.lightSurfaceElevated,
      appBarColor: AppColors.lightSurface,
    );
  }

  static ThemeData get darkTheme {
    return _build(
      scheme: AppColorScheme.dark,
      themeExtension: AppThemeExtension.dark,
      scaffoldColor: AppColors.darkBackground,
      inputFill: AppColors.darkSurfaceElevated,
      appBarColor: AppColors.darkBackground,
    );
  }

  static ThemeData _build({
    required ColorScheme scheme,
    required AppThemeExtension themeExtension,
    required Color scaffoldColor,
    required Color inputFill,
    required Color appBarColor,
  }) {
    const border = OutlineInputBorder(
      borderRadius: AppRadius.mediumAll,
      borderSide: BorderSide(color: Colors.transparent),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldColor,
      extensions: <ThemeExtension<dynamic>>[themeExtension],
      textTheme: _textTheme(scheme),
      appBarTheme: AppBarTheme(
        backgroundColor: appBarColor,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: scheme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
          statusBarBrightness: scheme.brightness,
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.onSurface.withValues(alpha: AppOpacities.divider)),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding: const AppPagePadding.horizontal16(),
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumAll,
          borderSide: BorderSide(color: scheme.primary, width: AppSizes.borderWidth),
        ),
        hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: AppOpacities.hint)),
        prefixIconColor: scheme.primary,
        suffixIconColor: scheme.onSurface.withValues(alpha: AppOpacities.hint),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.primary.withValues(alpha: AppOpacities.hint),
          minimumSize: const Size(AppSizes.buttonHeight, AppSizes.buttonHeight),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mediumAll),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size(AppSizes.buttonHeight, AppSizes.buttonHeight),
          side: BorderSide(color: scheme.onSurface.withValues(alpha: AppOpacities.border)),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mediumAll),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.secondary,
          foregroundColor: scheme.onSecondary,
          minimumSize: const Size(AppSizes.buttonHeight, AppSizes.buttonHeight),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mediumAll),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: AppSizes.gap8,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mediumAll),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mediumAll),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.topLarge),
      ),
      popupMenuTheme: PopupMenuThemeData(color: scheme.surface),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: AppTextStyles.displayLargeSize,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: AppTextStyles.displayMediumSize,
        fontWeight: FontWeight.bold,
        color: scheme.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: AppTextStyles.titleLargeSize,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: AppTextStyles.titleMediumSize,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: AppTextStyles.bodyLargeSize,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTextStyles.bodySize,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface.withValues(alpha: AppOpacities.muted),
      ),
      bodySmall: TextStyle(
        fontSize: AppTextStyles.captionSize,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface.withValues(alpha: AppOpacities.hint),
      ),
    );
  }
}
