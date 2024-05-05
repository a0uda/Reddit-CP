import 'package:reddit/Models/rules_item.dart';

class CommunityItem {
  CommunityItem({
    required this.communityName,
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

  GeneralSettings general;
  final String communityName;
  final String communityMembersNo;
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
      required this.communityTitle,
      required this.communityDescription,
      required this.communityType,
      required this.nsfwFlag});

  String communityID;
  String communityTitle;
  String communityDescription;
  String communityType;
  bool nsfwFlag;

  void updateAllGeneralSettings(
      {required String communityID,
      required String communityTitle,
      required String communityDescription,
      required String communityType,
      required bool nsfwFlag}) {
    this.communityID = communityID;
    this.communityTitle = communityTitle;
    this.communityDescription = communityDescription;
    this.communityType = communityType;
    this.nsfwFlag = nsfwFlag;
  }
}

class QueuesPostItem {
  QueuesPostItem({
    required this.queuePostImage,
    required this.moderatorDetails,
    required this.postTitle,
    required this.postDescription,
    required this.createdAt,
    required this.editedAt,
    required this.deletedAt,
    required this.isDeleted,
    required this.username,
    required this.communityName,
    required this.nsfwFlag,
    required this.spoilerFlag,

  });
  ModeratorDetails moderatorDetails;
  QueuePostImage queuePostImage;
  String postTitle;
  String postDescription;
  String createdAt;
  String editedAt;
  String deletedAt;
  bool isDeleted;
  String username;
  String communityName;
  bool nsfwFlag;
  bool spoilerFlag;
}

class ModeratorDetails {
  ModeratorDetails({
    required this.approvedFlag,
    required this.approvedDate,
    required this.removedFlag,
    required this.removedBy,
    required this.removedDate,
    required this.removedRemovalReason,
    required this.spammedFlag,
    required this.spammedBy,
    required this.spammedType,
    required this.spammedRemovalReason,
    required this.reportedFlag,
    required this.reportedBy,
    required this.reportedType,
  });
  bool approvedFlag;
  String approvedDate;
  bool removedFlag;
  String removedBy;
  String removedDate;
  String removedRemovalReason;
  bool spammedFlag;
  String spammedBy;
  String spammedType;
  String spammedRemovalReason;
  bool reportedFlag;
  String reportedBy;
  String reportedType;
}
class QueuePostImage {
  QueuePostImage({
    required this. imagePath,
    required this.imageCaption,
    required this.imageLink,
  });
  String imagePath;
  String imageCaption;
  String imageLink;
}

