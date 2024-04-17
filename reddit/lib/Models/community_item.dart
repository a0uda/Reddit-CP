import 'package:reddit/Models/rules_item.dart';

class CommunityItem {
  CommunityItem({
    required this.general,
    required this.communityMembersNo,
    required this.communityRules,
    required this.communityProfilePicturePath,
    required this.approvedUsers,
    required this.bannedUsers,
    required this.mutedUsers,
    required this.moderators,
    required this.editableModerators,
    required this.postTypes,
    required this.allowPolls,
    required this.allowVideos,
    required this.allow_image_uploads_and_links_to_image_hosting_sites,
    this.communityCoverPicturePath,
  });

  final GeneralSettings general;
  final int communityMembersNo;
  final List<RulesItem> communityRules;
  final String communityProfilePicturePath;
  final String? communityCoverPicturePath;
  final List<Map<String, dynamic>> approvedUsers;
  final List<Map<String, dynamic>> bannedUsers;
  final List<Map<String, dynamic>> mutedUsers;
  final List<Map<String, dynamic>> moderators;
  final List<Map<String, dynamic>> editableModerators;
  final String postTypes;
  final bool allow_image_uploads_and_links_to_image_hosting_sites;
  final bool allowPolls;
  final bool allowVideos;
}

class GeneralSettings {
  const GeneralSettings(
      {required this.communityID,
      required this.communityName,
      required this.communityDescription,
      required this.communityType,
      required this.nsfwFlag});

  final String communityID;
  final String communityName;
  final String communityDescription;
  final String communityType;
  final bool nsfwFlag;
}
