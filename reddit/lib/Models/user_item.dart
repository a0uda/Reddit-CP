import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';
import '../Models/comments.dart';

class UserItem {
  final UserAbout userAbout;
  final String? password;
  final List<FollowersFollowingItem>? followers;
  final List<FollowersFollowingItem>? following;
  final List<Comments>? comments;

  UserItem({
    required this.userAbout,
    this.password,
    this.followers,
    this.following,
    this.comments,
  });
}
