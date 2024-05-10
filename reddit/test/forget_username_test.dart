import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit/Pages/forgot_username.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUp(() {
    if (!GetIt.I.isRegistered<UserService>()) {
      GetIt.I.registerSingleton<UserService>(UserService());
    }
  });

  testWidgets('ForgotUsernamePage widget test', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: Scaffold(body: ForgotUsernamePage())));
    expect(find.byType(ForgotUsernamePage), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Form validation test', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: Scaffold(body: ForgotUsernamePage())));
    Finder buttonFinder = find.byType(ElevatedButton);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();
    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is TextField &&
              widget.decoration?.errorText == 'Email is required',
        ),
        findsOneWidget);
    await tester.enterText(find.byType(TextField), 'invalid email');
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();
    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is TextField &&
              widget.decoration?.errorText ==
                  'Please enter a valid email address',
        ),
        findsOneWidget);
  });
  testWidgets('Email send test', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: Scaffold(body: ForgotUsernamePage())));
    Finder buttonFinder = find.byType(ElevatedButton);
    await tester.enterText(find.byType(TextField), 'rawan@gmail.com');
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();
    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is SnackBar &&
              widget.content is Text &&
              (widget.content as Text).data == 'Email will be send to you',
        ),
        findsOneWidget);
  });
}
