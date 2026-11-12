import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:todoapp/product/application/theme_cubit.dart';
import 'package:todoapp/product/application/theme_state.dart';
import 'package:todoapp/product/constants/app_strings.dart';

final class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeState, bool>(
      selector: (state) => state.isDark,
      builder: (context, isDark) {
        return IconButton(
          tooltip: isDark ? AppStrings.lightMode : AppStrings.darkMode,
          onPressed: () => unawaited(context.read<ThemeCubit>().toggle()),
          icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
        );
      },
    );
  }
}
