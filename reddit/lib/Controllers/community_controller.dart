import 'package:get_it/get_it.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Services/community_service.dart';

class CommunityController {
  final communityService = GetIt.instance.get<CommunityService>();

  CommunityItem? communityItem;

  void getCommunity(String communityName) async {
    communityItem = communityService.getCommunityData(communityName);
  }
}
