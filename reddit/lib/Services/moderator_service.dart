import 'package:reddit/test_files/test_posts_mohy.dart';
import 'package:reddit/widgets/post.dart';

class ModeratorService {
  bool testing = const bool.fromEnvironment('testing');

  List<Post> getCommunityPosts(String communityName) {
    List<Post> communityPosts = [];
    for (var post in testPosts) {
      communityPosts.add(post);
    }
      return communityPosts;
  }
}
