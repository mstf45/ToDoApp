import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/product/application/theme_cubit.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/container/product_container.dart';
import 'package:todoapp/product/application/session_cubit.dart';

import 'fake_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    if (ProductContainer.read<SessionCubit>().isClosed == false) {
      await ProductContainer.read<SessionCubit>().close();
    }
    if (ProductContainer.read<ThemeCubit>().isClosed == false) {
      await ProductContainer.read<ThemeCubit>().close();
    }
    await ProductContainer.reset();
  });

  testWidgets('Unauthenticated session opens the login page', (tester) async {
    await ProductContainer.setup(
      authService: FakeAuthService(),
      userProfileService: FakeUserProfileService(),
      todoService: FakeTodoService(),
    );

    await tester.pumpWidget(const TodoApp());
    await tester.pump();

    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.devEnvironmentLabel), findsOneWidget);
    expect(find.text(AppStrings.login), findsOneWidget);
    expect(find.text(AppStrings.signUp), findsOneWidget);
    expect(find.text(AppStrings.continueWithGoogle), findsOneWidget);

    final loginContext = tester.element(find.text(AppStrings.appTitle));
    expect(Theme.of(loginContext).brightness, Brightness.dark);

    await tester.tap(find.byTooltip(AppStrings.lightMode));
    await tester.pumpAndSettle();

    expect(Theme.of(tester.element(find.text(AppStrings.appTitle))).brightness, Brightness.light);
  });

  testWidgets(
      'Successful registration opens home and sign out returns to login',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await ProductContainer.setup(
      authService: FakeAuthService(),
      userProfileService: FakeUserProfileService(),
      todoService: FakeTodoService(),
    );

    await tester.pumpWidget(const TodoApp());
    await tester.pump();

    await tester.tap(find.text(AppStrings.signUp));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'ada');
    await tester.enterText(find.byType(TextField).at(1), 'ada@todo.app');
    await tester.enterText(find.byType(TextField).at(2), 'secret12');
    await tester.enterText(find.byType(TextField).at(3), 'secret12');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.signUp));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.todayTasks), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.noteSheetHint), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(find.byType(TextField).first, 'Yeni not');
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.add));
    await tester.pumpAndSettle();
    expect(find.text('Yeni not'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();
    await tester
        .tap(find.widgetWithText(CupertinoDialogAction, AppStrings.signOut));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.login), findsOneWidget);
  });
}
