import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/Pages/sign_up.dart';
import 'package:reddit/Services/chat_service.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Controllers/user_controller.dart';

void main() {
  setUp(() {
    GetIt.instance.registerLazySingleton<PostService>(() => PostService());
    GetIt.instance.registerLazySingleton<UserService>(() => UserService());
    GetIt.instance
        .registerLazySingleton<UserController>(() => UserController());
    GetIt.instance.registerLazySingleton<ChatsService>(() => ChatsService());
  });
  tearDown(() {
    GetIt.instance.reset();
  });

  group('SignUp Test', () {
    testWidgets('Valid Email, Username, Password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      // Find the TextFields
      var usernameField = find.byKey(Key('UsernameField'));
      var passwordField = find.byKey(Key('PasswordField'));
      var emailField = find.byKey(Key('EmailField'));
      var maleRadioField = find.byKey(Key('MaleRadio'));

      // Test entering text
      await tester.enterText(usernameField, 'abdullah');
      await tester.enterText(passwordField, 'abdullah1234');
      await tester.enterText(emailField, 'abdullah@gmail.com');
      await tester.tap(maleRadioField);

      // Verify that the text has been entered into the TextFields
      expect(find.text('abdullah'), findsOneWidget);
      //expect(find.text('password123'), findsOneWidget);
      expect(find.text('abdullah@gmail.com'), findsOneWidget);

      //click continue
      final continueButtonFinder = find.byKey(Key('Continue'));
      expect(continueButtonFinder, findsOneWidget);
      await tester.ensureVisible(continueButtonFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Signed up successfully!'), findsOneWidget);
    });
    testWidgets('Navigate to Login Page', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      final signupButtonFinder = find.text('Log In');

      expect(signupButtonFinder, findsOneWidget);

      await tester.ensureVisible(signupButtonFinder);

      await tester.tap(signupButtonFinder);

      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('InValid Email, valid Username,valid Password',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      var usernameField = find.byKey(Key('UsernameField'));
      var passwordField = find.byKey(Key('PasswordField'));
      var emailField = find.byKey(Key('EmailField'));
      var maleRadioField = find.byKey(Key('MaleRadio'));

      await tester.enterText(usernameField, 'abdullah');
      await tester.enterText(passwordField, 'abdullah1234');
      await tester.enterText(emailField, 'abdullah');
      await tester.tap(maleRadioField);
      final continueButtonFinder = find.byKey(Key('Continue'));
      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('Valid Email, valid Username,InValid Password',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      var usernameField = find.byKey(Key('UsernameField'));
      var passwordField = find.byKey(Key('PasswordField'));
      var emailField = find.byKey(Key('EmailField'));
      var maleRadioField = find.byKey(Key('MaleRadio'));

      await tester.enterText(usernameField, 'abdullah');
      await tester.enterText(passwordField, '1234');
      await tester.enterText(emailField, 'abdullah@gmail.com');
      await tester.tap(maleRadioField);
      final continueButtonFinder = find.byKey(Key('Continue'));
      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Password must be at least 8 characters long'),
          findsOneWidget);
    });
    testWidgets('Existing Email, Valid Username,Valid Password',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      var usernameField = find.byKey(Key('UsernameField'));
      var passwordField = find.byKey(Key('PasswordField'));
      var emailField = find.byKey(Key('EmailField'));
      var maleRadioField = find.byKey(Key('MaleRadio'));

      await tester.enterText(usernameField, 'rawan');
      await tester.enterText(passwordField, '12345678');
      await tester.enterText(emailField, 'rawan7544@gmail.com');
      await tester.tap(maleRadioField);
      final continueButtonFinder = find.byKey(Key('Continue'));
      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Email already exists'), findsOneWidget);
    });

    testWidgets('empty field Email, Valid Username,Valid Password',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      var usernameField = find.byKey(Key('UsernameField'));
      var passwordField = find.byKey(Key('PasswordField'));
      var emailField = find.byKey(Key('EmailField'));
      var maleRadioField = find.byKey(Key('MaleRadio'));

      await tester.enterText(usernameField, 'rawan');
      await tester.enterText(passwordField, '12345678');
      await tester.enterText(emailField, '');
      await tester.tap(maleRadioField);
      final continueButtonFinder = find.byKey(Key('Continue'));
      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Email is required'), findsOneWidget);
    });
    testWidgets('valid Email, empty field Username,Valid Password',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      var usernameField = find.byKey(Key('UsernameField'));
      var passwordField = find.byKey(Key('PasswordField'));
      var emailField = find.byKey(Key('EmailField'));
      var maleRadioField = find.byKey(Key('MaleRadio'));

      await tester.enterText(usernameField, '');
      await tester.enterText(passwordField, '12345678');
      await tester.enterText(emailField, 'r@gmail.com');
      await tester.tap(maleRadioField);
      final continueButtonFinder = find.byKey(Key('Continue'));
      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Username is required'), findsOneWidget);
    });
    testWidgets('valid Email, valid Username,empty field Password',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      var usernameField = find.byKey(Key('UsernameField'));
      var passwordField = find.byKey(Key('PasswordField'));
      var emailField = find.byKey(Key('EmailField'));
      var maleRadioField = find.byKey(Key('MaleRadio'));

      await tester.enterText(usernameField, 'roro');
      await tester.enterText(passwordField, '');
      await tester.enterText(emailField, 'r@gmail.com');
      await tester.tap(maleRadioField);
      final continueButtonFinder = find.byKey(Key('Continue'));
      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Password is required'), findsOneWidget);
    });
    testWidgets('username same as password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      var usernameField = find.byKey(Key('UsernameField'));
      var passwordField = find.byKey(Key('PasswordField'));
      var emailField = find.byKey(Key('EmailField'));
      var maleRadioField = find.byKey(Key('MaleRadio'));

      await tester.enterText(usernameField, 'roro1234');
      await tester.enterText(passwordField, 'roro1234');
      await tester.enterText(emailField, 'r@gmail.com');
      await tester.tap(maleRadioField);
      final continueButtonFinder = find.byKey(Key('Continue'));
      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Username cannot be same as password'), findsOneWidget);
    });

    testWidgets('Existing username', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

      var usernameField = find.byKey(Key('UsernameField'));
      var passwordField = find.byKey(Key('PasswordField'));
      var emailField = find.byKey(Key('EmailField'));
      var maleRadioField = find.byKey(Key('MaleRadio'));

      await tester.enterText(usernameField, 'Purple-7544');
      await tester.enterText(passwordField, '12345678');
      await tester.enterText(emailField, 'r@gmail.com');
      await tester.tap(maleRadioField);
      final continueButtonFinder = find.byKey(Key('Continue'));
      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Username already exists'), findsOneWidget);
    });
  });
}
