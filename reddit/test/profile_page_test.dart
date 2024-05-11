import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
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
import 'package:reddit/widgets/add_social_link_button.dart';
import 'package:reddit/widgets/add_social_link_form.dart';
import 'package:reddit/widgets/edit_profile.dart';
import 'package:reddit/widgets/follower_list.dart';
import 'package:reddit/widgets/profile_header.dart';
import 'package:reddit/widgets/profile_header_add_social_link.dart';
import 'package:reddit/widgets/profile_header_left_side.dart';
import 'package:reddit/widgets/profile_header_right_side.dart';
import 'package:reddit/widgets/social_media_buttons.dart';
import 'package:reddit/widgets/tab_bar_about.dart';
import 'package:reddit/widgets/tab_bar_comments.dart';
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
    GetIt.instance.registerSingleton<MessagesOperations>(MessagesOperations());
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

    testWidgets(
        'Profile Header Right Side for other users and testing unfollow',
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

    testWidgets('Profile Header Right Side for other users and testing follow',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      print(user!.username);

      var userService = GetIt.I.get<UserService>();
      UserAbout? otherUser = await userService.getUserAbout('Mark_45');
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

      final followingButtonFinder = find.text('Follow');
      expect(followingButtonFinder, findsOneWidget);
      await tester.ensureVisible(followingButtonFinder);

      // Tap the follow button
      await tester.tap(followingButtonFinder);
      await tester.pumpAndSettle();

      // Check if the text has changed to 'unfollow'
      final followButtonFinder = find.text('Following');
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
      for (var socialMediaButton in socialMediaButtons) {
        expect(find.text(socialMediaButton['name'].toString()), findsOneWidget);
      }
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

    testWidgets('Followrs List Test', (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      print(user!.username);

      List<FollowersFollowingItem> followers =
          await userController.getFollowers('Purple-7544');
      List<FollowersFollowingItem> following =
          await userController.getFollowing('Purple-7544');

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => SocialLinksController(),
              ),
              ChangeNotifierProvider(
                create: (context) => BlockUnblockUser(),
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
            child: FollowerList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      //test all followers are displayed
      int followButtonCount = 0;
      int followingButtoncount = 0;
      for (var follower in followers) {
        var followerUsername = find.text(follower.username);
        expect(followerUsername, findsOneWidget);
        await tester.ensureVisible(followerUsername);
        if (following.any((element) => element.username == follower.username)) {
          followingButtoncount++;
        } else {
          followButtonCount++;
        }
      }
      //test the following and followers are correct
      final followButtons = find.text('Follow');
      final followingButtons = find.text('Following');
      expect(followButtons, findsNWidgets(followButtonCount));
      expect(followingButtons, findsNWidgets(followingButtoncount));

      // Tap each Follow button
      for (int i = 0; i < followButtonCount; i++) {
        final followButton = find.text('Follow').at(i);
        await tester.tap(followButton);
        await tester.pumpAndSettle();
      }

      // Tap each Following button
      for (int i = 0; i < followingButtoncount; i++) {
        final followingButton = find.text('Following').at(i);
        await tester.tap(followingButton);
        await tester.pumpAndSettle();
      }

      //test the foolow and unfollow work for the whole list
      expect(find.text('Follow'), findsNWidgets(followingButtoncount));
      expect(find.text('Following'), findsNWidgets(followButtonCount));
    });

    testWidgets('TabBarViews shows TabBarComments and TabBarAbout',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      print(user!.username);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => BlockUnblockUser(),
              ),
              ChangeNotifierProvider(
                create: (context) => EditProfileController(),
              ),
              ChangeNotifierProvider(
                create: (context) => FollowerFollowingController(),
              ),
            ],
            child: Scaffold(
              body: DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    const TabBar(
                      indicatorColor: Color.fromARGB(255, 24, 82, 189),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        // Tab(text: 'Posts'),
                        Tab(text: 'Comments'),
                        Tab(text: 'About'),
                      ],
                    ),
                    Expanded(
                      child: TabBarViews(user, 'me'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      final commentTab = find.text('Comments');
      final aboutTab = find.text('About');
      await tester.tap(commentTab);
      await tester.pumpAndSettle();
      expect(find.byType(TabBarComments), findsOneWidget);
      await tester.tap(aboutTab);
      await tester.pumpAndSettle();
      expect(find.byType(TabBarAbout), findsOneWidget);
    });

    testWidgets('ProfileHeader renders correctly for user',
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
                create: (context) => BlockUnblockUser(),
              ),
              ChangeNotifierProvider(
                create: (context) => EditProfileController(),
              ),
              ChangeNotifierProvider(
                create: (context) => FollowerFollowingController(),
              ),
              ChangeNotifierProvider(
                create: (context) => BannerPictureController(),
              ),
              ChangeNotifierProvider(
                create: (context) => SocialLinksController(),
              ),
              ChangeNotifierProvider(
                create: (context) => ProfilePictureController(),
              ),
            ],
            child: Scaffold(
              body: Column(children: [
                ProfileHeader(user, 'me'),
              ]),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ProfileHeaderLeftSide), findsOneWidget);
      expect(find.byType(ProfileHeaderRightSide), findsOneWidget);
      expect(find.byType(ProfileHeaderAddSocialLink), findsOneWidget);
    });
    testWidgets('Testing more options in profile header for other users',
        (WidgetTester tester) async {
      var userController = GetIt.I.get<UserController>();
      await userController.getUserAbout('Purple-7544');
      UserAbout? user = userController.userAbout;
      print(user!.username);

      var userService = GetIt.I.get<UserService>();
      UserAbout? otherUser = await userService.getUserAbout('johndoe');

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => BlockUnblockUser(),
              ),
              ChangeNotifierProvider(
                create: (context) => EditProfileController(),
              ),
              ChangeNotifierProvider(
                create: (context) => FollowerFollowingController(),
              ),
              ChangeNotifierProvider(
                create: (context) => BannerPictureController(),
              ),
              ChangeNotifierProvider(
                create: (context) => SocialLinksController(),
              ),
              ChangeNotifierProvider(
                create: (context) => ProfilePictureController(),
              ),
              ChangeNotifierProvider(
                create: (context) => MessagesOperations(),
              ),
            ],
            child: Scaffold(
              body: Column(children: [
                ProfileHeader(otherUser!, 'other'),
              ]),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ProfileHeaderLeftSide), findsOneWidget);
      expect(find.byType(ProfileHeaderRightSide), findsOneWidget);
      expect(find.byType(ProfileHeaderAddSocialLink), findsOneWidget);

      // Tap more options
      final moreOptions = find.byIcon(Icons.more_horiz);
      await tester.tap(moreOptions);
      await tester.pumpAndSettle();
      final sendNewMessage = find.text("Send a message");
      final blockUser = find.text("Block Account");
      final reportUser = find.text('Report');
      final cancel = find.text('Close');
      expect(sendNewMessage, findsOneWidget);
      tester.ensureVisible(sendNewMessage);
      expect(blockUser, findsOneWidget);
      tester.ensureVisible(blockUser);
      expect(reportUser, findsOneWidget);
      tester.ensureVisible(reportUser);
      expect(cancel, findsOneWidget);
      tester.ensureVisible(cancel);

      // Tap send new message
      await tester.tap(sendNewMessage);
      await tester.pumpAndSettle();
      var subjectField = find.byKey(Key('Subject'));
      var messageField = find.byKey(Key('Message'));
      var sendButton = find.byKey(Key('Send'));
      var returnButton = find.byIcon(Icons.arrow_back).last;
      expect(subjectField, findsOneWidget);
      await tester.ensureVisible(subjectField);
      expect(messageField, findsOneWidget);
      await tester.ensureVisible(messageField);
      expect(sendButton, findsOneWidget);
      await tester.ensureVisible(sendButton);
      expect(returnButton, findsAny);

      // Sending Valid New Message
      await tester.enterText(subjectField, 'test');
      await tester.enterText(messageField, 'Hello');
      await tester.tap(sendButton);
      await tester.pumpAndSettle();
      expect(find.text('Message sent successfully.'), findsAny);

      //Sending invalid New Message
      await tester.enterText(subjectField, '');
      await tester.enterText(messageField, 'Hello');
      await tester.tap(sendButton);
      await tester.pumpAndSettle();
      expect(find.text('Please enter subject'), findsAny);
      //Sending invalid New Message
      await tester.enterText(subjectField, '');
      await tester.enterText(messageField, '');
      await tester.tap(sendButton);
      await tester.pumpAndSettle();
      expect(find.text('Please enter subject'), findsAny);

      //Try block user
      await tester.tap(returnButton);
      await tester.pumpAndSettle();
      await tester.tap(blockUser);
      await tester.pumpAndSettle();
      final blockUserButton = find.byKey(Key('Block'));
      final cancelBlock = find.byKey(Key('Cancel'));
      expect(blockUserButton, findsOneWidget);
      expect(cancelBlock, findsOneWidget);
      await tester.tap(blockUserButton);
      await tester.pumpAndSettle();

      //Try report user
      // await tester.tap(returnButton);
      // await tester.pumpAndSettle();
      await tester.tap(reportUser);
      await tester.pumpAndSettle();
      expect(find.text('Submit report'), findsOneWidget);
      await tester.ensureVisible(find.text('Submit report'));
    });

    testWidgets('ProfileScreen renders correctly for user',
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
                create: (context) => BlockUnblockUser(),
              ),
              ChangeNotifierProvider(
                create: (context) => EditProfileController(),
              ),
              ChangeNotifierProvider(
                create: (context) => FollowerFollowingController(),
              ),
              ChangeNotifierProvider(
                create: (context) => BannerPictureController(),
              ),
              ChangeNotifierProvider(
                create: (context) => SocialLinksController(),
              ),
              ChangeNotifierProvider(
                create: (context) => ProfilePictureController(),
              ),
            ],
            child: ProfileScreen(user, 'me'),
          ),
        ),
      );

      // Assert
      expect(find.byType(ProfileHeaderLeftSide), findsOneWidget);
      expect(find.byType(ProfileHeaderRightSide), findsOneWidget);
      expect(find.byType(ProfileHeaderAddSocialLink), findsOneWidget);
      expect(find.byType(DefaultTabController), findsOneWidget);
      expect(find.byType(TabBarViews), findsOneWidget);
    });
  });
}
