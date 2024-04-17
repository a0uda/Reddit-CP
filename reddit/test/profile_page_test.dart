import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/test_files/test_users.dart';
import 'package:reddit/widgets/add_social_link_button.dart';
import 'package:reddit/widgets/profile_header.dart';
import 'package:reddit/widgets/profile_header_add_social_link.dart';
import 'package:reddit/widgets/profile_header_left_side.dart';
import 'package:reddit/widgets/profile_header_right_side.dart';
import 'package:reddit/widgets/tab_bar_views.dart';

void main() {
  setUp(() async {
    GetIt.instance.registerSingleton<PostService>(PostService());
    GetIt.instance.registerSingleton<UserService>(UserService());
    GetIt.instance.registerSingleton<UserController>(UserController());
    GetIt.instance.registerSingleton<FollowerFollowingController>(
        FollowerFollowingController());
    GetIt.instance
        .registerSingleton<EditProfileController>(EditProfileController());
    GetIt.instance.registerSingleton<ProfilePictureController>(
        ProfilePictureController());
    GetIt.instance
        .registerSingleton<SocialLinksController>(SocialLinksController());
  });
  tearDown(() {
    GetIt.instance.unregister<PostService>();
    GetIt.instance.unregister<UserService>();
    GetIt.instance.unregister<UserController>();
    GetIt.instance.unregister<FollowerFollowingController>();
    GetIt.instance.unregister<EditProfileController>();
    GetIt.instance.unregister<ProfilePictureController>();
    GetIt.instance.unregister<SocialLinksController>();
  });

  group('Profile Tests ', () {
    testWidgets('Profile Header Right Side rendered correctly for user',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      print(user!.username);

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<FollowerFollowingController>.value(
                value: GetIt.I.get<FollowerFollowingController>(),
              ),
            ],
            child: ProfileHeaderRightSide(userData: user, userType: 'me'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final editButtonFinder = find.text('Edit');
      expect(editButtonFinder, findsOneWidget);
      await tester.ensureVisible(editButtonFinder);

      final iconShareFinder = find.byIcon(Icons.share);
      expect(iconShareFinder, findsOneWidget);
      await tester.ensureVisible(iconShareFinder);

      final iconMessageFinder = find.byIcon(Icons.message);
      expect(iconMessageFinder, findsNothing);

      final followButtonFinder = find.text('Follow');
      expect(followButtonFinder, findsNothing);
    });

    testWidgets('Profile Header Right Side rendered correctly for other users',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      print(user!.username);

      var userService = GetIt.I.get<UserService>();
      UserAbout? otherUser = await userService.getUserAbout('johndoe');
      print(otherUser!.username);

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<FollowerFollowingController>.value(
                value: GetIt.I.get<FollowerFollowingController>(),
              ),
            ],
            child:
                ProfileHeaderRightSide(userData: otherUser, userType: 'other'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final editButtonFinder = find.text('Edit');
      expect(editButtonFinder, findsNothing);

      final iconShareFinder = find.byIcon(Icons.share);
      expect(iconShareFinder, findsOneWidget);
      await tester.ensureVisible(iconShareFinder);

      final iconMessageFinder = find.byIcon(Icons.message);
      expect(iconMessageFinder, findsOneWidget);
      await tester.ensureVisible(iconMessageFinder);

      final followButtonFinder = find.byWidgetPredicate((Widget widget) =>
          widget is Text &&
          (widget.data == 'Follow' || widget.data == 'Following'));
      expect(followButtonFinder, findsOneWidget);
      await tester.ensureVisible(followButtonFinder);
    });

    testWidgets('Profile Header Left Side rendered correctly for user',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      var userSevice = GetIt.I.get<UserService>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      print(user!.username);

      int followersCount = await userSevice.getFollowersCount(user.username);

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<EditProfileController>.value(
                value: GetIt.I.get<EditProfileController>(),
              ),
              ChangeNotifierProvider<ProfilePictureController>.value(
                value: GetIt.I.get<ProfilePictureController>(),
              ),
            ],
            child: ProfileHeaderLeftSide(user, 'me'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final nameFinder = find.byWidgetPredicate((Widget widget) =>
          widget is Text &&
          (widget.data == user.username || widget.data == user.displayName));
      expect(nameFinder, findsOneWidget);
      await tester.ensureVisible(nameFinder);

      final info = find.text(
          'u/${user.username} - ${user.createdAt}${user.about != null && user.about!.isNotEmpty ? '\n${user.about}' : ''}');
      expect(info, findsOneWidget);
      await tester.ensureVisible(info);

      final followers = find.text('${followersCount} followers');
      expect(followers, findsOneWidget);
      await tester.ensureVisible(followers);
    });

    testWidgets('Profile Header Left Side rendered correctly for other users',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      var userSevice = GetIt.I.get<UserService>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      print(user!.username);

      var userService = GetIt.I.get<UserService>();
      UserAbout? otherUser = await userService.getUserAbout('johndoe');
      print(otherUser!.username);

      int followersCount =
          await userSevice.getFollowersCount(otherUser.username);

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<EditProfileController>.value(
                value: GetIt.I.get<EditProfileController>(),
              ),
              ChangeNotifierProvider<ProfilePictureController>.value(
                value: GetIt.I.get<ProfilePictureController>(),
              ),
            ],
            child: ProfileHeaderLeftSide(otherUser, 'other'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final nameFinder = find.byWidgetPredicate((Widget widget) =>
          widget is Text &&
          (widget.data == otherUser.username ||
              widget.data == otherUser.displayName));
      expect(nameFinder, findsOneWidget);
      await tester.ensureVisible(nameFinder);

      final info = find.text(
          'u/${otherUser.username} - ${otherUser.createdAt}${otherUser.about != null && otherUser.about!.isNotEmpty ? '\n${otherUser.about}' : ''}');
      expect(info, findsOneWidget);
      await tester.ensureVisible(info);

      final followers = find.text('${followersCount} followers');
      expect(followers, findsNothing);

    });

    testWidgets('Profile Header Add Social Links rendered correctly for user',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      int socialLinksCount = user!.socialLinks!.length;
      print(user.username);

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<SocialLinksController>.value(
                value: GetIt.I.get<SocialLinksController>(),
              ),
            ],
            child: ProfileHeaderAddSocialLink(user, 'me', true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final socialLinks = find.byType(AddSocialLinkButton);
      if (socialLinksCount < 5) {
        expect(socialLinks, findsOneWidget);
        await tester.ensureVisible(socialLinks);
      } else {
        expect(socialLinks, findsNothing);
      }
      for (var socialLink in user.socialLinks!) {
        final displayNameFinder = find.text(socialLink.displayText);
        expect(displayNameFinder, findsAtLeast(1));

        displayNameFinder.evaluate().forEach((element) {
          var elementFinder = find.byElementPredicate(
              (elementCandidate) => elementCandidate == element);
          tester.ensureVisible(elementFinder);
        });
      }
    });

    testWidgets(
        'Profile Header Add Social Links rendered correctly for other users',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      print(user!.username);

      var userService = GetIt.I.get<UserService>();
      UserAbout? otherUser = await userService.getUserAbout('johndoe');
      int socialLinksCount = otherUser!.socialLinks!.length;
      print(otherUser.username);

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<SocialLinksController>.value(
                value: GetIt.I.get<SocialLinksController>(),
              ),
            ],
            child: ProfileHeaderAddSocialLink(otherUser, 'other', true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final socialLinks = find.byType(AddSocialLinkButton);
      expect(socialLinks, findsNothing);
      for (var socialLink in otherUser.socialLinks!) {
        final displayNameFinder = find.text(socialLink.displayText);
        expect(displayNameFinder, findsAtLeast(1));

        displayNameFinder.evaluate().forEach((element) {
          var elementFinder = find.byElementPredicate(
              (elementCandidate) => elementCandidate == element);
          tester.ensureVisible(elementFinder);
        });
      }
    });

    testWidgets('Tab Bar Views rendered correctly for user',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      int socialLinksCount = user!.socialLinks!.length;
      print(user.username);

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<SocialLinksController>.value(
                value: GetIt.I.get<SocialLinksController>(),
              ),
            ],
            child: ProfileHeaderAddSocialLink(user, 'me', true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final socialLinks = find.byType(AddSocialLinkButton);
      if (socialLinksCount < 5) {
        expect(socialLinks, findsOneWidget);
        await tester.ensureVisible(socialLinks);
      } else {
        expect(socialLinks, findsNothing);
      }
      for (var socialLink in user.socialLinks!) {
        final displayNameFinder = find.text(socialLink.displayText);
        expect(displayNameFinder, findsAtLeast(1));

        displayNameFinder.evaluate().forEach((element) {
          var elementFinder = find.byElementPredicate(
              (elementCandidate) => elementCandidate == element);
          tester.ensureVisible(elementFinder);
        });
      }
    });
  });
}
