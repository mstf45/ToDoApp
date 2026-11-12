import 'package:flutter_test/flutter_test.dart';
import 'package:todoapp/product/environment/app_environment.dart';

void main() {
  test('flavor defaults to development', () {
    expect(AppEnvironment.isDev, isTrue);
    expect(AppEnvironment.isProd, isFalse);
    expect(AppEnvironment.flavorName, AppEnvironment.devName);
    expect(AppEnvironment.windowTitle('Todo App'), 'Todo App (dev)');
  });
}
