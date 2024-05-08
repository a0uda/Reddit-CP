import 'package:get_it/get_it.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/Services/moderator_service.dart';

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
    this.editedAt,
    this.deletedAt,
    required this.isDeleted,
    required this.username,
    required this.communityName,
    required this.nsfwFlag,
    required this.spoilerFlag,
    required this.postInCommunityFlag,
    required this.postID,
    required this.itemID,
  });
  ModeratorDetails moderatorDetails;
  List<dynamic> queuePostImage;
  List<QueuePostImage>? queuePostImageObject;
  String postTitle;
  String postDescription;
  String createdAt;
  String? editedAt;
  String? deletedAt;
  bool isDeleted;
  String username;
  String communityName;
  bool nsfwFlag;
  bool spoilerFlag;
  bool postInCommunityFlag;
  String profilePicture = '';
  String postID;
  String itemID;

  Future<String> getProfilePicture(
      String username, String communityName) async {
    final moderatorService = GetIt.instance.get<ModeratorMockService>();

    Map<String, dynamic> comm =
        await moderatorService.getCommunityInfo(communityName: communityName);
    profilePicture = comm["communityProfilePicture"];

    return profilePicture;
  }
}

class ModeratorDetails {
  ModeratorDetails({
    required this.unmoderated,
    required this.reported,
    required this.spammed,
    required this.removed,
    required this.editHistory,

  });
  Unmoderated unmoderated;
  Reported reported;
  Spammed spammed;
  Removed removed;
  List<EditHistory> editHistory;
}

class QueuePostImage {
  QueuePostImage({
    required this.imagePath,
    required this.imageCaption,
    required this.imageLink,
  });
  String imagePath;
  String imageCaption;
  String imageLink;
}

class Unmoderated {
  Unmoderated({required this.approvedFlag});
  bool approvedFlag;
}

class Approved {
  Approved({required this.flag});
  bool flag;
}

class Reported {
  Reported({
    required this.flag,
    required this.type,
    required this.confirmed,
  });
  bool flag;
  String? type;
  bool confirmed;
}

class Spammed {
  Spammed({
    required this.flag,
    required this.type,
    required this.confirmed,
  });
  bool flag;
  String? type;
  bool confirmed;
}

class Removed {
  Removed({
    required this.flag,
    required this.type,
    required this.confirmed,
    required this.removedBy,
    required this.removedDate,
  });
  bool flag;
  String? type;
  bool confirmed;
  String? removedBy;
  String? removedDate;
}

class EditHistory {
  EditHistory({
    required this.editedAt,
    required this.approvedEditFlag,
    required this.removedEditFlag,
  });
  String editedAt;
  bool approvedEditFlag;
  bool removedEditFlag;
}
