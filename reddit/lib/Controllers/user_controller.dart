import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/social_link_item.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Models/user_about.dart';

class UserController {
  final userService = GetIt.instance.get<UserService>();

  UserAbout? userAbout;
  List<BlockedUsersItem>? blockedUsers;
  AccountSettings? accountSettings;

  void getUser(String username) async {
    userAbout = userService.getUserAbout(username);
    blockedUsers = userService.getBlockedUsers(username);
    accountSettings = userService.getAccountSettings(username);
  }

  UserAbout? getUserAbout(String username) {
    return userService.getUserAbout(username);
  }

  AccountSettings? getAccountSettings(String username) {
    return userService.getAccountSettings(username);
  }

  bool changeEmail(String username, String email, String password) {
    return userService.changeEmail(username, email, password);
  }

  bool changePassword(String username, String password) {
    return userService.changePassword(username, password);
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

  void savePost(String username, String postId) {
    userService.savePost(username, postId);
  }

  void unsavePost(String username, String postId) {
    userService.unsavePost(username, postId);
  }

  List<String>? getSavedPosts(String username) {
    return userService.getSavedPosts(username);
  }
}

class SocialLinksController extends ChangeNotifier {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();
  late List<SocialLlinkItem>? socialLinks =
      userController.userAbout?.socialLinks;

  void removeSocialLink(UserAbout userData, SocialLlinkItem socialLink) {
    userService.deleteSocialLink(userData.username, socialLink.id);
    userController.getUser(userData.username);
    socialLinks!.remove(socialLink);
    notifyListeners();
  }

  void addSocialLink(
      String username, String displayName, String type, String link) {
    userService.addSocialLink(username, displayName, type, link);
    userController.getUser(username);
    socialLinks = userController.userAbout?.socialLinks;
    notifyListeners();
  }

  void editSocialLink(
      String username, String id, String displayName, String link) {
    userService.editSocialLink(username, id, displayName, link);
    userController.getUser(username);
    socialLinks = userController.userAbout?.socialLinks;
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
    notifyListeners();
  }
}
