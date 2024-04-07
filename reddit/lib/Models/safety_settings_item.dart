import 'package:reddit/Models/blocked_users_item.dart';

class SafetyAndPrivacySettings {
  final List<BlockedUsersItem> blockedUsers;
  final List<MutedCommunity> mutedCommunities;

  SafetyAndPrivacySettings({
    required this.blockedUsers,
    required this.mutedCommunities,
  });
}

class MutedCommunity {
  final String id;
  final String communityName;
  final String profilePicture;
  final String mutedDate;

  MutedCommunity({
    required this.id,
    required this.communityName,
    required this.profilePicture,
    required this.mutedDate,
  });
}
