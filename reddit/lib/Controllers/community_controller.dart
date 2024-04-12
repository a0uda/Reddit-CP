import 'package:get_it/get_it.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Services/community_service.dart';
import 'package:reddit/widgets/post.dart';

class CommunityController {
  final communityService = GetIt.instance.get<CommunityService>();

  CommunityItem? communityItem;
  List<Post>? communityList;

  void getCommunity(String communityName) async {
    communityItem = communityService.getCommunityData(communityName); 
  }

  void getCommunityPost(String communityName) async {
    communityList = communityService.getCommunityPosts(communityName);
  }
}
