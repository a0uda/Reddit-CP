import 'package:get_it/get_it.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/Services/moderator_service.dart';

class ModeratorController {
  final moderatorService = GetIt.instance.get<ModeratorMockService>();

  List<Map<String, dynamic>> approvedUsers = [];
  List<Map<String, dynamic>> bannedUsers = [];
  List<Map<String, dynamic>> mutedUsers = [];
  List<Map<String, dynamic>> moderators = [];
  List<RulesItem> rules = [];
  GeneralSettings? generalSettings;
  Map<String, dynamic> postTypesAndOptions = {};

  void getCommunity(String communityName) {
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

}
