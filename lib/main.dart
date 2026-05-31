import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/pages/home.dart';
import 'package:todoapp/providers/todo_provider.dart';
import 'package:todoapp/services/todo_service.dart';
import 'package:todoapp/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final todoService = TodoService();
  await todoService.init();
  runApp(MyApp(todoService: todoService));
}

class MyApp extends StatelessWidget {
  final TodoService todoService;

  const MyApp({required this.todoService, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoProvider(todoService)..loadTodos(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const HomePage(),
      ),
    );
  }
}
