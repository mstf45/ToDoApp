import 'package:todoapp/product/application/session_cubit.dart';
import 'package:todoapp/product/application/theme_cubit.dart';
import 'package:todoapp/product/service/auth_service.dart';
import 'package:todoapp/product/service/connectivity_service.dart';
import 'package:todoapp/product/service/impl/auth_service_impl.dart';
import 'package:todoapp/product/service/impl/connectivity_service_impl.dart';
import 'package:todoapp/product/service/impl/theme_service_impl.dart';
import 'package:todoapp/product/service/impl/todo_service_impl.dart';
import 'package:todoapp/product/service/impl/user_profile_service_impl.dart';
import 'package:todoapp/product/service/theme_service.dart';
import 'package:todoapp/product/service/todo_service.dart';
import 'package:todoapp/product/service/user_profile_service.dart';
import 'package:get_it/get_it.dart';

final class ProductContainer {
  const ProductContainer._();

  static final GetIt _instance = GetIt.instance;
  static bool _isReady = false;

  static Future<void> setup({
    IAuthService? authService,
    IUserProfileService? userProfileService,
    ITodoService? todoService,
    IThemeService? themeService,
    IConnectivityService? connectivityService,
  }) async {
    if (_isReady) return;

    final IConnectivityService connectivity = connectivityService ?? ConnectivityServiceImpl();
    final ITodoService todos = todoService ?? TodoServiceImpl(connectivity: connectivity);
    final IThemeService theme = themeService ?? ThemeServiceImpl();
    await todos.init();
    await theme.init();

    _instance
      ..registerLazySingleton<IAuthService>(() => authService ?? AuthServiceImpl())
      ..registerLazySingleton<IUserProfileService>(() => userProfileService ?? UserProfileServiceImpl())
      ..registerLazySingleton<IConnectivityService>(() => connectivity)
      ..registerLazySingleton<ITodoService>(() => todos)
      ..registerLazySingleton<IThemeService>(() => theme)
      ..registerLazySingleton<SessionCubit>(() => SessionCubit(_instance.get<IAuthService>()))
      ..registerLazySingleton<ThemeCubit>(() => ThemeCubit(_instance.get<IThemeService>()));

    _instance.get<SessionCubit>();
    _instance.get<ThemeCubit>();
    _isReady = true;
  }

  static T read<T extends Object>() => _instance.get<T>();

  static Future<void> reset() async {
    await _instance.reset();
    _isReady = false;
  }
}
