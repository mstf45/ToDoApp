import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/product/constants/app_theme_mode.dart';
import 'package:todoapp/product/constants/theme_storage_keys.dart';
import 'package:todoapp/product/service/theme_service.dart';

final class ThemeServiceImpl implements IThemeService {
  SharedPreferences? _preferences;

  @override
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  AppThemeMode readMode() {
    final stored = _preferences?.getString(ThemeStorageKeys.mode);
    return stored == ThemeStorageKeys.light ? AppThemeMode.light : AppThemeMode.dark;
  }

  @override
  Future<void> saveMode(AppThemeMode mode) async {
    final value = mode == AppThemeMode.light ? ThemeStorageKeys.light : ThemeStorageKeys.dark;
    await _preferences?.setString(ThemeStorageKeys.mode, value);
  }
}
