import 'package:material_ui/material_ui.dart';
import 'package:todoapp/core/theme/app_theme_extension.dart';

extension BuildContextThemeExtension on BuildContext {
  ThemeData get appTheme => Theme.of(this);

  ColorScheme get colorScheme => appTheme.colorScheme;

  TextTheme get appTextTheme => appTheme.textTheme;

  AppThemeExtension get appThemeExtension => appTheme.extension<AppThemeExtension>()!;
}
