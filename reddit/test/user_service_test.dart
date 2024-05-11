import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/notifications_settings_item.dart';
import 'package:reddit/Models/safety_settings_item.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Models/user_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/test_files/test_users.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('userservice', () {
    late UserService userService;
    late MockClient client;
    late CommentsService commentsService;

    setUp(() {
      client = MockClient();
      userService = UserService();
      commentsService = CommentsService();

      if (GetIt.instance.isRegistered<CommentsService>()) {
        GetIt.instance.unregister<CommentsService>();
      }

      GetIt.instance.registerSingleton<CommentsService>(commentsService);
    });
    test('change gender', () async {
      bool result = await userService.changeGender('Purple-7544', 'Male');
      expect(result, true);
      var user =
          users.firstWhere((user) => user.userAbout.username == 'Purple-7544');
      expect(user.userAbout.gender, 'Male');
      expect(user.accountSettings?.gender, 'Male');
    });

    test('change email', () async {
      bool result = await userService.changeEmail(
          'Purple-7544', 'newEmail@example.com', 'rawan1234');
      expect(result, true);

      var user =
          users.firstWhere((user) => user.userAbout.username == 'Purple-7544');
      expect(user.userAbout.email, 'newEmail@example.com');
      expect(user.accountSettings?.email, 'newEmail@example.com');
    });
    test('change password', () async {
      bool result = await userService.changePassword(
          'Purple-7544', 'rawan1234', 'newPassword', 'newPassword');
      expect(result, true);

      var user =
          users.firstWhere((user) => user.userAbout.username == 'Purple-7544');
      expect(user.password, 'newPassword');
    });
    test('change country', () async {
      await userService.changeCountry('Purple-7544', 'USA');

      var user =
          users.firstWhere((user) => user.userAbout.username == 'Purple-7544');
      expect(user.userAbout.country, 'USA');
      expect(user.accountSettings?.country, 'USA');
    });
    test('connect to Google', () async {
      bool result = await userService.connectToGoogle('Purple-7544');
      expect(result, true);

      var user =
          users.firstWhere((user) => user.userAbout.username == 'Purple-7544');
      expect(user.accountSettings?.connectedGoogle, true);
    });

    test('disconnect from Google', () async {
      int result =
          await userService.disconnectFromGoogle('Purple-7544', 'rawan1234');
      expect(result, 200);

      var user =
          users.firstWhere((user) => user.userAbout.username == 'Purple-7544');
      expect(user.accountSettings?.connectedGoogle, false);
    });

    test('save comment', () async {
      await userService.saveComment('Purple-7544', 'comment1');
      var user =
          users.firstWhere((user) => user.userAbout.username == 'Purple-7544');
      expect(user.savedCommentsIds, contains('comment1'));
    });

    test('unsave comment', () async {
      await userService.unsaveComment('Purple-7544', 'comment1');

      var user =
          users.firstWhere((user) => user.userAbout.username == 'Purple-7544');
      expect(user.savedCommentsIds, isNot(contains('comment1')));
    });
    test('updates the user\'s notification settings', () async {
      final username = 'Purple-7544';
      final notificationsSettingsItem = NotificationsSettingsItem(
        mentions: true,
        comments: false,
        upvotesPosts: true,
        upvotesComments: true,
        replies: true,
        newFollowers: false,
        invitations: true,
        posts: false,
        privateMessages: true,
        chatMessages: false,
        chatRequests: true,
      );
      await userService.updateNotificationSettings(
          username, notificationsSettingsItem);
      final user =
          users.firstWhere((element) => element.userAbout.username == username);
      expect(user.notificationsSettings, equals(notificationsSettingsItem));
    });
    test('getAccountSettings of the user', () async {
      // Arrange
      final username = 'testUser';
      final accountSettings = AccountSettings(
        email: 'test@example.com',
        verifiedEmailFlag: true,
        country: 'Test Country',
        gender: 'Test Gender',
        gmail: 'test@gmail.com',
        connectedGoogle: true,
      );
      final user = UserItem(
          userAbout: UserAbout(username: username),
          accountSettings: accountSettings);
      users.add(user);

      final result = await userService.getAccountSettings(username);

      expect(result, equals(accountSettings));
    });

    test(
        'getBlockedUsers returns the list of blocked users for a given username',
        () async {
      final username = 'Purple-7544';
      final blockedUsers = [
        BlockedUsersItem(
          username: 'jane123',
          profilePicture: 'images/pp.jpg',
          blockedDate: '5 March 2024',
        ),
      ];
      final user = UserItem(
        userAbout: UserAbout(username: username),
        safetySettings: SafetyAndPrivacySettings(
            blockedUsers: blockedUsers, mutedCommunities: []),
      );
      users.add(user);

      final result = await userService.getBlockedUsers(username);
      for (var i = 0; i < result.length; i++) {
        expect(result[i].username, equals(blockedUsers[i].username));
        expect(
            result[i].profilePicture, equals(blockedUsers[i].profilePicture));
        expect(result[i].blockedDate, equals(blockedUsers[i].blockedDate));
      }
    });
    // 1. Test for userLogin
    // test('userLogin returns 200 for valid credentials', () async {
    //   final username = 'j';
    //   final password = '12345678';
    //   users.add(UserItem(
    //       userAbout: UserAbout(username: username), password: password));

    //   final result = await userService.userLogin(username, password);

    //   expect(result, equals(200));
    // });

    test('userLogin returns 400 for invalid credentials', () async {
      final username = 'Purple-7544';
      final password = 'rawan0000';

      final result = await userService.userLogin(username, password);

      expect(result, equals(400));
    });

    test('userSignup returns 200 for valid data', () async {
      final username = 'testUser';
      final password = 'testPassword';
      final email = 'test@test.com';
      final gender = 'Male';

      final result =
          await userService.userSignup(username, password, email, gender);

      expect(result, equals(200));
    });

    test('userSignup returns 400 for invalid data', () async {
      final username = 'testUser';
      final password = 'test';
      final email = 'test@test.com';
      final gender = 'Male';

      final result =
          await userService.userSignup(username, password, email, gender);

      expect(result, equals(400));
    });

    test('availableUsername returns 200 for available username', () async {
      final username = 'z';

      final result = await userService.availableUsername(username);

      expect(result, equals(200));
    });

    test('availableUsername returns 400 for taken username', () async {
      final username = 'Purple-7544';
      users.add(UserItem(userAbout: UserAbout(username: username)));

      final result = await userService.availableUsername(username);

      expect(result, equals(400));
    });

    test('availableEmail returns 200 for available email', () async {
      final email = 'z@gmail.com';

      final result = await userService.availableEmail(email);

      expect(result, equals(200));
    });

    test('availableEmail returns 400 for taken email', () async {
      final email = 'rawan7544@gmail.com';

      final result = await userService.availableEmail(email);

      expect(result, equals(400));
    });
    test('getUserAbout returns correct UserAbout for given username', () async {
      var userAbout = await userService.getUserAbout('jane123');
      expect(userAbout?.username, 'jane123');
    });
    test('addSocialLink adds a new social link to user', () async {
      var username = 'jane123';
      var displayText = 'new_social_link';
      var type = 'new_type';
      var customUrl = 'https://new_social_link.com';

      await userService.addSocialLink(username, displayText, type, customUrl);

      var userAbout = await userService.getUserAbout(username);
      var socialLink = userAbout?.socialLinks!.last;

      expect(socialLink?.username, displayText);
      expect(socialLink?.displayText, displayText);
      expect(socialLink?.type, type);
      expect(socialLink?.customUrl, customUrl);
    });
    test('followUser adds user to followers and following lists', () async {
      var username = 'johndoe';
      var follower = 'jane123';

      await userService.followUser(username, follower);

      var userBeingFollowed =
          users.firstWhere((element) => element.userAbout.username == username);
      var followerUser =
          users.firstWhere((element) => element.userAbout.username == follower);

      expect(userBeingFollowed.followers!.last.username, follower);
      expect(followerUser.following!.last.username, username);
    });
    test('unfollowUser removes user from followers and following lists',
        () async {
      var username = 'johndoe';
      var follower = 'Purple-7544';
      await userService.followUser(username, follower);
      await userService.unfollowUser(username, follower);

      var userBeingUnfollowed =
          users.firstWhere((element) => element.userAbout.username == username);
      var unfollowerUser =
          users.firstWhere((element) => element.userAbout.username == follower);

      expect(
          userBeingUnfollowed.followers!
              .any((element) => element.username == follower),
          false);
      expect(
          unfollowerUser.following!
              .any((element) => element.username == username),
          false);
    });
    test('addBannerPicture picture of a user', () async {
      var username = 'jane123';
      var bannerPicture = 'new_banner_picture.jpg';

      await userService.addBannerPicture(username, bannerPicture);

      var userAbout = await userService.getUserAbout(username);

      expect(userAbout?.bannerPicture, bannerPicture);
    });
    test('addProfilePicture updates the profile picture of a user', () async {
      var username = 'jane123';
      var profilePicture = 'new_profile_picture.jpg';

      await userService.addProfilePicture(username, profilePicture);

      var userAbout = users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout;

      expect(userAbout.profilePicture, profilePicture);
    });
    test('updateProfileSettings updates the profile settings of a user',
        () async {
      var username = 'jane123';
      var displayName = 'Jane Doe';
      var about = 'About Jane';
      var nsfwFlag = true;
      var allowFollowers = true;
      var contentVisibility = true;
      var activeCommunity = true;

      await userService.updateProfileSettings(username, displayName, about,
          nsfwFlag, allowFollowers, contentVisibility, activeCommunity);

      var user =
          users.firstWhere((element) => element.userAbout.username == username);

      expect(user.userAbout.displayName, displayName);
      expect(user.userAbout.about, about);
      expect(user.profileSettings?.nsfwFlag, nsfwFlag);
      expect(user.profileSettings?.allowFollowers, allowFollowers);
      expect(user.profileSettings?.contentVisibility, contentVisibility);
      expect(user.profileSettings?.activeCommunity, activeCommunity);
    });
    test('getProfileSettings returns the profile settings of a user', () async {
      var username = 'jane123';

      var profileSettings = await userService.getProfileSettings(username);

      var expectedProfileSettings = users
          .firstWhere((element) => element.userAbout.username == username)
          .profileSettings;

      expect(profileSettings, expectedProfileSettings);
    });
    test('getActiveCommunities returns the active communities of a user',
        () async {
      var username = 'jane123';

      var activeCommunitiesResult =
          await userService.getActiveCommunities(username);

      var expectedActiveCommunities = users
          .firstWhere((element) => element.userAbout.username == username)
          .activecommunities;
      var expectedShowActiveCommunities = users
          .firstWhere((element) => element.userAbout.username == username)
          .profileSettings!
          .activeCommunity;

      expect(
          activeCommunitiesResult.activeCommunities, expectedActiveCommunities);
      expect(activeCommunitiesResult.showActiveCommunities,
          expectedShowActiveCommunities);
    });
    test('markAllMessagesRead marks all messages of a user as read', () async {
      var username = 'jane123';

      await userService.markAllMessagesRead(username);

      var userMessages = users
          .firstWhere((element) => element.userAbout.username == username)
          .usermessages;

      for (var msg in userMessages!) {
        expect(msg.unreadFlag, false);
      }
    });
    test('markoneMessageRead marks a specific message of a user read',
        () async {
      var username = 'jane123';
      var msgId = ['1'];

      await userService.markoneMessageRead(username, msgId);

      var userMessages = users
          .firstWhere((element) => element.userAbout.username == username)
          .usermessages;

      for (var msg in userMessages!) {
        if (msgId.contains(msg.id)) {
          expect(msg.unreadFlag, false);
        }
      }
    });
    test('deleteSocialLink deletes a social link of a user', () async {
      var username = 'Purple-7544';
      var id = '0';

      await userService.deleteSocialLink(username, id);

      var userSocialLinks = users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .socialLinks;

      expect(userSocialLinks!.any((element) => element.id == id), false);
    });
    test('removeBannerPicture removes the banner picture of a user', () async {
      var username = 'jane123';

      await userService.removeBannerPicture(username);

      var userAbout = users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout;

      expect(userAbout.bannerPicture, null);
    });
    test('removeProfilePicture removes the profile picture of a user',
        () async {
      var username = 'jane123';

      await userService.removeProfilePicture(username);

      var userAbout = users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout;

      expect(userAbout.profilePicture, null);
    });
    test('editSocialLink edits a social link of a user', () async {
      var username = 'jane123';
      var id = '0';
      var displayText = 'new_display_text';
      var customUrl = 'new_custom_url';

      await userService.editSocialLink(username, id, displayText, customUrl);

      var socialLink = users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .socialLinks!
          .firstWhere((element) => element.id == id);

      expect(socialLink.displayText, displayText);
      expect(socialLink.username, displayText);
      expect(socialLink.customUrl, customUrl);
    });
    test(
        'getMessages returns the messages of a user excluding messages from blocked users',
        () async {
      var username = 'jane123';

      var messages = await userService.getMessages(username);

      var expectedMessages = List.from(users
          .firstWhere((element) => element.userAbout.username == username)
          .usermessages!);

      expect(messages, expectedMessages);
    });
  });
}
