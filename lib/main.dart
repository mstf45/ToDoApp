import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/constants/app_strings.dart';
import 'package:todoapp/firebase_options.dart';
import 'package:todoapp/pages/home.dart';
import 'package:todoapp/pages/login_page.dart';
import 'package:todoapp/providers/auth_provider.dart';
import 'package:todoapp/providers/todo_provider.dart';
import 'package:todoapp/services/auth_service.dart';
import 'package:todoapp/services/todo_service.dart';
import 'package:todoapp/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = AuthService();

  runApp(MyApp(
    authService: authService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({
    required this.authService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => TodoProvider(TodoService(authService)),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appTitle,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            home: auth.isLoading
                ? const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : auth.isAuthenticated
                    ? const HomePage()
                    : const LoginPage(),
          );
        },
      ),
    );
  }
}
