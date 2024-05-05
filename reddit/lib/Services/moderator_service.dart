import 'dart:convert';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/test_files/test_communities.dart';
import 'package:reddit/widgets/Moderator/add_banned_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

bool testing = const bool.fromEnvironment('testing');

class ModeratorMockService {
  Future<List<RulesItem>> getRules(String communityName) async {
    if (testing) {
      List<RulesItem> foundRules = communities
          .firstWhere((community) => community.communityName == communityName)
          .communityRules;
      return foundRules;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); //badrr
      final url = Uri.parse(
          'https://redditech.me/backend/communities/get-rules/$communityName');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      final List<dynamic> decodedData = json.decode(response.body);
      final List<RulesItem> rules = decodedData
          .map((rule) => RulesItem(
                id: rule["_id"],
                ruleTitle: rule["rule_title"],
                appliesTo: rule["applies_to"],
                reportReason: rule["report_reason"],
                ruleDescription: rule["full_description"],
              ))
          .toList();
      return rules; //badrr
    }
  }

  Future<void> createRule(
      {String? id,
      required String communityName,
      required String ruleTitle,
      required String appliesTo,
      String? reportReason,
      String? ruleDescription}) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
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
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/communities/add-rule');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'rule_title': ruleTitle,
          'applies_to': appliesTo,
          if (reportReason != null) 'report_reason': reportReason,
          if (ruleDescription != null) 'full_description': ruleDescription,
        }),
      );
    }
  }

  Future<void> editRules(
      {required String id,
      required String communityName,
      required String ruleTitle,
      required String appliesTo,
      String? reportReason,
      String? ruleDescription}) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
          .communityRules
          .firstWhere((rule) => rule.id == id)
          .updateAll(
              appliesTo: appliesTo,
              id: id,
              ruleTitle: ruleTitle,
              reportReason: reportReason ?? "",
              ruleDescription: ruleDescription ?? "");
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/communities/edit-rule');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'rule_id': id,
          'community_name': communityName,
          'rule_title': ruleTitle,
          'applies_to': appliesTo,
          if (reportReason != null) 'report_reason': reportReason,
          if (ruleDescription != null) 'full_description': ruleDescription,
        }),
      );
    }
  }

  Future<void> deleteRule(String communityName, String id) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
          .communityRules
          .removeWhere((rule) => rule.id == id);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/communities/delete-rule');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'rule_id': id,
        }),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getApprovedUsers(
      String communityName) async {
    if (testing == true) {
      List<Map<String, dynamic>> approvedUsers = communities //badr
          .firstWhere((community) => community.communityName == communityName)
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
      //print("ALOOOOOOO");
      // print(response.body);
      return approvedUsers; //badrrr
    }
  }

  Future<void> addApprovedUsers(String username, String communityName) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/communities/approve-user');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'username': username,
        }),
      );
      print(response.body);
    }
  }

  Future<void> removeApprovedUsers(
      String username, String communityName) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
          .approvedUsers
          .removeWhere((user) => user["username"] == username);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/communities/unapprove-user'); //removee badrrr
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'username': username,
        }),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getBannedUsers(
      String communityName) async {
    if (testing) {
      List<Map<String, dynamic>> bannedUsers = communities
          .firstWhere((community) => community.communityName == communityName)
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

  Future<void> addBannedUsers({
    required String username,
    required String communityName,
    required bool permanentFlag,
    required String reasonForBan,
    String? bannedUntil,
    String? noteForBanMessage,
    String? modNote,
  }) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
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
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/communities/ban-user');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'username': username,
          "action": "ban",
          "reason_for_ban": reasonForBan,
          "permanent_flag": permanentFlag,
          if (modNote != null) "mod_note": modNote,
          if (noteForBanMessage != null)
            "note_for_ban_message": noteForBanMessage,
          if (bannedUntil != null) "banned_until": bannedUntil
        }),
      );
    }
  }

  Future<void> updateBannedUser({
    required String username,
    required String communityName,
    required bool permanentFlag,
    required String reasonForBan,
    String? bannedUntil,
    String? noteForBanMessage,
    String? modNote,
  }) async {
    if (testing) {
      var user = communities
          .firstWhere((community) => community.communityName == communityName)
          .bannedUsers
          .firstWhere((user) => user["username"] == username);
      user["reason_for_ban"] = reasonForBan;
      user["mod_note"] = modNote;
      user["permanent_flag"] = permanentFlag;
      user["banned_until"] = bannedUntil ?? "";
      user["note_for_ban_message"] = noteForBanMessage ?? "";
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance(); //
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/communities/edit-banned-user');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'username': username,
          'newDetails': {
            "reason_for_ban": reasonForBan,
            "mod_note": "User repeatedly violated community rules",
            "permanent_flag": permanentFlag,
            if (bannedUntil != null) "banned_until": bannedUntil,
            if (noteForBanMessage != null)
              "note_for_ban_message": noteForBanMessage,
          },
        }),
      );
    }
  }

  Future<void> unBanUser(String username, String communityName) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
          .bannedUsers
          .removeWhere((user) => user["username"] == username);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/communities/ban-user');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'username': username,
          "action": "unban",
        }),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getMutedUsers(String communityName) async {
    if (testing) {
      List<Map<String, dynamic>> mutedUsers = communities
          .firstWhere((community) => community.communityName == communityName)
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

  Future<void> addMutedUsers(String username, String communityName) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
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
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/communities/mute-user');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'username': username,
          'action': "mute",
        }),
      );
    }
  }

  Future<void> unMuteUser(String username, String communityName) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
          .mutedUsers
          .removeWhere((user) => user["username"] == username);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/communities/mute-user');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'username': username,
          'action': "unmute",
        }),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getModerators(String communityName) async {
    if (testing) {
      List<Map<String, dynamic>> moderators = communities
          .firstWhere((community) => community.communityName == communityName)
          .moderators;
      return moderators;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); //badrr
      final url = Uri.parse(
          'https://redditech.me/backend/communities/about/moderators-sorted/$communityName');

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
      print("badr");
      print(response.body);
      return moderators.reversed.toList(); //badrrr
    }
  }

  Future<void> inviteModerator({
    required String communityName,
    required String username,
    required bool everything,
    required bool manageUsers,
    required bool manageSettings,
    required bool managePostsAndComments,
  }) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
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
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/communities/add-moderator');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'username': username,
          'has_access': {
            "everything": everything,
            "manage_users": manageUsers,
            "manage_settings": manageSettings,
            "manage_posts_and_comments": managePostsAndComments,
          },
        }),
      );
    }
  }

//Rawan: add moderator to the community
  Future<void> addModUser(
      String username, String profilePicture, String communityName) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
          .moderators
          .add({
        "everything": true,
        "manage_users": true,
        "manage_settings": true,
        "manage_posts_and_comments": true,
        "username": username,
        "profile_picture": profilePicture,
        "moderator_since": DateTime.now().toString(),
      });
    } else {
      // todo: add moderator to the community
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   String? token = prefs.getString('token');
      //   final url = Uri.parse(
      //       'https://redditech.me/backend/communities/accept-moderator-invitation');
      //   final response = await http.post(
      //     url,
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Authorization': token!,
      //     },
      //     body: json.encode({"_id": communityId}),
      //   );
      //   print('in addModUser');
      //   print(response.body);
    }
  }

  Future<void> removeAsMod(String username, String communityName) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
          .moderators
          .removeWhere((user) => user["username"] == username);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/communities/remove-moderator');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'community_name': communityName,
          'username': username,
        }),
      );
    }
  }

  Future<String> getMembersCount(String communityName) async {
    if (testing) {
      return communities
          .firstWhere((community) => community.communityName == communityName)
          .communityMembersNo;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/communities/members-count/$communityName');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token!},
      );
      //print(response.body);
      final String membersCount =
          json.decode(response.body)["members_count"].toString();

      return membersCount;
    }
  }

  Future<GeneralSettings> getCommunityGeneralSettings(
      String communityName) async {
    if (testing) {
      return communities
          .firstWhere((community) => community.communityName == communityName)
          .general;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/communities/get-general-settings/$communityName');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token!},
      );
      final Map<String, dynamic> decodedSettings = json.decode(response.body);
      final GeneralSettings generalSettings = GeneralSettings(
        communityID: decodedSettings["_id"],
        communityTitle: decodedSettings["title"],
        communityDescription: decodedSettings["description"],
        communityType: decodedSettings["type"],
        nsfwFlag: decodedSettings["nsfw_flag"],
      );
      return generalSettings;
    }
  }

  Future<Map<String, dynamic>> getPostTypesAndOptions(
      String communityName) async {
    if (testing) {
      var foundCommunity = communities
          .firstWhere((community) => community.communityName == communityName);
      return {
        "postTypes": foundCommunity.postTypes,
        "allowImages": foundCommunity.allowImage,
        "allowPolls": foundCommunity.allowPolls,
        "allowVideo": foundCommunity.allowVideos,
      };
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/communities/get-posts-and-comments/$communityName');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      final Map<String, dynamic> decodedSettings = json.decode(response.body);
      return {
        "postTypes": decodedSettings['posts']["post_type_options"],
        "allowImages": decodedSettings['posts']
            ["allow_image_uploads_and_links_to_image_hosting_sites"],
        "allowPolls": decodedSettings['posts']["allow_polls"],
        "allowVideo": decodedSettings['posts']["allow_videos"],
      };
    }
  }

  Future<void> postGeneralSettings(
      {required GeneralSettings settings,
      required String communityName}) async {
    if (testing) {
      communities
          .firstWhere((community) => community.communityName == communityName)
          .general
          .updateAllGeneralSettings(
              communityID: settings.communityID,
              communityTitle: settings.communityTitle,
              communityDescription: settings.communityDescription,
              communityType: settings.communityType,
              nsfwFlag: settings.nsfwFlag);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/communities/change-general-settings/$communityName');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          "_id": settings.communityID,
          "title": settings.communityTitle,
          "description": settings.communityDescription,
          "type": settings.communityType,
          "nsfw_flag": settings.nsfwFlag,
        }),
      );
    }
  }

  Future<void> setPostTypeAndOptions({
    required bool allowImages,
    required bool allowVideos,
    required bool allowPolls,
    required String communityName,
    required String postTypes,
  }) async {
    if (testing) {
      var community = communities.firstWhere(
        (community) => community.communityName == communityName,
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
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/communities/change-posts-and-comments/$communityName');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode(
          {
            "posts": {
              "post_type_options": postTypes,
              "allow_image_uploads_and_links_to_image_hosting_sites":
                  allowImages,
              "allow_polls": allowPolls,
              "allow_videos": allowVideos,
            }
          },
        ),
      );
    }
  }

  Future<int> createCommunity(
      {required String communityName,
      required bool communityFlag,
      required String communityType}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url =
        Uri.parse('https://redditech.me/backend/communities/add-community');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: json.encode(
        {
          "name": communityName,
          "type": communityType,
          "nsfw_flag": communityFlag,
        },
      ),
    );

    if (response.statusCode == 201) {
      return 200;
    } else {
      return 400;
    }
  }

  Future<Map<String, dynamic>> getCommunityInfo(
      {required String communityName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(
        'https://redditech.me/backend/communities/get-community-view/$communityName');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': token!},
    );
    final Map<String, dynamic> decodedInfo = json.decode(response.body);
    return {
      "communityDescription": decodedInfo["description"],
      "communityTitle": decodedInfo["title"],
      "communityType": decodedInfo["type"],
      "communityFlag": decodedInfo["nsfw_flag"],
      "communityProfilePicture": decodedInfo["profile_picture"],
      "communityBannerPicture": decodedInfo["banner_picture"],
      "communityJoined": decodedInfo["joined_flag"],
    };
  }

  Future<void> addProfilePicture(
      {required String communityName, required String pictureURL}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(
        'https://redditech.me/backend/communities/add-profile-picture');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: json.encode(
        {
          "community_name": communityName,
          "profile_picture": pictureURL,
        },
      ),
    );
  }

  Future<void> addBannerPicture(
      {required String communityName, required String pictureURL}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(
        'https://redditech.me/backend/communities/add-banner-picture');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: json.encode(
        {
          "community_name": communityName,
          "banner_picture": pictureURL,
        },
      ),
    );
  }

  Future<void> deleteProfilePicture({required String communityName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(
        'https://redditech.me/backend/communities/delete-profile-picture');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: json.encode(
        {
          "community_name": communityName,
        },
      ),
    );
  }

  Future<void> deleteBannerPicture({required String communityName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(
        'https://redditech.me/backend/communities/delete-banner-picture');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: json.encode(
        {
          "community_name": communityName,
        },
      ),
    );
  }

  Future<void> joinCommunity({required String communityName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse('https://redditech.me/backend/users/join-community');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: json.encode(
        {
          "community_name": communityName,
        },
      ),
    );
  }

  Future<void> leaveCommunity({required String communityName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse('https://redditech.me/backend/users/leave-community');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: json.encode(
        {
          "community_name": communityName,
        },
      ),
    );
  }

  // Future<List<QueuesPostItem>> getRemovedItems(
  //     {required String communityName,
  //     required String timeFilter,
  //     required String postsOrComments}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   final url = Uri.parse(
  //       'https://redditech.me/backend/communities/about/removed-or-spammed/$communityName?time_filter=$timeFilter&posts_or_comments=$postsOrComments');

  //   final response = await http.get(
  //     url,
  //     headers: {'Content-Type': 'application/json', 'Authorization': token!},
  //   );
  //   final List<Map<String, dynamic>> decodedSettings =
  //       json.decode(response.body);

  //   final List<QueuesPostItem> queuesPostItem = decodedSettings.map((post) {
  //     final List<QueuePostImage> images =
  //         (post["images"] as List<dynamic>).map((image) {
  //       return QueuePostImage(
  //         imagePath: image["path"],
  //         imageCaption: image["caption"],
  //         imageLink: image["link"],
  //       );
  //     }).toList();
  //     return QueuesPostItem(
  //       queuePostImage: images,
  //       moderatorDetails: ModeratorDetails(
  //           approvedFlag: post["moderator_details"]["approved_flag"],
  //           approvedDate: post["moderator_details"]["approved_date"],
  //           removedFlag: post["moderator_details"]["removed_flag"],
  //           removedBy: post["moderator_details"]["removed_by"],
  //           removedDate: post["moderator_details"]["removed_date"],
  //           removedRemovalReason: post["moderator_details"]
  //               ["removed_removal_reason"],
  //           spammedFlag: post["moderator_details"]["spammed_flag"],
  //           spammedBy: post["moderator_details"]["spammed_by"],
  //           spammedType: post["moderator_details"]["spammed_type"],
  //           spammedRemovalReason: post["moderator_details"]
  //               ["spammed_removal_reason"],
  //           reportedFlag: post["moderator_details"]["reported_flag"],
  //           reportedBy: post["moderator_details"]["reported_by"],
  //           reportedType: post["moderator_details"]["reported_type"]),
  //       postTitle: post["title"],
  //       postDescription: post["description"],
  //       createdAt: post["created_at"],
  //       editedAt: post["edited_at"],
  //       deletedAt: post["deleted_at"],
  //       isDeleted: post["deleted"],
  //       username: post["username"],
  //       communityName: post["community_name"],
  //       nsfwFlag: post["nsfw_flag"],
  //       spoilerFlag: post["spoiler_flag"],
  //     );
  //   }).toList();
  //   print(queuesPostItem);
  //   return queuesPostItem;
  // }

  // Future<List<QueuesPostItem>> getReportedItems(
  //     {required String communityName,
  //     required timeFilter,
  //     required postsOrComments}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   final url = Uri.parse(
  //       'https://redditech.me/backend/communities/about/reported/$communityName?time_filter=$timeFilter&posts_or_comments=$postsOrComments');

  //   final response = await http.get(
  //     url,
  //     headers: {'Content-Type': 'application/json', 'Authorization': token!},
  //   );
  //   final List<Map<String, dynamic>> decodedSettings =
  //       json.decode(response.body);
  //   final List<QueuesPostItem> queuesPostItem = decodedSettings.map((post) {
  //     final List<QueuePostImage> images =
  //         (post["images"] as List<dynamic>).map((image) {
  //       return QueuePostImage(
  //         imagePath: image["path"],
  //         imageCaption: image["caption"],
  //         imageLink: image["link"],
  //       );
  //     }).toList();
  //     return QueuesPostItem(
  //       queuePostImage: images,
  //       moderatorDetails: ModeratorDetails(
  //           approvedFlag: post["moderator_details"]["approved_flag"],
  //           approvedDate: post["moderator_details"]["approved_date"],
  //           removedFlag: post["moderator_details"]["removed_flag"],
  //           removedBy: post["moderator_details"]["removed_by"],
  //           removedDate: post["moderator_details"]["removed_date"],
  //           removedRemovalReason: post["moderator_details"]
  //               ["removed_removal_reason"],
  //           spammedFlag: post["moderator_details"]["spammed_flag"],
  //           spammedBy: post["moderator_details"]["spammed_by"],
  //           spammedType: post["moderator_details"]["spammed_type"],
  //           spammedRemovalReason: post["moderator_details"]
  //               ["spammed_removal_reason"],
  //           reportedFlag: post["moderator_details"]["reported_flag"],
  //           reportedBy: post["moderator_details"]["reported_by"],
  //           reportedType: post["moderator_details"]["reported_type"]),
  //       postTitle: post["title"],
  //       postDescription: post["description"],
  //       createdAt: post["created_at"],
  //       editedAt: post["edited_at"],
  //       deletedAt: post["deleted_at"],
  //       isDeleted: post["deleted"],
  //       username: post["username"],
  //       communityName: post["community_name"],
  //       nsfwFlag: post["nsfw_flag"],
  //       spoilerFlag: post["spoiler_flag"],
  //     );
  //   }).toList();
  //   return queuesPostItem;
  // }

  Future<List<QueuesPostItem>> getUnmoderatedItems(
      {required String communityName,
      required String timeFilter,
      required String postsOrComments}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(
        'https://redditech.me/backend/communities/about/unmoderated/$communityName?time_filter=$timeFilter&posts_or_comments=$postsOrComments');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': token!},
    );

    final List<dynamic> decodedSettings = json.decode(response.body);
    try {
      final List<QueuesPostItem> queuesPostItem = decodedSettings.map((post) {
        print('Bashoof el runtypes');
        print('post: $post, type: ${post.runtimeType}');
        print(
            'post["images"]: ${post["images"]}, type: ${post["images"].runtimeType}');
        print(
            'post["images"]["path"]: ${post["images"]["path"]}, type: ${post["images"]["path"].runtimeType}');
        print(
            'post["moderator_details"]: ${post["moderator_details"]}, type: ${post["moderator_details"].runtimeType}');
        print(
            'post["moderator_details"]["approved_flag"]: ${post["moderator_details"]["approved_flag"]}, type: ${post["moderator_details"]["approved_flag"].runtimeType}');
        print(
            'post["title"]: ${post["title"]}, type: ${post["title"].runtimeType}');
        print(
            'post["description"]: ${post["description"]}, type: ${post["description"].runtimeType}');
        print(
            'post["created_at"]: ${post["created_at"]}, type: ${post["created_at"].runtimeType}');
        print(
            'post["edited_at"]: ${post["edited_at"]}, type: ${post["edited_at"].runtimeType}');
        print(
            'post["deleted_at"]: ${post["deleted_at"]}, type: ${post["deleted_at"].runtimeType}');
        print(
            'post["deleted"]: ${post["deleted"]}, type: ${post["deleted"].runtimeType}');
        print(
            'post["username"]: ${post["username"]}, type: ${post["username"].runtimeType}');
        print(
            'post["community_name"]: ${post["community_name"]}, type: ${post["community_name"].runtimeType}');
        print(
            'post["nsfw_flag"]: ${post["nsfw_flag"]}, type: ${post["nsfw_flag"].runtimeType}');
        print(
            'post["spoiler_flag"]: ${post["spoiler_flag"]}, type: ${post["spoiler_flag"].runtimeType}');
        print(
            'post["profile_picture"]: ${post["profile_picture"]}, type: ${post["profile_picture"].runtimeType}');
        print(
            'post["total_views"]: ${post["total_views"]}, type: ${post["total_views"].runtimeType}');
        print(
            'post["upvote_rate"]: ${post["upvote_rate"]}, type: ${post["upvote_rate"].runtimeType}');
        print(
            'post["total_shares"]: ${post["total_shares"]}, type: ${post["total_shares"].runtimeType}');
        print(
            'post["comments_count"]: ${post["comments_count"]}, type: ${post["comments_count"].runtimeType}');
        print(
            'post["views_count"]: ${post["views_count"]}, type: ${post["views_count"].runtimeType}');
        print(
            'post["shares_count"]: ${post["shares_count"]}, type: ${post["shares_count"].runtimeType}');
        print(
            'post["upvotes_count"]: ${post["upvotes_count"]}, type: ${post["upvotes_count"].runtimeType}');
        print(
            'post["downvotes_count"]: ${post["downvotes_count"]}, type: ${post["downvotes_count"].runtimeType}');
        print(
            'post["oc_flag"]: ${post["oc_flag"]}, type: ${post["oc_flag"].runtimeType}');
        print(
            'post["locked_flag"]: ${post["locked_flag"]}, type: ${post["locked_flag"].runtimeType}');
        print(
            'post["allowreplies_flag"]: ${post["allowreplies_flag"]}, type: ${post["allowreplies_flag"].runtimeType}');
        print(
            'post["set_suggested_sort"]: ${post["set_suggested_sort"]}, type: ${post["set_suggested_sort"].runtimeType}');
        print(
            'post["scheduled_flag"]: ${post["scheduled_flag"]}, type: ${post["scheduled_flag"].runtimeType}');
        print(
            'post["is_reposted_flag"]: ${post["is_reposted_flag"]}, type: ${post["is_reposted_flag"].runtimeType}');
        print('post["__v"]: ${post["__v"]}, type: ${post["__v"].runtimeType}');
        print('bengarab el donya');
        print('post["images"]: ${post["images"]}');
        final List<dynamic> images = post["images"].isEmpty
            ? []
            : post["images"].map((image) {
                print('image type: ${image.runtimeType}');
                return QueuePostImage(
                  imagePath: image["path"],
                  imageCaption: image["caption"],
                  imageLink: image["link"],
                );
              }).toList();
        return QueuesPostItem(
          queuePostImage: images,
          moderatorDetails: ModeratorDetails(
              approvedFlag: post["moderator_details"]["approved_flag"],
              approvedDate: post["moderator_details"]["approved_date"],
              removedFlag: post["moderator_details"]["removed_flag"],
              removedBy: post["moderator_details"]["removed_by"],
              removedDate: post["moderator_details"]["removed_date"],
              removedRemovalReason: post["moderator_details"]
                  ["removed_removal_reason"],
              spammedFlag: post["moderator_details"]["spammed_flag"],
              spammedBy: post["moderator_details"]["spammed_by"],
              spammedType: post["moderator_details"]["spammed_type"],
              spammedRemovalReason: post["moderator_details"]
                  ["spammed_removal_reason"],
              reportedFlag: post["moderator_details"]["reported_flag"],
              reportedBy: post["moderator_details"]["reported_by"],
              reportedType: post["moderator_details"]["reported_type"]),
          postTitle: post["title"],
          postDescription: post["description"],
          createdAt: post["created_at"],
          editedAt: post["edited_at"],
          deletedAt: post["deleted_at"],
          isDeleted: post["deleted"],
          username: post["username"],
          communityName: post["community_name"],
          nsfwFlag: post["nsfw_flag"],
          spoilerFlag: post["spoiler_flag"],
        );
      }).toList();
      print('Bashoof el donya ba3d ghabay');
      print(queuesPostItem);
      return queuesPostItem;
    } catch (e) {
      print('Error occurred while decoding: $e');
      return [];
    }
  }
}
