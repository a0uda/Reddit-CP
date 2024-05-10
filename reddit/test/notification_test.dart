import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit/Models/notification_item.dart';
import 'package:reddit/widgets/comments_desktop.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:reddit/Services/notifications_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/widgets/notification.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockNotificationsService extends Mock implements NotificationsService {}

class MockUserService extends Mock implements UserService {}

class MockUserController extends Mock implements UserController {}

void main() {
  group('NotificationCard Widget Tests', () {
    late MockNavigatorObserver navigatorObserver;
    late MockNotificationsService notificationsService;
    late MockUserService userService;
    late MockUserController userController;

    setUp(() {
      navigatorObserver = MockNavigatorObserver();
      notificationsService = MockNotificationsService();
      userService = MockUserService();
      userController = MockUserController();
      GetIt.I.registerSingleton<NotificationsService>(notificationsService);
      GetIt.I.registerSingleton<UserService>(userService);
      GetIt.I.registerSingleton<UserController>(userController);
    });

    tearDown(() {
      GetIt.I.unregister<NotificationsService>();
      GetIt.I.unregister<UserService>();
      GetIt.I.unregister<UserController>();
    });

    testWidgets('test_NotificationCard_builds_correctly',
        (WidgetTester tester) async {
      final notificationItem = NotificationItem(
        id: '1',
        type: 'upvotes_posts',
        sendingUserUsername: 'user123',
        communityName: 'FlutterDev',
        isInCommunity: true,
        createdAt:
            DateTime.now().subtract(Duration(minutes: 5)).toIso8601String(),
        unreadFlag: true,
      );

      await tester.pumpWidget(MaterialApp(
        home: Provider<NotificationsService>(
          create: (_) => notificationsService,
          child: NotificationCard(notificationItem: notificationItem),
        ),
        navigatorObservers: [navigatorObserver],
      ));
      debugDumpApp();

      expect(find.text('upvoted your post'), findsOneWidget);
      expect(find.text('Go see your post'), findsOneWidget);
    });

    testWidgets('test_NotificationCard_navigation_on_tap',
        (WidgetTester tester) async {
      final notificationItem = NotificationItem(
        id: '1',
        type: 'upvotes_posts',
        sendingUserUsername: 'user123',
        communityName: 'FlutterDev',
        isInCommunity: true,
        createdAt:
            DateTime.now().subtract(Duration(minutes: 5)).toIso8601String(),
        unreadFlag: true,
        postId: 'post1',
      );

      await tester.pumpWidget(MaterialApp(
        home: Provider<NotificationsService>(
          create: (_) => notificationsService,
          child: NotificationCard(notificationItem: notificationItem),
        ),
        navigatorObservers: [navigatorObserver],
      ));

      await tester.tap(find.byType(ListTile));

      await tester.pumpAndSettle();

      expect(find.byType(CommentsDesktop), findsOneWidget);
    });
  });

  group('formatDateTime Function Tests', () {
    test('test_formatDateTime_correct_formatting', () {
      expect(
          formatDateTime(
              DateTime.now().subtract(Duration(seconds: 30)).toIso8601String()),
          '30sec');
      expect(
          formatDateTime(
              DateTime.now().subtract(Duration(minutes: 30)).toIso8601String()),
          '30m');
      expect(
          formatDateTime(
              DateTime.now().subtract(Duration(hours: 12)).toIso8601String()),
          '12h');
      expect(
          formatDateTime(
              DateTime.now().subtract(Duration(days: 10)).toIso8601String()),
          '10d');
      expect(
          formatDateTime(
              DateTime.now().subtract(Duration(days: 400)).toIso8601String()),
          '1 yrs');
    });
  });

  test(
      'Returns "Xsec" when the difference between the current time and the parsed date time is less than 60 seconds',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(seconds: 30)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('sec'));
  });

  test(
      'Returns "0sec" when the parsed date time is the same as the current time',
      () {
    // Arrange
    String dateTimeString = DateTime.now().toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, '0sec');
  });
  test(
      'Returns "Xm" when the difference between the current time and the parsed date time is less than 60 minutes',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(minutes: 30)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('m'));
  });

  test(
      'Returns "Xh" when the difference between the current time and the parsed date time is less than 24 hours',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(hours: 12)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('h'));
  });

  test(
      'Returns "Xd" when the difference between the current time and the parsed date time is less than 30 days',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(days: 15)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('d'));
  });

  test(
      'Returns "X mth" when the difference between the current time and the parsed date time is less than 12 months',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(days: 200)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('mth'));
  });

  test(
      'Returns "X yrs" when the difference between the current time and the parsed date time is more than 12 months',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(days: 500)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('yrs'));
  });

  test(
      'Returns "Xsec" when the difference between the current time and the parsed date time is less than 60 seconds',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(seconds: 30)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('sec'));
  });

  test(
      'Returns "0sec" when the parsed date time is the same as the current time',
      () {
    // Arrange
    String dateTimeString = DateTime.now().toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, '0sec');
  });

  test(
      'Returns "Xm" when the difference between the current time and the parsed date time is less than 60 minutes',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(minutes: 30)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('m'));
  });

  test(
      'Returns "Xh" when the difference between the current time and the parsed date time is less than 24 hours',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(hours: 12)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('h'));
  });

  test(
      'Returns "Xd" when the difference between the current time and the parsed date time is less than 30 days',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(days: 15)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('d'));
  });

  test(
      'Returns "X mth" when the difference between the current time and the parsed date time is less than 12 months',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(days: 200)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('mth'));
  });

  test(
      'Returns "X yrs" when the difference between the current time and the parsed date time is more than 12 months',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(days: 500)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('yrs'));
  });

  test(
      'Returns "X yrs" when the difference between the current time and the parsed date time is more than 12 months',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(days: 500)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('yrs'));
  });

  test(
      'Returns "X yrs" when the difference between the current time and the parsed date time is more than 12 months',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(days: 500)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('yrs'));
  });

  test(
      'Returns "X yrs" when the difference between the current time and the parsed date time is more than 12 months',
      () {
    // Arrange
    String dateTimeString =
        DateTime.now().subtract(Duration(days: 500)).toIso8601String();

    // Act
    String result = formatDateTime(dateTimeString);

    // Assert
    expect(result, endsWith('yrs'));
  });
}
