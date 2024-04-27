import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';
import '../Models/comments.dart';
import '../Models/profile_settings.dart';
import '../Models/safety_settings_item.dart';
import '../Models/community_item.dart';
import '../Models/notifications_settings_item.dart';

class UserItem {
  List<String>? savedCommentsIds;
  final UserAbout userAbout;
  String? password;
  final List<FollowersFollowingItem>? followers;
  final List<FollowersFollowingItem>? following;
  final List<Comments>? comments;
  final ProfileSettings? profileSettings;
  final SafetyAndPrivacySettings? safetySettings;
  final AccountSettings? accountSettings;
  List<CommunityItem>? activecommunities;
   NotificationsSettingsItem? notificationsSettings;
   BlockedUsersItem? blockedUsers;

  UserItem({
    required this.userAbout,
    this.password,
    this.followers,
    this.following,
    this.comments,
    this.profileSettings,
    this.safetySettings,
    this.accountSettings,
    this.activecommunities,
    this.savedCommentsIds,
    this.notificationsSettings,
    this.blockedUsers,
  
  });
}
