import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/notifications_settings_item.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/social_link_item.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/test_files/test_users.dart';

class UserController {
  final userService = GetIt.instance.get<UserService>();

  UserAbout? userAbout;
  List<BlockedUsersItem>? blockedUsers;
  AccountSettings? accountSettings;
  ProfileSettings? profileSettings;
  NotificationsSettingsItem? notificationsSettings;
  List<CommunityBackend>? userCommunities;
  List<FollowersFollowingItem>? followers;
  List<FollowersFollowingItem>? following;

  Future<void> getUser(String username) async {
    userAbout = await userService.getUserAbout(username);
    blockedUsers = await userService.getBlockedUsers(username);
    // accountSettings = await userService.getAccountSettings(username);
    // notificationsSettings =
    //     await userService.getNotificationsSettings(username);
  }

  Future<NotificationsSettingsItem?> getNotificationsSettings(
      String username) async {
    return await userService.getNotificationsSettings(username);
  }

  Future<void>? getUserAbout(String username) async {
    userAbout = await userService.getUserAbout(username);
  }

  Future<void> getProfileSettings(String username) async {
    profileSettings = (await userService.getProfileSettings(username))!;
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

  Future<void> getUserCommunities() async {
    userCommunities = await userService.getUserCommunities();
  }
}

class SocialLinksController extends ChangeNotifier {
  final UserService userService = GetIt.instance.get<UserService>();
  final UserController userController = GetIt.instance.get<UserController>();
  List<SocialLlinkItem>? socialLinks = [];
  bool testing = const bool.fromEnvironment('testing');

  void getSocialLinks() {
    if (testing == false) {
      //todo: to be changed wen databse function is implemented
      socialLinks = users
          .firstWhere((element) => element.userAbout.username == 'Purple-7544')
          .userAbout
          .socialLinks;
    } else {
      socialLinks = userController.userAbout!.socialLinks;
    }
  }

  Future<void> removeSocialLink(
      String username, SocialLlinkItem socialLink) async {
    if (testing == false) {
      await userService.deleteSocialLink('Purple-7544', socialLink.id);
      userController.userAbout!.socialLinks!.remove(socialLink);
      socialLinks!.remove(socialLink);
      notifyListeners();
    } else {
      await userService.deleteSocialLink(username, socialLink.id);
      userController.userAbout!.socialLinks!.remove(socialLink);
      socialLinks!.remove(socialLink);
      notifyListeners();
    }
  }

  Future<void> addSocialLink(
      String username, String displayName, String type, String link) async {
    if (testing == false) {
      await userService.addSocialLink('Purple-7544', displayName, type, link);
      getSocialLinks();
      notifyListeners();
    } else {
      await userService.addSocialLink(username, displayName, type, link);
      await userController.getUserAbout(userController.userAbout!.username);
      getSocialLinks();
      notifyListeners();
    }
  }

  Future<void> editSocialLink(
      String username, String id, String displayName, String link) async {
    if (testing == false) {
      await userService.editSocialLink('Purple-7544', id, displayName, link);
      getSocialLinks();
      notifyListeners();
    } else {
      await userService.editSocialLink('Purple-7544', id, displayName, link);
      userController.userAbout!.socialLinks!
          .firstWhere((element) => element.id == id)
          .displayText = displayName;
      userController.userAbout!.socialLinks!
          .firstWhere((element) => element.id == id)
          .customUrl = link;
      socialLinks = userController.userAbout!.socialLinks;
      notifyListeners();
    }
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
  List<FollowersFollowingItem>? followers;
  List<FollowersFollowingItem>? following;

  Future<List<FollowersFollowingItem>> getFollowers(String username) async {
    followers = await userService.getFollowers(username);
    userController.followers = followers;
    return followers!;
  }

  Future<List<FollowersFollowingItem>> getFollowing(String username) async {
    following = await userService.getFollowing(username);
    userController.following = following;
    return following!;
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
    Future<bool> result = userService.changeEmail(username, email, password);
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

  Future<bool> replyToMessage(String parentMessageId, String receiverUsername,
      String receiverType, String message) async {
    bool success = await userService.replyMessage(
        parentMessageId,
        userController.userAbout!.username,
        receiverUsername,
        receiverType,
        message);
    if (success) {
      notifyListeners();
    }
    return success;
  }

  Future<bool> sendMessage(
      String receiverUsername, String message, String subject) async {
    bool success = await userService.sendNewMessage(
        userController.userAbout!.username, receiverUsername, message, subject);
    if (success) {
      notifyListeners();
    }
    return success;
  }

  Future<void> markallAsRead() async 
  {
    await userService.markAllMessagesRead(userController.userAbout!.username);
    notifyListeners();
  }
}
