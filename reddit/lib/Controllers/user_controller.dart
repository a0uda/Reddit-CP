import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/message_item.dart';
import 'package:reddit/Models/notifications_settings_item.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/social_link_item.dart';
import 'package:reddit/Services/notifications_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Models/user_about.dart';

class UserController {
  final userService = GetIt.instance.get<UserService>();
  final notificationService = GetIt.instance.get<NotificationsService>();

  UserAbout? userAbout;
  List<BlockedUsersItem>? blockedUsers;
  AccountSettings? accountSettings;
  ProfileSettings? profileSettings;
  NotificationsSettingsItem? notificationsSettings;
  List<CommunityBackend>? userCommunities;
  List<FollowersFollowingItem>? followers;
  List<FollowersFollowingItem>? following;
  int unreadNotificationsCount = 0;
  int unreadMessagesCount = 0;

  Future<void> getUser(String username) async {
    userAbout = await userService.getUserAbout(username);
    blockedUsers = await userService.getBlockedUsers(username);
    accountSettings = await userService.getAccountSettings(username);
    notificationsSettings =
        await userService.getNotificationsSettings(username);
    profileSettings = await userService.getProfileSettings(username);
    unreadNotificationsCount = await getUnreadNotificationsCount();
    await getUnreadMessagesCount();
  }

  Future<void>? getUserAbout(String username) async {
    userAbout = await userService.getUserAbout(username);
  }

  Future<void> getProfileSettings(String username) async {
    profileSettings = (await userService.getProfileSettings(username))!;
  }

  Future<void> updateAllowFollowers(bool value) async {
    await userService.updateAllowFollowers(value);
    profileSettings!.allowFollowers = value;
  }

  Future<AccountSettings>? getAccountSettings(String username) {
    return userService.getAccountSettings(username);
  }

  Future<bool> changeEmail(String username, String email, String password) {
    return userService.changeEmail(username, email, password);
  }

  Future<bool> changePassword(String username, String currentPassword,
      String newPassword, String verifiedNewPassword) {
    return userService.changePassword(
        username, currentPassword, newPassword, verifiedNewPassword);
  }

  Future<void> blockUser(UserAbout userData, String username) async {
    await userService.blockUser(userData.username, username);
    blockedUsers = await userService.getBlockedUsers(userData.username);
  }

  Future<void> unblockUser(UserAbout userData, String username) async {
    await userService.unblockUser(userData.username, username);
    blockedUsers = await userService.getBlockedUsers(userData.username);
  }

  Future<bool> changeGender(String username, String gender) {
    return userService.changeGender(username, gender);
  }

  Future<void> changeCountry(String username, String country) {
    userAbout!.country = country;
    return userService.changeCountry(username, country);
  }

  void connectToGoogle(String username) {
    userService.connectToGoogle(username);
  }

  void disconnectFromGoogle(String username) {
    userService.disconnectFromGoogle(username);
  }

  Future<void> saveComment(String username, String commentId) async {
    userService.saveComment(username, commentId);
  }

  Future<List<Comments>>? getSavedComments(String username) async {
    return userService.getSavedComments(username);
  }

  Future<void> updateNotificationSettings() async {
    await userService.updateNotificationSettings(
        userAbout!.username, notificationsSettings!);
    await userService.getNotificationsSettings(userAbout!.username);
  }

  Future<void> updateSingleNotificationSetting(
      String username, String type, bool value) async {
    await userService.updateSingleNotificationSetting(username, type, value);
    await userService.getNotificationsSettings(username);
  }

  Future<void> getUserCommunities() async {
    userCommunities = await userService.getUserCommunities();
  }

  Future<int> getUnreadNotificationsCount() async {
    unreadNotificationsCount =
        await notificationService.getUnreadNotificationsCount();
    return unreadNotificationsCount;
  }

  Future<void> getUnreadMessagesCount() async {
    unreadMessagesCount =
        await userService.getUnreadMessagesCount(userAbout!.username);
  }
}

class SocialLinksController extends ChangeNotifier {
  final UserService userService = GetIt.instance.get<UserService>();
  final UserController userController = GetIt.instance.get<UserController>();
  List<SocialLlinkItem>? socialLinks = [];
  bool testing = const bool.fromEnvironment('testing');

  void getSocialLinks() {
    socialLinks = userController.userAbout!.socialLinks;
  }

  Future<void> removeSocialLink(
      String username, SocialLlinkItem socialLink) async {
    await userService.deleteSocialLink(username, socialLink.id);
    userController.userAbout!.socialLinks!.remove(socialLink);
    socialLinks!.remove(socialLink);
    notifyListeners();
  }

  Future<void> addSocialLink(
      String username, String displayName, String type, String link) async {
    await userService.addSocialLink(username, displayName, type, link);
    await userController.getUserAbout(userController.userAbout!.username);
    getSocialLinks();
    notifyListeners();
  }

  Future<void> editSocialLink(
      String username, String id, String displayName, String link) async {
    await userService.editSocialLink(username, id, displayName, link);
    await userController.getUserAbout(userController.userAbout!.username);
    getSocialLinks();
    notifyListeners();
  }
}

class BannerPictureController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  Future<void> changeBannerPicture(String bannerPicture) async {
    await userService.addBannerPicture(
        userController.userAbout!.username, bannerPicture);
    userController.userAbout!.bannerPicture = bannerPicture;
    notifyListeners();
  }

  Future<void> removeBannerPicture() async {
    await userService.removeBannerPicture(userController.userAbout!.username);
    userController.userAbout!.bannerPicture = '';
    notifyListeners();
  }
}

class ProfilePictureController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  Future<void> changeProfilePicture(String profilePicture) async {
    await userService.addProfilePicture(
        userController.userAbout!.username, profilePicture);
    userController.userAbout!.profilePicture = profilePicture;
    notifyListeners();
  }

  Future<void> removeProfilePicture() async {
    await userService.removeProfilePicture(userController.userAbout!.username);
    userController.userAbout!.profilePicture = '';
    notifyListeners();
  }
}

class FollowerFollowingController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();
  List<FollowersFollowingItem> followers = [];
  List<FollowersFollowingItem> following = [];

  Future<List<FollowersFollowingItem>> getFollowers(String username) async {
    followers = await userService.getFollowers(username);
    userController.followers = followers;
    return followers;
  }

  Future<List<FollowersFollowingItem>> getFollowing(String username) async {
    following = await userService.getFollowing(username);
    userController.following = following;
    return following;
  }

  Future<void> followUser(String username) async {
    await userService.followUser(username, userController.userAbout!.username);
    following =
        await userService.getFollowing(userController.userAbout!.username);
    userController.following = following;
    notifyListeners();
  }

  Future<void> unfollowUser(String username) async {
    await userService.unfollowUser(
        username, userController.userAbout!.username);
    following =
        await userService.getFollowing(userController.userAbout!.username);
    userController.following = following;
    notifyListeners();
  }
}

class EditProfileController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  Future<void> editProfile(
      String displayName,
      String about,
      bool? nsfw,
      bool? allowFollowers,
      bool contentVisibility,
      bool activeCommunity) async {
    userService.updateProfileSettings(
        userController.userAbout!.username,
        displayName,
        about,
        nsfw,
        allowFollowers,
        contentVisibility,
        activeCommunity);
    userController.profileSettings!.displayName = displayName;
    userController.profileSettings!.about = about;
    userController.profileSettings!.nsfwFlag = nsfw!;
    userController.profileSettings!.allowFollowers = allowFollowers!;
    userController.profileSettings!.contentVisibility = contentVisibility;
    userController.profileSettings!.activeCommunity = activeCommunity;
    userController.userAbout!.displayName = displayName;
    userController.userAbout!.about = about;
    notifyListeners();
  }
}

class SaveComment extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  Future<void> unsaveComment(String username, String commentId) async {
    userService.unsaveComment(username, commentId);
    notifyListeners();
  }
}

class ChangeEmail extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  Future<bool> changeEmail(
      String username, String email, String password) async {
    bool result = await userService.changeEmail(username, email, password);
    await userController.getUserAbout(username);
    notifyListeners();
    return result;
  }
}

class BlockUnblockUser extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  Future<void> blockUser(String username) async {
    await userService.blockUser(userController.userAbout!.username, username);
    userController.blockedUsers =
        await userService.getBlockedUsers(userController.userAbout!.username);
    notifyListeners();
  }

  Future<void> unblockUser(String username) async {
    await userService.unblockUser(userController.userAbout!.username, username);
    userController.blockedUsers =
        await userService.getBlockedUsers(userController.userAbout!.username);
    notifyListeners();
  }
}

class MessagesOperations extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  Future<bool> replyToMessage(
      String parentMessageId,
      String receiverUsername,
      String receiverType,
      String senderType,
      String? senderVia,
      String message,
      subject) async {
    bool success = await userService.replyMessage(
        parentMessageId,
        userController.userAbout!.username,
        receiverUsername,
        receiverType,
        senderType,
        senderVia,
        message,
        subject);
    if (success) {
      //userController.getUnreadMessagesCount();
      notifyListeners();
    }
    return success;
  }

  Future<bool> sendMessage(
      String receiverUsername, String message, String subject) async {
    bool success = await userService.sendNewMessage(
        userController.userAbout!.username, receiverUsername, message, subject);
    if (success) {
      //userController.getUnreadMessagesCount();
      notifyListeners();
    }
    return success;
  }

  Future<void> markallAsRead() async {
    await userService.markAllMessagesRead(userController.userAbout!.username);
    userController.unreadMessagesCount = 0;
    notifyListeners();
  }

  Future<void> markonAsRead(List<Messages> messages) async {
    for (var message in messages) {
      await userService.markoneMessageRead(
          userController.userAbout!.username, message.id);
    }
    //await userController.getUnreadMessagesCount();
    notifyListeners();
  }
}

class GetMessagesController extends ChangeNotifier {
  final userService = GetIt.instance.get<UserService>();
  final userController = GetIt.instance.get<UserController>();

  Future<List<Messages>> getUserMessages() async {
    List<Messages>? messages =
        await userService.getMessages(userController.userAbout!.username);
    await userController.getUnreadMessagesCount();
    notifyListeners();
    return messages!;
  }
}
