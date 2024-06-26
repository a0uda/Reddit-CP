import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/moderator_item.dart';
import 'package:reddit/Models/removal.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/Services/moderator_service.dart';

class ModeratorController {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();

  String communityName = "";
  ModeratorItem modAccess = ModeratorItem(
      everything: false,
      managePostsAndComments: false,
      manageSettings: false,
      manageUsers: false,
      username: "");
  List<Map<String, dynamic>> approvedUsers = [];
  List<Map<String, dynamic>> bannedUsers = [];
  List<Map<String, dynamic>> mutedUsers = [];
  List<Map<String, dynamic>> moderators = [];
  List<Map<String, dynamic>> scheduled = [];
  List<RulesItem> rules = [];
  List<RemovalItem> removalReasons = [];
  GeneralSettings generalSettings = GeneralSettings(
    communityID: "",
    communityTitle: "",
    communityDescription: "",
    communityType: "Public",
    nsfwFlag: false,
  );
  bool joinedFlag = false;
  List<bool> isPostInCommunity = [];
  String membersCount = "0";
  Map<String, dynamic> postTypesAndOptions = {};
  String profilePictureURL = "images/logo-mobile.png";
  String bannerPictureURL = "images/reddit-banner-image.jpg";
  List<QueuesPostItem> queuePosts = [];

  CommunityItem? communityItem;

  Future<void> getCommunityInfo(String communityName) async {
    Map<String, dynamic> info =
        await moderatorService.getCommunityInfo(communityName: communityName);
    generalSettings.communityTitle = info["communityTitle"];
    generalSettings.communityDescription = info["communityDescription"];
    generalSettings.communityType = info["communityType"];
    generalSettings.nsfwFlag = info["communityFlag"];
    profilePictureURL = info["communityProfilePicture"];
    bannerPictureURL = info["communityBannerPicture"];
    joinedFlag = info["communityJoined"];
  }

  Future<void> getBannedUsers(String communityName) async {
    bannedUsers = await moderatorService.getBannedUsers(communityName);
  }

  Future<void> getGeneralSettings(String communityName) async {
    generalSettings =
        await moderatorService.getCommunityGeneralSettings(communityName);
  }

  Future<void> getPostTypesAndOptions(String communityName) async {
    postTypesAndOptions =
        await moderatorService.getPostTypesAndOptions(communityName);
  }

  Future<void> getApprovedUser(String communityName) async {
    approvedUsers = await moderatorService.getApprovedUsers(communityName);
  }

  Future<void> getMutedUsers(String communityName) async {
    mutedUsers = await moderatorService.getMutedUsers(communityName);
  }

  Future<void> getScheduled(String communityName) async {
    scheduled = await moderatorService.getScheduled(communityName);
  }

  Future<void> getModerators(String communityName) async {
    moderators = await moderatorService.getModerators(communityName);
  }

  Future<void> getRules(String communityName) async {
    rules = await moderatorService.getRules(communityName);
  }

  Future<void> getRemoval(String communityName) async {
    print("here");
    removalReasons = await moderatorService.getRemovalReason(communityName);
  }

  Future<void> getMembersCount(String communityName) async {
    membersCount = await moderatorService.getMembersCount(communityName);
  }

//Rawan: add moderator
  Future<void> addAsMod(String username, String profilePicture,
      String communityName, String msgId) async {
    await moderatorService.addModUser(
        username, profilePicture, communityName, msgId);
    moderators = await moderatorService.getModerators(communityName);
  }

  Future<void> getQueueItems(
      {required String communityName,
      required String timeFilter,
      required String postsOrComments,
      required String queueType}) async {
    print('Ana fel controller fel unmoderated');
    queuePosts = await moderatorService.getQueueItems(
        communityName: communityName,
        timeFilter: timeFilter,
        postsOrComments: postsOrComments,
        queueType: queueType);
    print('Mohy beyshoof el unmoderated fel controller');
    print(queuePosts);
  }
}

class ApprovedUserProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> addApprovedUsers(String username, String communityName) async {
    await moderatorService.addApprovedUsers(username, communityName);
    moderatorController.approvedUsers =
        await moderatorService.getApprovedUsers(communityName);
    notifyListeners();
  }

  Future<void> removeApprovedUsers(
      String username, String communityName) async {
    await moderatorService.removeApprovedUsers(username, communityName);
    moderatorController.approvedUsers =
        await moderatorService.getApprovedUsers(communityName);
    notifyListeners();
  }

  Future<void> getApprovedUsers(String communityName) async {
    moderatorController.approvedUsers =
        await moderatorService.getApprovedUsers(communityName);
    notifyListeners();
  }
}

class BannedUserProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> addBannedUsers({
    required String username,
    required String communityName,
    required bool permanentFlag,
    required String reasonForBan,
    String? bannedUntil,
    String? noteForBanMessage,
    String? modNote,
  }) async {
    await moderatorService.addBannedUsers(
      username: username,
      communityName: communityName,
      permanentFlag: permanentFlag,
      reasonForBan: reasonForBan,
      bannedUntil: bannedUntil,
      noteForBanMessage: noteForBanMessage,
      modNote: modNote,
    );
    moderatorController.bannedUsers =
        await moderatorService.getBannedUsers(communityName);
    notifyListeners();
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
    await moderatorService.updateBannedUser(
      username: username,
      communityName: communityName,
      permanentFlag: permanentFlag,
      reasonForBan: reasonForBan,
      bannedUntil: bannedUntil ?? "",
      modNote: modNote ?? "",
      noteForBanMessage: noteForBanMessage ?? "",
    );
    moderatorController.bannedUsers =
        await moderatorService.getBannedUsers(communityName);
    notifyListeners();
  }

  Future<void> unBanUsers(String username, String communityName) async {
    await moderatorService.unBanUser(username, communityName);
    moderatorController.bannedUsers =
        await moderatorService.getBannedUsers(communityName);
    notifyListeners();
  }

  Future<void> getBannedUsers(String communityName) async {
    moderatorController.bannedUsers =
        await moderatorService.getBannedUsers(communityName);
    notifyListeners();
  }
}

class MutedUserProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> addMutedUsers(String username, String communityName) async {
    await moderatorService.addMutedUsers(username, communityName);
    moderatorController.mutedUsers =
        await moderatorService.getMutedUsers(communityName);
    notifyListeners();
  }

  Future<void> unMuteUser(String username, String communityName) async {
    await moderatorService.unMuteUser(username, communityName);
    moderatorController.mutedUsers =
        await moderatorService.getMutedUsers(communityName);
    notifyListeners();
  }
}

class ScheduledProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> getScheduled(String communityName) async {
    moderatorController.scheduled =
        await moderatorService.getScheduled(communityName);
    notifyListeners();
  }

  Future<void> EditScheduledPost(
      String communityName, String post_id, String description) async {
    await moderatorService.EditScheduledPost(
        postId: post_id,
        description: description,
        communityName: communityName);
    moderatorController.scheduled =
        await moderatorService.getScheduled(communityName);
    notifyListeners();
  }

  Future<void> submitScheduledPost(String communityName, String post_id) async {
    await moderatorService.submitScheduledPost(
        postId: post_id, communityName: communityName);
    // moderatorController.scheduled =
    //     await moderatorService.getScheduled(communityName);
    notifyListeners();
  }

  Future<void> cancelScheduledPost(String communityName, String post_id) async {
    await moderatorService.cancelScheduledPost(
        postId: post_id, communityName: communityName);
    // moderatorController.scheduled =
    //     await moderatorService.getScheduled(communityName);
    notifyListeners();
  }
}

class ModeratorProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> inviteModerator({
    required String communityName,
    required String username,
    required bool everything,
    required bool manageUsers,
    required bool manageSettings,
    required bool managePostsAndComments,
  }) async {
    await moderatorService.inviteModerator(
        communityName: communityName,
        username: username,
        everything: everything,
        manageUsers: manageUsers,
        manageSettings: manageSettings,
        managePostsAndComments: managePostsAndComments);
    moderatorController.moderators =
        await moderatorService.getModerators(communityName);
    notifyListeners();
  }

  Future<void> removeAsMod(String username, String communityName) async {
    await moderatorService.removeAsMod(username, communityName);
    moderatorController.moderators =
        await moderatorService.getModerators(communityName);
    notifyListeners();
  }

  Future<void> getModAccess(String username, String communityName) async {
    moderatorController.moderators =
        await moderatorService.getModerators(communityName);
    moderatorController.modAccess = ModeratorItem.fromJson(moderatorController
        .moderators
        .firstWhere((mod) => mod["username"] == username));
    print("YARAABBBB");
    print(moderatorController.modAccess.managePostsAndComments);
    // print("badr test access");
    // print(moderatorController.modAccess.everything);
  }
}

class RulesProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> createRule(
      {String? id,
      required String communityName,
      required String ruleTitle,
      required String appliesTo,
      String? reportReason,
      String? ruleDescription}) async {
    await moderatorService.createRule(
        id: id,
        communityName: communityName,
        ruleTitle: ruleTitle,
        appliesTo: appliesTo,
        reportReason: reportReason ?? "",
        ruleDescription: ruleDescription ?? "");
    moderatorController.rules = await moderatorService.getRules(communityName);
    notifyListeners();
  }

  Future<void> deleteRule(String communityName, String id) async {
    await moderatorService.deleteRule(communityName, id);
    moderatorController.rules = await moderatorService.getRules(communityName);
    notifyListeners();
  }

  Future<void> editRules(
      {required String id,
      required String communityName,
      required String ruleTitle,
      required String appliesTo,
      String? reportReason,
      String? ruleDescription}) async {
    await moderatorService.editRules(
      id: id,
      communityName: communityName,
      ruleTitle: ruleTitle,
      appliesTo: appliesTo,
      reportReason: reportReason ?? "",
      ruleDescription: ruleDescription ?? "",
    );
    moderatorController.rules = await moderatorService.getRules(communityName);
  }
}

class RemovalProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> createRemoval({
    required String communityName,
    required String title,
    required String removalReason,
  }) async {
    await moderatorService.createRemovalReason(
      title: title,
      communityName: communityName,
      removalReason: removalReason,
    );
    moderatorController.removalReasons =
        await moderatorService.getRemovalReason(communityName);
    notifyListeners();
  }

  Future<void> deleteRemovalReason(String communityName, String id) async {
    await moderatorService.deleteRemovalReason(communityName, id);
    moderatorController.removalReasons =
        await moderatorService.getRemovalReason(communityName);
    notifyListeners();
  }

  Future<void> editRemovalReason(
      {required String id,
      required String communityName,
      required String title,
      required String reason}) async {
    await moderatorService.editRemoval(
      id: id,
      communityName: communityName,
      title: title,
      reason: reason,
    );
    moderatorController.removalReasons =
        await moderatorService.getRemovalReason(communityName);
    notifyListeners();
  }
}

class ChangeGeneralSettingsProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> setGeneralSettings(
      {required String communityName, required GeneralSettings general}) async {
    await moderatorService.postGeneralSettings(
        communityName: communityName,
        settings: GeneralSettings(
            communityID: general.communityID,
            communityTitle: general.communityTitle,
            communityDescription: general.communityDescription,
            communityType: general.communityType,
            nsfwFlag: general.nsfwFlag));
    moderatorController.generalSettings =
        await moderatorService.getCommunityGeneralSettings(communityName);
    notifyListeners();
  }
}

class PostSettingsProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> setCommunityPostSetting(
      {required String communityName,
      required bool allowImages,
      required bool allowPolls,
      required bool allowVideo,
      required String postTypes}) async {
    await moderatorService.setPostTypeAndOptions(
      communityName: communityName,
      allowImages: allowImages,
      allowPolls: allowPolls,
      allowVideos: allowVideo,
      postTypes: postTypes,
    );
    moderatorController.postTypesAndOptions =
        await moderatorService.getPostTypesAndOptions(communityName);
    notifyListeners();
  }
}

class CreateCommunityProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<int> createCommuntiy(
      {required String communityName,
      required String communityType,
      required bool communityFlag}) async {
    int validation = await moderatorService.createCommunity(
        communityName: communityName,
        communityType: communityType,
        communityFlag: communityFlag);

    notifyListeners();
    //print(validation);
    return validation;
  }
}

class UpdateProfilePicture extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> updateProfilePicture(
      {required String communityName, required String pictureUrl}) async {
    await moderatorService.addProfilePicture(
        communityName: communityName, pictureURL: pictureUrl);
    moderatorController.profilePictureURL = pictureUrl;
    notifyListeners();
  }

  Future<void> updateBannerPicture(
      {required String communityName, required String pictureUrl}) async {
    await moderatorService.addBannerPicture(
        communityName: communityName, pictureURL: pictureUrl);
    moderatorController.bannerPictureURL = pictureUrl;
    notifyListeners();
  }
}

class IsJoinedProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> joinCommunity(
      {required String communityName, required bool isJoined}) async {
    await moderatorService.joinCommunity(
      communityName: communityName,
    );
    moderatorController.joinedFlag = isJoined;
    notifyListeners();
  }

  Future<void> leaveCommunity(
      {required String communityName, required bool isJoined}) async {
    await moderatorService.leaveCommunity(communityName: communityName);
    moderatorController.joinedFlag = isJoined;
    notifyListeners();
  }
}

class handleObjectionProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> handleObjection({
    required String objectionType,
    required String itemType,
    required String action,
    required String communityName,
    required String itemID,
  }) async {
    print('Ana ba test el handle objection approve w remove fel provider');
    print(itemID);
    print(itemType);
    await moderatorService.handleObjection(
      communityName: communityName,
      objectionType: objectionType,
      itemType: itemType,
      action: action,
      itemID: itemID,
    );
    notifyListeners();
  }

  Future<void> objectItem(
      {required String id,
      required String itemType,
      required String objectionType,
      required String communityName}) async {
    if (testing) {
    } else {
      await moderatorService.objectItem(
          id: id,
          itemType: itemType,
          objectionType: objectionType,
          communityName: communityName);
      notifyListeners();
    }
  }
}

class handleUnmoderatedProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> handleUnmoderated({
    required String objectionType,
    required String itemType,
    required String action,
    required String communityName,
    required String itemID,
  }) async {
    print('Ana ba test el unmoderated approve w remove fel provider');

    await moderatorService.handleUnmoderatedItem(
      communityName: communityName,
      objectionType: objectionType,
      itemType: itemType,
      action: action,
      itemID: itemID,
    );
    notifyListeners();
  }
}

class handleEditItemProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> handleEditItem({
    required String itemType,
    required String action,
    required String communityName,
    required String itemID,
  }) async {
    print('Ana ba test el unmoderated approve w remove fel provider');

    await moderatorService.handleEditItem(
      communityName: communityName,
      itemType: itemType,
      action: action,
      itemID: itemID,
    );
    notifyListeners();
  }
}
