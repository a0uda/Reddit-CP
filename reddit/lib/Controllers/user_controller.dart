import 'package:get_it/get_it.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Models/user_about.dart';

class UserController {
  final userService = GetIt.instance.get<UserService>();

  UserAbout? userAbout;
  List<BlockedUsersItem>? blockedUsers;

  void getUser(String username) async {
    userAbout = userService.getUserAbout(username); //to be replaced by username
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
