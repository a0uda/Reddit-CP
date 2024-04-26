import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/Services/moderator_service.dart';

class ModeratorController {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();

  String communityName = "";
  List<Map<String, dynamic>> approvedUsers = [];
  List<Map<String, dynamic>> bannedUsers = [];
  List<Map<String, dynamic>> mutedUsers = [];
  List<Map<String, dynamic>> moderators = [];
  List<RulesItem> rules = [];
  GeneralSettings generalSettings = GeneralSettings(
    communityID: "",
    communityName: "",
    communityDescription: "",
    communityType: "Public",
    nsfwFlag: false,
  );
  Map<String, dynamic> postTypesAndOptions = {};
  CommunityItem? communityItem;

  Future<void> getCommunity(String communityName) async {
    this.communityName = communityName;
    approvedUsers = await moderatorService.getApprovedUsers(communityName);
    bannedUsers = await moderatorService.getBannedUsers(communityName);
    mutedUsers = await moderatorService.getMutedUsers(communityName);
    moderators = await moderatorService.getModerators(communityName);
    rules = await moderatorService.getRules(communityName);
    generalSettings =
        await moderatorService.getCommunityGeneralSettings(communityName);
    postTypesAndOptions = moderatorService.getPostTypesAndOptions(communityName)
        as Map<String, dynamic>;
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

  Future<void> getModerators(String communityName) async {
    moderators = await moderatorService.getModerators(communityName);
  }

  Future<void> getRules(String communityName) async {
    rules = await moderatorService.getRules(communityName);
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
    moderatorService.removeApprovedUsers(username, communityName);
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
    moderatorService.removeAsMod(username, communityName);
    moderatorController.moderators =
        await moderatorService.getModerators(communityName);
    notifyListeners();
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
    notifyListeners();
  }
}

class ChangeGeneralSettingsProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> setGeneralSettings(
      {required String communityName, required GeneralSettings general}) async {
    moderatorService.postGeneralSettings(
        communityName: communityName,
        settings: GeneralSettings(
            communityID: general.communityID,
            communityName: general.communityName,
            communityDescription: general.communityDescription,
            communityType: general.communityType,
            nsfwFlag: general.nsfwFlag));
    moderatorController.generalSettings = await moderatorService
        .getCommunityGeneralSettings(general.communityName);
    moderatorController.communityName = general.communityName;
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
    moderatorService.setPostTypeAndOptions(
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
