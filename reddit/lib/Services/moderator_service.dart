//TODOOOOOO:
//FIX  add MUTED USERS PAGE
//queues arrays mesh ma3moolaaaaa.

import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/test_files/test_communities.dart';

class ModeratorMockService {
  bool testing = true;

  List<RulesItem> getRules(String communityName) {
    List<RulesItem> foundRules = communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .communityRules;
    return foundRules;
  }

  void createRules(
      {required String id,
      required String communityName,
      required String ruleTitle,
      required String appliesTo,
      required String reportReason,
      String? ruleDescription}) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .communityRules
        .add(
          RulesItem(
            id: id,
            ruleTitle: ruleTitle,
            appliesTo: appliesTo,
            reportReason: reportReason,
            ruleDescription: ruleDescription ?? "",
          ),
        );
  }

  void editRules(
      {required String id,
      required String communityName,
      required String ruleTitle,
      required String appliesTo,
      String? reportReason,
      String? ruleDescription}) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .communityRules
        .firstWhere((rule) => rule.id == id)
        .updateAll(
            appliesTo: appliesTo,
            id: id,
            ruleTitle: ruleTitle,
            reportReason: reportReason ?? "",
            ruleDescription: ruleDescription ?? "");
  }

  void deleteRule(String communityName, String id) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .communityRules
        .removeWhere((rule) => rule.id == id);
  }

  List<Map<String, dynamic>> getApprovedUsers(String communityName) {
    List<Map<String, dynamic>> approvedUsers = communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .approvedUsers;
    return approvedUsers;
  }

  void addApprovedUsers(String username, String communityName) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .approvedUsers
        .add(
      {
        "username": username,
        "approved_at": "Now",
        "profile_picture": "images/Greddit.png",
        "_id": "6618844ad57c873637b5cf2"
      },
    );
  }

  List<Map<String, dynamic>> getBannedUsers(String communityName) {
    List<Map<String, dynamic>> bannedUsers = communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .bannedUsers;
    return bannedUsers;
  }

  void addBannedUsers({
    required String username,
    required String communityName,
    required bool permanentFlag,
    required String reasonForBan,
    String? bannedUntil,
    String? noteForBanMessage,
    String? modNote,
  }) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .bannedUsers
        .add(
      {
        "username": username,
        "banned_date": "Now",
        "reason_for_ban": reasonForBan,
        "mod_note": modNote ?? "",
        "permanent_flag": permanentFlag,
        "banned_until": bannedUntil ?? "",
        "note_for_ban_message": noteForBanMessage ?? "",
        "profile_picture": "images/Greddit.png",
        "_id": "66186ace721cbd638232612a"
      },
    );
  }

  List<Map<String, dynamic>> getMutedUsers(String communityName) {
    List<Map<String, dynamic>> mutedUsers = communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .mutedUsers;
    return mutedUsers;
  }

  void addMutedUsers(String username, String communityName) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .mutedUsers
        .add(
      {
        "username": username,
        "approved_at": "Now",
        "profile_picture": "images/Greddit.png",
        "_id": "6618844ad57c873637b5cf2"
      },
    );
  }

  List<Map<String, dynamic>> getModerators(String communityName) {
    List<Map<String, dynamic>> moderators = communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .moderators;
    return moderators;
  }

  void inviteModerator({
    required String communityName,
    required String username,
    required bool everything,
    required bool manageUsers,
    required bool manageSettings,
    required bool managePostsAndComments,
  }) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .moderators
        .add(
      {
        "everything": everything,
        "manage_users": manageUsers,
        "manage_settings": manageSettings,
        "manage_posts_and_comments": managePostsAndComments,
        "username": username,
        "profile_picture": "images/Greddit.png",
        "moderator_since": "Now"
      },
    );
  }

  GeneralSettings getCommunityGeneralSettings(String communityName) {
    return communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .general;
  }

  Map<String, dynamic> getPostTypesAndOptions(String communityName) {
    //mostafa mohyy feeha kalam
    var foundCommunity = communities.firstWhere(
        (community) => community.general.communityName == communityName);
    return {
      "postTypes": foundCommunity.postTypes,
      "allowImages": foundCommunity.allowImage,
      "allowPolls": foundCommunity.allowPolls,
      "allowVideo": foundCommunity.allowVideos,
    };
  }
}

void postGeneralSettings(
    {required GeneralSettings settings, required String communityName}) {
  communities
      .firstWhere(
          (community) => community.general.communityName == communityName)
      .general
      .updateAllGeneralSettings(
          communityID: settings.communityID,
          communityName: settings.communityName,
          communityDescription: settings.communityDescription,
          communityType: settings.communityType,
          nsfwFlag: settings.nsfwFlag);
}

void setPostTypeAndOptions({
  required bool allowImages,
  required bool allowVideos,
  required bool allowPolls,
  required String communityName,
  required String postTypes,
}) {
  var community = communities.firstWhere(
    (community) => community.general.communityName == communityName,
  );
  community.updatePostTypes(
    communityName: communityName,
    postTypes: postTypes,
  );

  community.updateAllowImage(
    communityName: communityName,
    allowImage: allowImages,
  );

  community.updateAllowPools(
    communityName: communityName,
    allowPolls: allowPolls,
  );

  community.updateAllowVideo(
    communityName: communityName,
    allowVideos: allowVideos,
  );
}
