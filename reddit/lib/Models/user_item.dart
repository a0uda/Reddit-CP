import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';

class UserItem {
  final UserAbout userAbout;
  final String? password;
  final List<FollowersFollowingItem>? followers;
  final List<FollowersFollowingItem>? following;

  UserItem({
    required this.userAbout,
    this.password,
    this.followers,
    this.following,
  });
}