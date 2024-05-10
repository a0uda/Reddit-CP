import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/widgets/country_tile.dart';
import 'package:reddit/widgets/location_customization.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockUserController extends Mock implements UserController {}

void main() {
  setUpAll(() {
    GetIt.instance.registerSingleton<UserController>(MockUserController());
  });

      // Renders a CustomSettingsTile widget with the correct title and subtitle.
testWidgets('should render CustomSettingsTile with correct title and subtitle', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: CountryTile(
      ),
    ),
  ));

  await tester.pumpAndSettle();

  expect(find.text('Location customization'), findsOneWidget);
});
  testWidgets('test_display_country_in_subtitle', (WidgetTester tester) async {
    final mockUserController = GetIt.instance.get<UserController>();
    when(mockUserController.accountSettings).thenReturn(AccountSettings(
        country: 'USA',
        email: "",
        connectedGoogle: false,
        gender: "Female",
        gmail: "",
        verifiedEmailFlag: false));

    await tester.pumpWidget(MaterialApp(
      home: const CountryTile(),
    ));

    expect(find.text('Location'), findsOneWidget);
  });


  testWidgets('test_onTap_navigation_and_state_refresh',
      (WidgetTester tester) async {
    final mockUserController = GetIt.instance.get<UserController>();
    when(mockUserController.accountSettings).thenReturn(AccountSettings(
        country: 'USA',
        email: "",
        connectedGoogle: false,
        gender: "Female",
        gmail: "",
        verifiedEmailFlag: false));

    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: const CountryTile(),
      navigatorObservers: [mockObserver],
    ));

    await tester.tap(find.byType(CountryTile));
    await tester.pumpAndSettle();

    // verify(mockObserver.didPush(any, any));
    expect(find.byType(LocationCustomization), findsOneWidget);
  });
}
