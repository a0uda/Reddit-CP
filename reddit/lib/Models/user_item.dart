import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';
import '../Models/comments.dart';
import '../Models/profile_settings.dart';
import '../Models/safety_settings_item.dart';

class UserItem {
  final UserAbout userAbout;
  final String? password;
  final List<FollowersFollowingItem>? followers;
  final List<FollowersFollowingItem>? following;
  final List<Comments>? comments;
  final ProfileSettings? profileSettings;
  final SafetyAndPrivacySettings? safetySettings;

  UserItem({
    required this.userAbout,
    this.password,
    this.followers,
    this.following,
    this.comments,
    this.profileSettings,
    this.safetySettings,
  });
}
