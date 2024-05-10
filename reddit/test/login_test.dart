import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/Pages/sign_up.dart';
import 'package:reddit/Services/chat_service.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Pages/forgot_password.dart';
import 'package:reddit/Pages/forgot_username.dart';
import 'package:reddit/widgets/responsive_layout.dart';

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

  group('Login Test', () {
    testWidgets('Correct Username and Password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      await tester.enterText(find.byType(TextField).first, 'Purple-7544');
      await tester.enterText(find.byType(TextField).last, 'rawan1234');

      await tester.pumpAndSettle();

      final continueButtonFinder = find.text('Continue');

      expect(continueButtonFinder, findsOneWidget);

      await tester.ensureVisible(continueButtonFinder);

      await tester.pump();

      await tester.tap(continueButtonFinder);

      await tester.pumpAndSettle();
      expect(find.text('Incorrect username or password'), findsNothing);
    });

    testWidgets('Incorrect Username', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

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
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

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

    testWidgets('Navigate to Forgot Username Page',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final forgetUsernameFinder = find.text('Forgot Username?');

      expect(forgetUsernameFinder, findsOneWidget);

      await tester.ensureVisible(forgetUsernameFinder);

      await tester.tap(forgetUsernameFinder);

      await tester.pumpAndSettle();

      expect(find.byType(ForgotUsernamePage), findsOneWidget);
    });

    testWidgets('Navigate to Forgot Password Page',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final forgetUsernameFinder = find.text('Forgot Password?');

      expect(forgetUsernameFinder, findsOneWidget);

      await tester.ensureVisible(forgetUsernameFinder);

      await tester.tap(forgetUsernameFinder);

      await tester.pumpAndSettle();
      expect(find.byType(ForgotPasswordPage), findsOneWidget);
    });
    testWidgets('Navigate to Signup Page', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final signupButtonFinder = find.text('Sign Up');

      expect(signupButtonFinder, findsOneWidget);

      await tester.ensureVisible(signupButtonFinder);

      await tester.tap(signupButtonFinder);

      await tester.pumpAndSettle();

      expect(find.byType(SignUpPage), findsOneWidget);
    });
  });
}
