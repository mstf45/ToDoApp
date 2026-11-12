import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/core/theme/app_theme.dart';
import 'package:todoapp/feature/home/home/cubit/home_cubit.dart';
import 'package:todoapp/firebase_options.dart';
import 'package:todoapp/product/application/session_cubit.dart';
import 'package:todoapp/product/application/theme_cubit.dart';
import 'package:todoapp/product/application/theme_state.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/constants/app_theme_mode.dart';
import 'package:todoapp/product/container/product_container.dart';
import 'package:todoapp/product/environment/app_environment.dart';
import 'package:todoapp/product/logger/app_logger.dart';
import 'package:todoapp/product/logger/product_bloc_observer.dart';
import 'package:todoapp/product/service/todo_service.dart';
import 'package:todoapp/product/widget/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    Bloc.observer = const ProductBlocObserver();
  }
  AppLogger.info('starting flavor=${AppEnvironment.flavorName}');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ProductContainer.setup();
  AppLogger.info('ready flavor=${AppEnvironment.flavorName}');
  runApp(const TodoApp());
}

final class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: ProductContainer.read<SessionCubit>()),
        BlocProvider<ThemeCubit>.value(value: ProductContainer.read<ThemeCubit>()),
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(
            ProductContainer.read<ITodoService>(),
            ProductContainer.read<SessionCubit>(),
          ),
        ),
      ],
      child: BlocSelector<ThemeCubit, ThemeState, AppThemeMode>(
        selector: (state) => state.mode,
        builder: (context, mode) {
          return MaterialApp(
            debugShowCheckedModeBanner: kDebugMode,
            title: AppEnvironment.windowTitle(AppStrings.appTitle),
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode == AppThemeMode.light ? ThemeMode.light : ThemeMode.dark,
            builder: (context, child) {
              // flutter_slidable still builds legacy Material Icon and Text widgets.
              // ignore: deprecated_member_use
              return MaterialUiCompatibilityBridge(child: child!);
            },
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
