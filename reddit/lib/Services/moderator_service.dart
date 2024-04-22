import 'dart:convert';

import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/test_files/test_communities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

bool testing = const bool.fromEnvironment('testing');

class ModeratorMockService {
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
      String? reportReason,
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
            reportReason: reportReason ?? "",
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

  Future<List<Map<String, dynamic>>> getApprovedUsers(
      String communityName) async {
    if (testing == true) {
      List<Map<String, dynamic>> approvedUsers = communities //badr
          .firstWhere(
              (community) => community.general.communityName == communityName)
          .approvedUsers;
      return approvedUsers;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); //badrr
      final url = Uri.parse(
          'https://redditech.me/backend/communities/about/approved/$communityName');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      final List<dynamic> decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> approvedUsers =
          List<Map<String, dynamic>>.from(decodedData);
      return approvedUsers; //badrrr
    }
  }

  void addApprovedUsers(String username, String communityName) {
    if (testing) {
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
    } else {
      //add
    }
  }

  void removeApprovedUsers(String username, String communityName) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .approvedUsers
        .removeWhere((user) => user["username"] == username);
  }

  Future<List<Map<String, dynamic>>> getBannedUsers(
      String communityName) async {
    if (testing) {
      List<Map<String, dynamic>> bannedUsers = communities
          .firstWhere(
              (community) => community.general.communityName == communityName)
          .bannedUsers;
      return bannedUsers;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); //badrr
      final url = Uri.parse(
          'https://redditech.me/backend/communities/about/banned/$communityName');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      final decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> bannedUsers =
          List<Map<String, dynamic>>.from(decodedData);
      return bannedUsers; //badrrr
    }
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

  void updateBannedUser({
    required String username,
    required String communityName,
    required bool permanentFlag,
    required String reasonForBan,
    String? bannedUntil,
    String? noteForBanMessage,
    String? modNote,
  }) {
    var user = communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .bannedUsers
        .firstWhere((user) => user["username"] == username);
    user["reason_for_ban"] = reasonForBan;
    user["mod_note"] = modNote;
    user["permanent_flag"] = permanentFlag;
    user["banned_until"] = bannedUntil ?? "";
    user["note_for_ban_message"] = noteForBanMessage ?? "";
  }

  void unBanUser(String username, String communityName) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .bannedUsers
        .removeWhere((user) => user["username"] == username);
  }

  Future<List<Map<String, dynamic>>> getMutedUsers(String communityName) async {
    if (testing) {
      List<Map<String, dynamic>> mutedUsers = communities
          .firstWhere(
              (community) => community.general.communityName == communityName)
          .mutedUsers;
      return mutedUsers;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); //badrr
      final url = Uri.parse(
          'https://redditech.me/backend/communities/about/muted/$communityName');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      final decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> mutedUsers =
          List<Map<String, dynamic>>.from(decodedData);
      return mutedUsers; //badrrr
    }
  }

  void addMutedUsers(String username, String communityName) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .mutedUsers
        .add(
      {
        "username": username,
        "mute_date": "Now",
        "muted_by_username": "To be doneee",
        "mute_reason": "to be donee", //badrrrrr
        "profile_picture": "images/Greddit.png",
        "_id": "6618844ad57c873637b5cf2"
      },
    );
  }

  void unMuteUser(String username, String communityName) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .mutedUsers
        .removeWhere((user) => user["username"] == username);
  }

  Future<List<Map<String, dynamic>>> getModerators(String communityName) async {
    if (testing) {
      List<Map<String, dynamic>> moderators = communities
          .firstWhere(
              (community) => community.general.communityName == communityName)
          .moderators;
      return moderators;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); //badrr
      final url = Uri.parse(
          'https://redditech.me/backend/communities/about/moderators/$communityName');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      final decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> moderators =
          List<Map<String, dynamic>>.from(decodedData);
      return moderators; //badrrr
    }
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

  void removeAsMod(String username, String communityName) {
    communities
        .firstWhere(
            (community) => community.general.communityName == communityName)
        .moderators
        .removeWhere((user) => user["username"] == username);
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
}
