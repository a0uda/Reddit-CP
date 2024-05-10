import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:mockito/mockito.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/widgets/update_email.dart';

class MockUserController extends Mock implements UserController {}
class MockChangeEmail extends Mock implements ChangeEmail {}

void main() {
  group('UpdateEmail Widget Tests', () {
    late MockUserController mockUserController;
    late MockChangeEmail mockChangeEmail;

    setUp(() {
      mockUserController = MockUserController();
      mockChangeEmail = MockChangeEmail();
      GetIt.instance.registerSingleton<UserController>(mockUserController);
      when(mockUserController.userAbout).thenReturn(UserAbout(
        username: 'testUser',
        email: 'test@example.com',
        profilePicture: 'http://example.com/image.png'
      ));
    });

    testWidgets('test_email_validation', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<ChangeEmail>.value(
          value: mockChangeEmail,
          child: const UpdateEmail(),
        ),
      ));

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, '');
      await tester.pump();
      expect(find.text('Invalid email'), findsOneWidget);

      await tester.enterText(emailField, 'userexample.com');
      await tester.pump();
      expect(find.text('Invalid email'), findsOneWidget);

      await tester.enterText(emailField, 'user@example.com');
      await tester.pump();
      expect(find.text('Invalid email'), findsNothing);
    });

    testWidgets('test_prevent_same_email_update', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Provider<ChangeEmail>.value(
          value: mockChangeEmail,
          child: const UpdateEmail(),
        ),
      ));

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      final updateButton = find.text('Update Email');
      await tester.tap(updateButton);
      await tester.pump();

      expect(find.text('Email already in use'), findsOneWidget);
    });

    
  });
}