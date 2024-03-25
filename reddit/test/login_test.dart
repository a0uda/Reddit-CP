
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/responsive_layout.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Controllers/user_controller.dart';

void main() {
  setUp(() {
    // Register the UserService
    GetIt.instance.registerLazySingleton<PostService>(() => PostService());
    GetIt.instance.registerLazySingleton<UserService>(() => UserService());
    GetIt.instance
        .registerLazySingleton<UserController>(() => UserController());
  });
  tearDown(() {
    // Unregister the services and controllers after each test
    GetIt.instance.unregister<PostService>();
    GetIt.instance.unregister<UserService>();
    GetIt.instance.unregister<UserController>();
  });

  group('Login Test', () {
    testWidgets('Correct Username and', (WidgetTester tester) async {
      // Build the LoginPage widget
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.enterText(find.byType(TextField).first, 'Purple-7544');
      await tester.enterText(find.byType(TextField).last, 'rawan1234');

      // Wait for the UI to update
      await tester.pumpAndSettle();

      // Find the Continue button
      final continueButtonFinder = find.text('Continue');

      // Verify that the button is present
      expect(continueButtonFinder, findsOneWidget);

      // Scroll to make sure the button is visible
      await tester.ensureVisible(continueButtonFinder);

      // Wait for the widget to rebuild
      await tester.pump();

      // Tap the Continue button
      await tester.tap(continueButtonFinder);

      // Wait for the widget to rebuild after the tap
      await tester.pumpAndSettle();

      // Verify that the new page contains the text 'Hot'
      expect(find.text('Hot'), findsOneWidget);
    });

    testWidgets('Incorrect Username', (WidgetTester tester) async {
      // Build the LoginPage widget
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.enterText(find.byType(TextField).first, 'Purple');
      await tester.enterText(find.byType(TextField).last, 'rawan1234');

      // Wait for the UI to update
      await tester.pumpAndSettle();

      // Find the Continue button
      final continueButtonFinder = find.text('Continue');

      // Verify that the button is present
      expect(continueButtonFinder, findsOneWidget);

      // Scroll to make sure the button is visible
      await tester.ensureVisible(continueButtonFinder);

      // Wait for the widget to rebuild
      await tester.pump();

      // Tap the Continue button
      await tester.tap(continueButtonFinder);

      // Wait for the widget to rebuild after the tap
      await tester.pumpAndSettle();

      // Verify that the new page contains the text 'Hot'
      expect(find.text('Incorrect username or password'), findsOneWidget);
    });
    testWidgets('Incorrect Password', (WidgetTester tester) async {
      // Build the LoginPage widget
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.enterText(find.byType(TextField).first, 'Purple-7544');
      await tester.enterText(find.byType(TextField).last, 'rawan');

      // Wait for the UI to update
      await tester.pumpAndSettle();

      // Find the Continue button
      final continueButtonFinder = find.text('Continue');

      // Verify that the button is present
      expect(continueButtonFinder, findsOneWidget);

      // Scroll to make sure the button is visible
      await tester.ensureVisible(continueButtonFinder);

      // Wait for the widget to rebuild
      await tester.pump();

      // Tap the Continue button
      await tester.tap(continueButtonFinder);

      // Wait for the widget to rebuild after the tap
      await tester.pumpAndSettle();

      // Verify that the new page contains the text 'Hot'
      expect(find.text('Incorrect username or password'), findsOneWidget);
    });
  });
}
