import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit/pages/settings_screen.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:mockito/mockito.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/widgets/custom_settings_tile.dart';
import 'package:reddit/widgets/update_email.dart';

class MockUserController extends Mock implements UserController {}

void main() {
  final getIt = GetIt.instance;

  setUp(() {
    getIt.registerSingleton<UserController>(MockUserController());
  });

  tearDown(() {
    getIt.unregister<UserController>();
  });

  testWidgets('SettingsScreen navigates to UpdateEmail',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: SettingsScreen()));

    // Wait for animations to complete
    await tester.pumpAndSettle();

    // Find the 'Update email address' tile by type and tap it
    final updateEmailTileFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is CustomSettingsTile &&
          widget.title == 'Update email address',
    );
    await tester.pumpAndSettle();
    await tester.tap(updateEmailTileFinder);
    await tester.pumpAndSettle();

    // Verify that the UpdateEmail screen is displayed
    expect(find.byType(UpdateEmail), findsOneWidget);
  });

  testWidgets('SettingsScreen navigates to ResetPassword',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen()));
    await tester.tap(find.text('Change password'));
    await tester.pumpAndSettle();

    expect(find.text('Change password'), findsOneWidget);
  });

  testWidgets('SettingsScreen navigates to NotificationsSettings',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen()));
    await tester.tap(find.text('Manage notifications'));
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
  });

  testWidgets('SettingsScreen navigates to ManageBlockedAccounts',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen()));
    await tester.tap(find.text('Manage blocked accounts'));
    await tester.pumpAndSettle();

    expect(find.text('Manage Blocked Accounts'), findsOneWidget);
  });

  // Add more tests for each SettingsTile that navigates to a new screen
}
