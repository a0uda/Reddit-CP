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
  GeneralSettings? generalSettings;
  Map<String, dynamic> postTypesAndOptions = {};
  CommunityItem? communityItem;

  void getCommunity(String communityName) {
    this.communityName = communityName;
    approvedUsers = moderatorService.getApprovedUsers(communityName);
    bannedUsers = moderatorService.getBannedUsers(communityName);
    mutedUsers = moderatorService.getMutedUsers(communityName);
    moderators = moderatorService.getModerators(communityName);
    rules = moderatorService.getRules(communityName);
    generalSettings =
        moderatorService.getCommunityGeneralSettings(communityName);
    postTypesAndOptions =
        moderatorService.getPostTypesAndOptions(communityName);
  }

  GeneralSettings getGeneralSettings(String communityName) {
    return moderatorService.getCommunityGeneralSettings(communityName);
  }
}

class ApprovedUserProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  void addApprovedUsers(String username, String communityName) {
    moderatorService.addApprovedUsers(username, communityName);
    moderatorController.approvedUsers =
        moderatorService.getApprovedUsers(communityName);
    notifyListeners();
  }

  void removeApprovedUsers(String username, String communityName) {
    moderatorService.removeApprovedUsers(username, communityName);
    moderatorController.approvedUsers =
        moderatorService.getApprovedUsers(communityName);
    notifyListeners();
  }
}

class BannedUserProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  void addBannedUsers({
    required String username,
    required String communityName,
    required bool permanentFlag,
    required String reasonForBan,
    String? bannedUntil,
    String? noteForBanMessage,
    String? modNote,
  }) {
    moderatorService.addBannedUsers(
      username: username,
      communityName: communityName,
      permanentFlag: permanentFlag,
      reasonForBan: reasonForBan,
      bannedUntil: bannedUntil,
      noteForBanMessage: noteForBanMessage,
      modNote: modNote,
    );
    moderatorController.bannedUsers =
        moderatorService.getBannedUsers(communityName);
    notifyListeners();
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
    moderatorService.updateBannedUser(
      username: username,
      communityName: communityName,
      permanentFlag: permanentFlag,
      reasonForBan: reasonForBan,
      bannedUntil: bannedUntil ?? "",
      modNote: modNote ?? "",
      noteForBanMessage: noteForBanMessage ?? "",
    );
    moderatorController.bannedUsers =
        moderatorService.getBannedUsers(communityName);
    notifyListeners();
  }

  void unBanUsers(String username, String communityName) {
    moderatorService.unBanUser(username, communityName);
    moderatorController.bannedUsers =
        moderatorService.getBannedUsers(communityName);
    notifyListeners();
  }
}

class MutedUserProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  void addMutedUsers(String username, String communityName) {
    moderatorService.addMutedUsers(username, communityName);
    moderatorController.mutedUsers =
        moderatorService.getMutedUsers(communityName);
    notifyListeners();
  }

  void unMuteUser(String username, String communityName) {
    moderatorService.unMuteUser(username, communityName);
    moderatorController.mutedUsers =
        moderatorService.getMutedUsers(communityName);
    notifyListeners();
  }
}

class ModeratorProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  void inviteModerator({
    required String communityName,
    required String username,
    required bool everything,
    required bool manageUsers,
    required bool manageSettings,
    required bool managePostsAndComments,
  }) {
    moderatorService.inviteModerator(
        communityName: communityName,
        username: username,
        everything: everything,
        manageUsers: manageUsers,
        manageSettings: manageSettings,
        managePostsAndComments: managePostsAndComments);
    moderatorController.moderators =
        moderatorService.getModerators(communityName);
    notifyListeners();
  }

  void removeAsMod(String username, String communityName) {
    moderatorService.removeAsMod(username, communityName);
    moderatorController.moderators =
        moderatorService.getModerators(communityName);
    notifyListeners();
  }
}

class RulesProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  void createRules(
      {required String id,
      required String communityName,
      required String ruleTitle,
      required String appliesTo,
      String? reportReason,
      String? ruleDescription}) {
    moderatorService.createRules(
        id: id,
        communityName: communityName,
        ruleTitle: ruleTitle,
        appliesTo: appliesTo,
        reportReason: reportReason ?? "",
        ruleDescription: ruleDescription ?? "");
    moderatorController.rules = moderatorService.getRules(communityName);
    notifyListeners();
  }

  void deleteRule(String communityName, String id) {
    moderatorService.deleteRule(communityName, id);
    moderatorController.rules = moderatorService.getRules(communityName);
    notifyListeners();
  }

  void editRules(
      {required String id,
      required String communityName,
      required String ruleTitle,
      required String appliesTo,
      String? reportReason,
      String? ruleDescription}) {
    moderatorService.editRules(
      id: id,
      communityName: communityName,
      ruleTitle: ruleTitle,
      appliesTo: appliesTo,
      reportReason: reportReason ?? "",
      ruleDescription: ruleDescription ?? "",
    );
    moderatorController.rules = moderatorService.getRules(communityName);
    notifyListeners();
  }
}

class ChangeGeneralSettingsProvider extends ChangeNotifier {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  void setGeneralSettings(
      {required String communityName, required GeneralSettings general}) {
    moderatorService.postGeneralSettings(
        communityName: communityName,
        settings: GeneralSettings(
            communityID: general.communityID,
            communityName: general.communityName,
            communityDescription: general.communityDescription,
            communityType: general.communityType,
            nsfwFlag: general.nsfwFlag));
    moderatorController.generalSettings =
        moderatorService.getCommunityGeneralSettings(general.communityName);
    moderatorController.communityName = general.communityName;

    notifyListeners();
  }
}
