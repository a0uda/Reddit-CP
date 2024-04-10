import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/social_link_item.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Models/user_about.dart';

class UserController {
  final userService = GetIt.instance.get<UserService>();

  UserAbout? userAbout;
  List<BlockedUsersItem>? blockedUsers;

  void getUser(String username) async {
    userAbout = userService.getUserAbout(username);
    blockedUsers = userService.getBlockedUsers(username);
  }

  void blockUser(UserAbout userData, String username) {
    userService.blockUser(userData.username, username);
    blockedUsers = userService.getBlockedUsers(userData.username);
  }

  void unblockUser(UserAbout userData, String username) {
    userService.unblockUser(userData.username, username);
    blockedUsers = userService.getBlockedUsers(userData.username);
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
