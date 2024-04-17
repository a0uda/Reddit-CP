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

  void addApprovedUsers(String username, String communityName) {
    moderatorService.addApprovedUsers(username, communityName);
    approvedUsers = moderatorService.getApprovedUsers(communityName);
  }

  void removeApprovedUsers(String username, String communityName) {
    moderatorService.removeApprovedUsers(username, communityName);
    approvedUsers = moderatorService.getApprovedUsers(communityName);
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
    moderatorService.addBannedUsers(
      username: username,
      communityName: communityName,
      permanentFlag: permanentFlag,
      reasonForBan: reasonForBan,
      bannedUntil: bannedUntil,
      noteForBanMessage: noteForBanMessage,
      modNote: modNote,
    );
    bannedUsers = moderatorService.getBannedUsers(communityName);
  }

  void addMutedUsers(String username, String communityName) {
    moderatorService.addMutedUsers(username, communityName);
    mutedUsers = moderatorService.getMutedUsers(communityName);
  }

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
    moderators = moderatorService.getModerators(communityName);
  }

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
    rules = moderatorService.getRules(communityName);
  }

  void deleteRule(String communityName, String id) {
    moderatorService.deleteRule(communityName, id);
    rules = moderatorService.getRules(communityName);
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
    rules = moderatorService.getRules(communityName);
  }
}
