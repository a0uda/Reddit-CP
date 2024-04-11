import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/social_link_item.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Models/user_about.dart';

class UserController {
  final userService = GetIt.instance.get<UserService>();

  UserAbout? userAbout;
  List<BlockedUsersItem>? blockedUsers;

  void getUser(String username) async {
    userAbout = userService.getUserAbout(username);
    blockedUsers = userService.getBlockedUsers();
  }

  void blockUser(String username) {
    userService.blockUser(username);
    blockedUsers = userService.getBlockedUsers();
  }

  void unblockUser(String username) {
    userService.unblockUser(username);
    blockedUsers = userService.getBlockedUsers();
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
    userService.addBannerPicture(userController.userAbout!.username, bannerPicture);
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
    userService.addProfilePicture(userController.userAbout!.username, profilePicture);
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

  void editProfile(String displayName,String about,bool? nsfw,bool? allowFollowers, bool contentVisibility, bool activeCommunity) {
    userService.updateProfileSettings(userController.userAbout!.username, displayName, about, nsfw, allowFollowers, contentVisibility, activeCommunity);
    userController.getUser(userController.userAbout!.username);
    notifyListeners();
  }
}