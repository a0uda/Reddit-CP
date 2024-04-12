import 'package:reddit/Models/community_item.dart';
import '../test_files/test_communities.dart';

class CommunityService {
  bool testing = true;

  CommunityItem? getCommunityData(String communityName) {
    for (var community in communities) {
      if (community.communityName == communityName) {
        return community;
      }
    }
    return null;
  }

  List<String> getCommunityNames() {
    List<String> communityNames = [];
    for (var community in communities) {
      communityNames.add(community.communityName);
    }
    return communityNames;
  }
}
