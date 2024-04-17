import 'package:reddit/Models/community_item.dart';
import 'package:reddit/test_files/test_posts_mohy.dart';
import 'package:reddit/widgets/post.dart';
import '../test_files/test_communities.dart';

class CommunityService {
bool testing = true;

  CommunityItem? getCommunityData(String communityName) {
    for (var community in communities) {
      if (community.general.communityName == communityName) {
        return community;
      }
    }
    return null;
  }

  List<String> getCommunityNames() {
    List<String> communityNames = [];
    for (var community in communities) {
      communityNames.add(community.general.communityName);
    }
    return communityNames;
  }

  List<Post> getCommunityPosts(String communityName) {
    List<Post> communityPosts = [];
    for (var post in testPosts) {
      communityPosts.add(post);
    }
      return communityPosts;
  }
}
