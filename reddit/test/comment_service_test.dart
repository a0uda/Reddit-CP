import 'package:flutter_test/flutter_test.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/test_files/test_comments.dart';
import 'package:reddit/test_files/test_posts.dart';

void main() {
  group('CommentsService', () {
    final commentsService = CommentsService();

    test('testGetCommentByPostId', () async {
      // Assuming 'comments' is accessible and contains predefined test data
      var result = await commentsService.getCommentByPostId('1');
      expect(result, isA<List<Comments>>());
      expect(result.length, 2);
    });

    test('testAddComment', () async {
      // Assuming 'posts' is accessible and contains predefined test data
      var initialCount = posts.firstWhere((p) => p.id == '1').commentsCount;
      await commentsService.addComment('1', 'New comment', 'user123', 'user123');
      var updatedCount = posts.firstWhere((p) => p.id == '1').commentsCount;
      expect(updatedCount, initialCount + 1);
    });

    test('testUpVoteComment', () async {
      // Assuming 'comments' is accessible and contains predefined test data
      var comment = comments.firstWhere((c) => c.id == '1');
      var initialUpvotes = comment.upvotesCount;
      await commentsService.upVoteComment('1');
      expect(comment.upvotesCount, initialUpvotes + 1);
    });
     test('downVoteComment increases downvotesCount for the given comment id', () async {
      final id = '2';

      final initialDownvotesCount = comments.firstWhere((comment) => comment.id == id).downvotesCount;

      await commentsService.downVoteComment(id);

      final updatedDownvotesCount = comments.firstWhere((comment) => comment.id == id).downvotesCount;

      expect(updatedDownvotesCount, equals(initialDownvotesCount + 1));
    });

    test('getCommentById returns comment for the given comment id', () {
      final commentId = '1';

      final comment = commentsService.getCommentById(commentId);

      expect(comment, isNotNull);
      expect(comment!.id, equals(commentId));
    });
  });
}