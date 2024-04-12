import 'package:reddit/test_files/test_posts_mohy.dart';
import 'package:reddit/widgets/post.dart';

class ModeratorService {
  bool testing = true;

  List<Post> getCommunityPosts(String communityName) {
    List<Post> communityPosts = [];
    for (var post in postsMohy) {
      communityPosts.add(post);
    }
      return communityPosts;
  }
}
