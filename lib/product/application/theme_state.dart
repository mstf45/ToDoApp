import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:todoapp/product/constants/app_theme_mode.dart';

@immutable
final class ThemeState extends Equatable {
  const ThemeState({this.mode = AppThemeMode.dark});

  final AppThemeMode mode;

  bool get isDark => mode == AppThemeMode.dark;

  ThemeState copyWith({AppThemeMode? mode}) {
    return ThemeState(mode: mode ?? this.mode);
  }

  @override
  List<Object?> get props => [mode];
}
