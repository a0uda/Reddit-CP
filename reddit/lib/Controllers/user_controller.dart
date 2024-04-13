import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/social_link_item.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Models/user_about.dart';

class UserController {
  final userService = GetIt.instance.get<UserService>();

  UserAbout? userAbout;
  List<BlockedUsersItem>? blockedUsers;
  AccountSettings? accountSettings;

  void getUser(String username) async {
    userAbout = await userService.getUserAbout(username);
    blockedUsers = userService.getBlockedUsers(username);
    accountSettings = await userService.getAccountSettings(username);
  }

  Future<UserAbout>? getUserAbout(String username) {
    return userService.getUserAbout(username);
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

  void blockUser(UserAbout userData, String username) {
    userService.blockUser(userData.username, username);
    blockedUsers = userService.getBlockedUsers(userData.username);
  }

  void unblockUser(UserAbout userData, String username) {
    userService.unblockUser(userData.username, username);
    blockedUsers = userService.getBlockedUsers(userData.username);
  }

  void changeGender(String username, String gender) {
    userService.changeGender(username, gender);
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
  List<SocialLlinkItem>? socialLinks;

  void getSocialLinks(String username) async {
    socialLinks = (await (userService.getUserAbout(username)))!.socialLinks;
    notifyListeners();
  }

  void removeSocialLink(String username, SocialLlinkItem socialLink) {
    userService.deleteSocialLink(username, socialLink.id);
    userController.getUser(username);
    socialLinks!.remove(socialLink);
    notifyListeners();
  }

  void addSocialLink(
      String username, String displayName, String type, String link) {
    userService.addSocialLink(username, displayName, type, link);
    userController.getUser(username);
    socialLinks = userController.userAbout!.socialLinks;
    notifyListeners();
  }

  void editSocialLink(
      String username, String id, String displayName, String link) {
    userService.editSocialLink(username, id, displayName, link);
    userController.getUser(username);
    socialLinks = userController.userAbout!.socialLinks;
    notifyListeners();
  }
}

class BannerPictureController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  void changeBannerPicture(String bannerPicture) {
    userService.addBannerPicture(
        userController.userAbout!.username, bannerPicture);
    userController.getUser(userController.userAbout!.username);
    notifyListeners();
  }

  void removeBannerPicture() {
    userService.removeBannerPicture(userController.userAbout!.username);
    userController.getUser(userController.userAbout!.username);
    notifyListeners();
  }
}

class ProfilePictureController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  void changeProfilePicture(String profilePicture) {
    userService.addProfilePicture(
        userController.userAbout!.username, profilePicture);
    userController.getUser(userController.userAbout!.username);
    notifyListeners();
  }

  void removeProfilePicture() {
    userService.removeProfilePicture(userController.userAbout!.username);
    userController.getUser(userController.userAbout!.username);
    notifyListeners();
  }
}

class FollowerFollowingController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();

  followUser(String username) {
    userService.followUser(username, userController.userAbout!.username);
    notifyListeners();
  }

  void unfollowUser(String username) {
    userService.unfollowUser(username, userController.userAbout!.username);
    notifyListeners();
  }
}

class EditProfileController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();
  ProfileSettings? profileSettings;

  void getProfileSettings(String username) {
    profileSettings = userService.getProfileSettings(username);
  }

  void editProfile(String displayName, String about, bool? nsfw,
      bool? allowFollowers, bool contentVisibility, bool activeCommunity) {
    userService.updateProfileSettings(
        userController.userAbout!.username,
        displayName,
        about,
        nsfw,
        allowFollowers,
        contentVisibility,
        activeCommunity);
    userController.getUser(userController.userAbout!.username);
    profileSettings =
        userService.getProfileSettings(userController.userAbout!.username);
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
