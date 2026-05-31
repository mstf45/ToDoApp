// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/services/todo_service.dart';

void main() {
  testWidgets('Todo app smoke test', (WidgetTester tester) async {
    final todoService = TodoService();
    await todoService.init();

    await tester.pumpWidget(MyApp(todoService: todoService));

    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.add), findsWidgets);
  });
}
