import 'package:todoapp/product/constants/app_theme_mode.dart';

abstract interface class IThemeService {
  Future<void> init();

  AppThemeMode readMode();

  Future<void> saveMode(AppThemeMode mode);
}
