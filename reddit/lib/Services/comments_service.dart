import 'package:reddit/Models/comments.dart';
import 'package:reddit/test_files/test_comments.dart';

bool testing = true;

class CommentsService {
  Future<List<Comments>> getCommentByPostId(String postId) async {
    List<Comments> commentsList = [];
    for (var comment in comments) {
      if (comment.postId == postId) {
        commentsList.add(comment);
      }
    }

    void upVoteComment(String commentId) {}
    return commentsList;
  }

  int addComment(String postId, String commentDescription, String username,
      String userId) {
    if (testing) {
      comments.add(Comments(
        id: comments.length.toString(),
        postId: postId,
        userId: userId,
        username: username,
        description: commentDescription,
        createdAt: DateTime.now().toString().substring(0, 10),
        upvotesCount: 0,
        downvotesCount: 0,
      ));
      return 200;
    }
    return 400;
  }

  void upVoteComment(String commentId) {
    if (testing) {
      for (var comment in comments) {
        if (comment.id == commentId) {
          comment.upvotesCount++;
        }
      }
    } else {
      // upvote comment in database
    }
  }

  void downVoteComment(String commentId) {
    if (testing) {
      for (var comment in comments) {
        if (comment.id == commentId) {
          comment.downvotesCount++;
        }
      }
    } else {
      // downvote comment in database
    }
  }
}
