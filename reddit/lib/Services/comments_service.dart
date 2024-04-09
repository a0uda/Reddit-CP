import 'package:reddit/Models/comments.dart';
import 'package:reddit/test_files/test_comments.dart';

class CommentsService {
  bool testing = true;
  Future<List<Comments>> getCommentByPostId(String postId) async {
    List<Comments> commentsList = [];
    for (var comment in comments) {
      if (comment.postId == postId) {
        commentsList.add(comment);
      }
    }
    return commentsList;
  }
}
