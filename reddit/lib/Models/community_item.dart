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
    required this.allowImage,
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
  String postTypes;
  bool allowImage;
  bool allowPolls;
  bool allowVideos;

  void updatePostTypes(
      {required String communityName, required String postTypes}) {
    this.postTypes = postTypes;
  }

  void updateAllowImage(
      {required String communityName, required bool allowImage}) {
    this.allowImage = allowImage;
  }

  void updateAllowPools(
      {required String communityName, required bool allowPolls}) {
    this.allowPolls = allowPolls;
  }

  void updateAllowVideo(
      {required String communityName, required bool allowVideos}) {
    this.allowVideos = allowVideos;
  }
}

class GeneralSettings {
  GeneralSettings(
      {required this.communityID,
      required this.communityName,
      required this.communityDescription,
      required this.communityType,
      required this.nsfwFlag});

  String communityID;
  String communityName;
  String communityDescription;
  String communityType;
  bool nsfwFlag;

  void updateAllGeneralSettings(
      {required String communityID,
      required String communityName,
      required String communityDescription,
      required String communityType,
      required bool nsfwFlag}) {
    this.communityID = communityID;
    this.communityName = communityName;
    this.communityDescription = communityDescription;
    this.communityType = communityType;
    this.nsfwFlag = nsfwFlag;
  }
}
