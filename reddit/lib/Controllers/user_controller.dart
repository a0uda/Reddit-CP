import 'package:get_it/get_it.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Models/user_about.dart';

class UserController {
  final userService = GetIt.instance.get<UserService>();

  UserAbout? userAbout;

  void getUser(String username) async {
    userAbout = userService.getUserAbout(username); //to be replaced by username
  }
}
