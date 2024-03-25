import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Controllers/user_controller.dart';

void main() {
  setUp(() {
    GetIt.instance.registerLazySingleton<PostService>(() => PostService());
    GetIt.instance.registerLazySingleton<UserService>(() => UserService());
    GetIt.instance.registerLazySingleton<UserController>(() => UserController());
  });
  tearDown(() {
    GetIt.instance.unregister<PostService>();
    GetIt.instance.unregister<UserService>();
    GetIt.instance.unregister<UserController>();
  });

  group('Login Test', () {
    testWidgets('Correct Username and', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.enterText(find.byType(TextField).first, 'Purple-7544');
      await tester.enterText(find.byType(TextField).last, 'rawan1234');

      await tester.pumpAndSettle();

      final continueButtonFinder = find.text('Continue');

      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);

      await tester.pump();

      await tester.tap(continueButtonFinder);

      await tester.pumpAndSettle();

      expect(find.text('Hot'), findsOneWidget);
    });

    testWidgets('Incorrect Username', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.enterText(find.byType(TextField).first, 'Purple');
      await tester.enterText(find.byType(TextField).last, 'rawan1234');

      await tester.pumpAndSettle();

      final continueButtonFinder = find.text('Continue');

      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);

      await tester.pump();

      await tester.tap(continueButtonFinder);

      await tester.pumpAndSettle();

      expect(find.text('Incorrect username or password'), findsOneWidget);
    });
    testWidgets('Incorrect Password', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.enterText(find.byType(TextField).first, 'Purple-7544');
      await tester.enterText(find.byType(TextField).last, 'rawan');

      await tester.pumpAndSettle();

      final continueButtonFinder = find.text('Continue');

      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);

      await tester.pump();

      await tester.tap(continueButtonFinder);

      await tester.pumpAndSettle();

      expect(find.text('Incorrect username or password'), findsOneWidget);
    });
  });
}