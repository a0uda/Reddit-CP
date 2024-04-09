import 'package:reddit/Models/comments.dart';
import 'package:reddit/test_files/test_comments.dart';

bool testing = true;

class CommentsService {
  Comments getCommentsByPostId(String id) {
    if (testing) {
      return comments.firstWhere((element) => element.postId == id);
    } else {
      //fetch from database
    }
    return Comments();
  }
}
