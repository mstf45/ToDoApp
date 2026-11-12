import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/product/application/theme_state.dart';
import 'package:todoapp/product/constants/app_theme_mode.dart';
import 'package:todoapp/product/service/theme_service.dart';

final class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._themeService) : super(ThemeState(mode: _themeService.readMode()));

  final IThemeService _themeService;

  Future<void> toggle() async {
    final next = state.isDark ? AppThemeMode.light : AppThemeMode.dark;
    emit(state.copyWith(mode: next));
    await _themeService.saveMode(next);
  }
}
