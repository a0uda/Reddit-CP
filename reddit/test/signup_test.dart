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
  });
}
