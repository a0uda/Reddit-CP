import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/followers_following_item.dart';
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

  Future<void> getUser(String username) async {
    userAbout = await userService.getUserAbout(username);
    blockedUsers = await userService.getBlockedUsers(username);
    accountSettings = await userService.getAccountSettings(username);
  }

  Future<void>? getUserAbout(String username) async {
    userAbout = await userService.getUserAbout(username);
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

  void changeCountry(String username, String country) {
    userService.changeCountry(username, country);
  }

  void connectToGoogle(String username) {
    userService.connectToGoogle(username);
  }

  void disconnectFromGoogle(String username) {
    userService.disconnectFromGoogle(username);
  }

  void saveComment(String username, String commentId) {
    userService.saveComment(username, commentId);
  }

  List<Comments>? getSavedComments(String username) {
    return userService.getSavedComments(username);
  }
}

class SocialLinksController extends ChangeNotifier {
  final UserService userService = GetIt.instance.get<UserService>();
  final UserController userController = GetIt.instance.get<UserController>();
  List<SocialLlinkItem>? socialLinks = [];
  bool testing = const bool.fromEnvironment('testing');

  Future<void> getSocialLinks(String username) async {
    if (testing == false) {
      //todo: to be changed wen databse function is implemented
      socialLinks = users
          .firstWhere((element) => element.userAbout.username == 'Purple-7544')
          .userAbout
          .socialLinks;
    } else {
      socialLinks = (await (userService.getUserAbout(username)))!.socialLinks;
    }
  }

  Future<void> removeSocialLink(
      String username, SocialLlinkItem socialLink) async {
    if (testing == false) {
      await userService.deleteSocialLink('Purple-7544', socialLink.id);
      socialLinks!.remove(socialLink);
      notifyListeners();
    } else {
      await userService.deleteSocialLink(username, socialLink.id);
      await userController.getUserAbout(username);
      socialLinks!.remove(socialLink);
      notifyListeners();
    }
  }

  Future<void> addSocialLink(
      String username, String displayName, String type, String link) async {
    if (testing == false) {
      await userService.addSocialLink('Purple-7544', displayName, type, link);
      await getSocialLinks(username);
      notifyListeners();
    } else {
      await userService.addSocialLink(username, displayName, type, link);
      await userController.getUserAbout(username);
      socialLinks = userController.userAbout!.socialLinks;
      notifyListeners();
    }
  }

  Future<void> editSocialLink(
      String username, String id, String displayName, String link) async {
    if (testing == false) {
      await userService.editSocialLink('Purple-7544', id, displayName, link);
      await getSocialLinks(username);
      notifyListeners();
    } else {
      await userService.editSocialLink(username, id, displayName, link);
      await userController.getUserAbout(username);
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
    await userController.getUserAbout(userController.userAbout!.username);
    notifyListeners();
  }

  Future<void> removeBannerPicture() async {
    await userService.removeBannerPicture(userController.userAbout!.username);
    await userController.getUserAbout(userController.userAbout!.username);
    notifyListeners();
  }
}

class ProfilePictureController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  Future<void> changeProfilePicture(String profilePicture) async {
    await userService.addProfilePicture(
        userController.userAbout!.username, profilePicture);
    await userController.getUserAbout(userController.userAbout!.username);
    notifyListeners();
  }

  Future<void> removeProfilePicture() async {
    await userService.removeProfilePicture(userController.userAbout!.username);
    await userController.getUserAbout(userController.userAbout!.username);
    notifyListeners();
  }
}

class FollowerFollowingController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  Future<List<FollowersFollowingItem>> getFollowers(String username) async {
    return userService.getFollowers(username);
  }

  Future<List<FollowersFollowingItem>> getFollowing(String username) async {
    return userService.getFollowing(username);
  }

  Future<void> followUser(String username) async {
    await userService.followUser(username, userController.userAbout!.username);
    notifyListeners();
  }

  Future<void> unfollowUser(String username) async {
    await userService.unfollowUser(
        username, userController.userAbout!.username);
    notifyListeners();
  }
}

class EditProfileController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();
  ProfileSettings? profileSettings;

  Future<void> getProfileSettings(String username) async {
    profileSettings = await userService.getProfileSettings(username);
  }

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
    await userController.getUserAbout(userController.userAbout!.username);
    notifyListeners();
  }
}

class SaveComment extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  void unsaveComment(String username, String commentId) {
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
    userController.getUserAbout(username);
    notifyListeners();
    return result;
  }
}
