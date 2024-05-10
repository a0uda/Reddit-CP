import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/chat_controller.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/chat_service.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/Services/community_service.dart';
import 'package:reddit/Services/moderator_service.dart';
import 'package:reddit/Services/notifications_service.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Services/search_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/test_files/test_arrays.dart';
import 'package:reddit/test_files/test_users.dart';
import 'package:reddit/widgets/add_social_link_button.dart';
import 'package:reddit/widgets/add_social_link_form.dart';
import 'package:reddit/widgets/edit_profile.dart';
import 'package:reddit/widgets/follower_list.dart';
import 'package:reddit/widgets/profile_header.dart';
import 'package:reddit/widgets/profile_header_add_social_link.dart';
import 'package:reddit/widgets/profile_header_left_side.dart';
import 'package:reddit/widgets/profile_header_right_side.dart';
import 'package:reddit/widgets/tab_bar_views.dart';

void main() {
  setUp(() async {
    GetIt.instance.registerSingleton<UserService>(UserService());
    GetIt.instance
        .registerSingleton<NotificationsService>(NotificationsService());
    GetIt.instance.registerSingleton<UserController>(UserController());
    GetIt.instance
        .registerSingleton<SocialLinksController>(SocialLinksController());
    GetIt.instance.registerSingleton<CommentsService>(CommentsService());
    GetIt.instance.registerSingleton<PostService>(PostService());
    GetIt.instance.registerSingleton<SearchService>(SearchService());
    GetIt.instance.registerSingleton<CommunityService>(CommunityService());
    GetIt.instance
        .registerSingleton<CommunityController>(CommunityController());
    GetIt.instance
        .registerSingleton<ModeratorMockService>(ModeratorMockService());
    GetIt.instance
        .registerSingleton<ModeratorController>(ModeratorController());
    GetIt.instance.registerSingleton<ChatsService>(ChatsService());
    GetIt.instance.registerSingleton<FollowerFollowingController>(
        FollowerFollowingController());
    GetIt.instance
        .registerSingleton<EditProfileController>(EditProfileController());
    GetIt.instance.registerSingleton<ProfilePictureController>(
        ProfilePictureController());
    GetIt.instance.registerSingleton<BlockUnblockUser>(BlockUnblockUser());
  });
  tearDown(() {
    GetIt.instance.reset();
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
              ChangeNotifierProvider(
                create: (context) => SocialLinksController(),
              ),
              ChangeNotifierProvider(
                create: (context) => ProfilePictureController(),
              ),
              ChangeNotifierProvider(
                create: (context) => BannerPictureController(),
              ),
              ChangeNotifierProvider(
                create: (context) => FollowerFollowingController(),
              ),
              ChangeNotifierProvider(
                create: (context) => EditProfileController(),
              ),
            ],
            child: MaterialApp(
              home: ProfileHeaderRightSide(userData: user, userType: 'me'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final iconShareFinder = find.byIcon(Icons.share);
      expect(iconShareFinder, findsOneWidget);
      await tester.ensureVisible(iconShareFinder);

      final iconMessageFinder = find.byIcon(Icons.message);
      expect(iconMessageFinder, findsNothing);

      final followButtonFinder = find.text('Follow');
      expect(followButtonFinder, findsNothing);

      final editButtonFinder = find.text('Edit');
      expect(editButtonFinder, findsOneWidget);
      await tester.ensureVisible(editButtonFinder);
      await tester.tap(editButtonFinder);
      await tester.pumpAndSettle();
      expect(find.byType(EditProfileScreen), findsOneWidget);
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
              ChangeNotifierProvider(
                create: (context) => SocialLinksController(),
              ),
              ChangeNotifierProvider(
                create: (context) => ProfilePictureController(),
              ),
              ChangeNotifierProvider(
                create: (context) => BannerPictureController(),
              ),
              ChangeNotifierProvider(
                create: (context) => FollowerFollowingController(),
              ),
              ChangeNotifierProvider(
                create: (context) => EditProfileController(),
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

      final followingButtonFinder = find.text('Following');
      expect(followingButtonFinder, findsOneWidget);
      await tester.ensureVisible(followingButtonFinder);

      // Tap the follow button
      await tester.tap(followingButtonFinder);
      await tester.pumpAndSettle();

      // Check if the text has changed to 'unfollow'
      final followButtonFinder = find.text('Follow');
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
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SocialLinksController(),
            ),
            ChangeNotifierProvider(
              create: (context) => ProfilePictureController(),
            ),
            ChangeNotifierProvider(
              create: (context) => BannerPictureController(),
            ),
            ChangeNotifierProvider(
              create: (context) => FollowerFollowingController(),
            ),
            ChangeNotifierProvider(
              create: (context) => EditProfileController(),
            ),
            ChangeNotifierProvider(
              create: (context) => BlockUnblockUser(),
            ),
          ],
          child: MaterialApp(
            home: ProfileHeaderLeftSide(user, 'me'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final nameFinder = find.byWidgetPredicate((Widget widget) =>
          widget is Text &&
          (widget.data == user.username || widget.data == user.displayName));
      expect(nameFinder, findsOneWidget);
      await tester.ensureVisible(nameFinder);

      final info1 = find.text('u/${user.username} - ${user.createdAt}');
      expect(info1, findsOneWidget);
      await tester.ensureVisible(info1);

      final info2 = find.text(
          user.about != null && user.about!.isNotEmpty ? '${user.about}' : '');
      expect(info2, findsOneWidget);
      await tester.ensureVisible(info2);

      final followers = find.text('${followersCount} followers');
      expect(followers, findsOneWidget);
      await tester.ensureVisible(followers);

      final iconFollowersFinder = find.byIcon(Icons.arrow_forward_ios_rounded);
      expect(iconFollowersFinder, findsOneWidget);
      await tester.ensureVisible(iconFollowersFinder);
      await tester.tap(iconFollowersFinder);
      await tester.pumpAndSettle();
      expect(find.byType(FollowerList), findsOneWidget);
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

      final info1 =
          find.text('u/${otherUser.username} - ${otherUser.createdAt}');
      expect(info1, findsOneWidget);
      await tester.ensureVisible(info1);

      final info2 = find.text(
          otherUser.about != null && otherUser.about!.isNotEmpty
              ? '${otherUser.about}'
              : '');
      expect(info2, findsOneWidget);
      await tester.ensureVisible(info2);

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
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SocialLinksController(),
            ),
            ChangeNotifierProvider(
              create: (context) => ProfilePictureController(),
            ),
            ChangeNotifierProvider(
              create: (context) => BannerPictureController(),
            ),
            ChangeNotifierProvider(
              create: (context) => FollowerFollowingController(),
            ),
            ChangeNotifierProvider(
              create: (context) => EditProfileController(),
            ),
            ChangeNotifierProvider(
              create: (context) => BlockUnblockUser(),
            ),
          ],
          child: MaterialApp(
            home: ProfileHeaderAddSocialLink(user, 'me', true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final socialLinks = find.byType(AddSocialLinkButton);
      if (socialLinksCount < 5) {
        expect(socialLinks, findsOneWidget);
        await tester.ensureVisible(socialLinks);
        await tester.tap(socialLinks);
        await tester.pumpAndSettle();
        final addSocialLink = find.text('Add Social Link');
        final bottomModalSheet = find.byType(SingleChildScrollView);
        expect(addSocialLink, findsOneWidget);
        await tester.ensureVisible(addSocialLink);
        expect(bottomModalSheet, findsOneWidget);
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

    testWidgets('Add Social Link List', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SocialLinksController(),
            ),
          ],
          child: MaterialApp(
            home: AddSocialLinkButton(notEditProfile: true),
          ),
        ),
      );
      final addSocialLinkButtom = find.byIcon(Icons.add);
      await tester.tap(addSocialLinkButtom);
      await tester.pumpAndSettle();
      final socialLink = find.text('Instagram');
      expect(socialLink, findsOneWidget);
      await tester.ensureVisible(socialLink);
      await tester.tap(socialLink);
      await tester.pumpAndSettle();
      expect(find.byType(AddSocialLinkForm), findsOneWidget);
    });

    testWidgets('Testing Social Links Form with correct and incorrect data ',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      print(user!.username);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SocialLinksController(),
            ),
          ],
          child: MaterialApp(
            home: AddSocialLinkForm(
                socialMediaIcon: Brand(Brands.instagram),
                socialLink: 'Instagram',
                isEdit: false),
          ),
        ),
      );

      var usernameField = find.byKey(Key('Username'));
      var linkField = find.byKey(Key('Link'));
      var saveButton = find.byKey(Key('Save'));
      expect(usernameField, findsOneWidget);
      await tester.ensureVisible(usernameField);
      expect(linkField, findsOneWidget);
      await tester.ensureVisible(linkField);
      expect(saveButton, findsOneWidget);
      await tester.ensureVisible(saveButton);

      //Testing empty link
      await tester.enterText(usernameField, 'rawan');
      await tester.enterText(linkField, '');

      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(find.text('Please enter a link'), findsOneWidget);

      //Testing empty username
      await tester.enterText(usernameField, '');
      await tester.enterText(linkField, 'https://www.instagram.com/rawan/');

      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(find.text('Please enter a username'), findsOneWidget);

      //Testing invalid link
      await tester.enterText(usernameField, 'rawan');
      await tester.enterText(linkField, 'ay kalam');

      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid link'), findsOneWidget);

      //Testing valid data
      await tester.enterText(usernameField, 'rawan');
      await tester.enterText(linkField, 'https://www.instagram.com');

      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(find.text('Social Link added Successfully!'), findsOneWidget);
      expect(find.text('Please enter a valid link'), findsNothing);
      expect(find.text('Please enter a username'), findsNothing);
      expect(find.text('Please enter a link'), findsNothing);
    });

    // testWidgets('Tab Bar Views rendered correctly for user',
    //     (WidgetTester tester) async {
    //   var userController = GetIt.I.get<UserController>();
    //   await userController.getUserAbout('Purple-7544');
    //   UserAbout? user = userController.userAbout;
    //   int socialLinksCount = user!.socialLinks!.length;
    //   print(user.username);

    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: MultiProvider(
    //         providers: [
    //           ChangeNotifierProvider<SocialLinksController>.value(
    //             value: GetIt.I.get<SocialLinksController>(),
    //           ),
    //         ],
    //         child: ProfileHeaderAddSocialLink(user, 'me', true),
    //       ),
    //     ),
    //   );
    //   await tester.pumpAndSettle();
    //   final socialLinks = find.byType(AddSocialLinkButton);
    //   if (socialLinksCount < 5) {
    //     expect(socialLinks, findsOneWidget);
    //     await tester.ensureVisible(socialLinks);
    //   } else {
    //     expect(socialLinks, findsNothing);
    //   }
    //   for (var socialLink in user.socialLinks!) {
    //     final displayNameFinder = find.text(socialLink.displayText);
    //     expect(displayNameFinder, findsAtLeast(1));

    //     displayNameFinder.evaluate().forEach((element) {
    //       var elementFinder = find.byElementPredicate(
    //           (elementCandidate) => elementCandidate == element);
    //       tester.ensureVisible(elementFinder);
    //     });
    //   }
    // });
  });
}
