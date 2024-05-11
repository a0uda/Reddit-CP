import 'package:flutter_test/flutter_test.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:reddit/test_files/test_posts.dart';
import 'package:reddit/test_files/test_users.dart';

import 'notification_test.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('PostService', () {
    late PostService postService;
    late MockClient client;

    setUp(() {
      client = MockClient();
      postService = PostService();
    });

    test('test_addPost_addsPostLocallyWhenTesting', () async {
      // Arrange
      final expectedPostCount = posts.length + 1;

      // Act
      await postService.addPost(
        '1',
        'user1',
        'Test Title',
        'Test Description',
        'text',
        null,
        null,
        null,
        null,
        0,
        'community1',
        'Community 1',
        false,
        false,
        false,
        true,
      );

      // Assert
      expect(posts.length, expectedPostCount);
    });

    test('test_addPost_handlesImagePost', () async {
      // Arrange
      final expectedPostCount = posts.length + 1;

      // Act
      await postService.addPost(
        '1',
        'user1',
        'Test Title',
        'Test Description',
        'image',
        null,
        null,
        null,
        null,
        0,
        'community1',
        'Community 1',
        false,
        false,
        false,
        true,
      );

      // Assert
      expect(posts.length, expectedPostCount);
      expect(posts.last.type, 'image');
    });

    test('getMyPosts returns posts for the given username', () async {
      final username = users[1].userAbout.username;
      final page = 1;

      final posts = await postService.getMyPosts(username, page);

      expect(posts, isNotEmpty);
      expect(posts.every((post) => post.username == username), isTrue);
    });

    test('getPostsById returns posts for the given id', () {
      final id = "1";

      final posts = postService.getPostsById(id);

      expect(posts, isNotEmpty);
      expect(posts.every((post) => post.id == id), isTrue);
    });

    test('getPopularPosts returns popular posts', () {
      final posts = postService.getPopularPosts();

      expect(posts, isNotEmpty);
      expect(posts, equals(popularPosts));
    });
test('upVote increases upvotesCount for the given post id', () async {
      final id = '1';

      final initialUpvotesCount = posts.firstWhere((post) => post.id == id).upvotesCount;

      await postService.upVote(id);

      final updatedUpvotesCount = posts.firstWhere((post) => post.id == id).upvotesCount;

      expect(updatedUpvotesCount, equals(initialUpvotesCount + 1));
    });

    test('downVote increases downvotesCount for the given post id', () async {
      final id = '1';

      final initialDownvotesCount = posts.firstWhere((post) => post.id == id).downvotesCount;

      await postService.downVote(id);

      final updatedDownvotesCount = posts.firstWhere((post) => post.id == id).downvotesCount;

      expect(updatedDownvotesCount, equals(initialDownvotesCount + 1));
    });
test('submitReport adds a report for the given post id and reason', () async {
      final id = 'testId';
      final reason = 'testReason';

      await postService.submitReport(id, reason);

      final report = reportPosts.firstWhere((report) => report.id == id && report.reason == reason);

      expect(report, isNotNull);
    });

    test('savePost adds a save item for the given post id and username', () async {
      final id = 'testId';
      final username = 'testUsername';

      await postService.savePost(id, username);

      final saveItem = savedPosts.firstWhere((item) => item.id == id && item.username == username);

      expect(saveItem, isNotNull);
    });

    test('getSavePost returns saved posts for the given username', () async {
      final username = users[1].userAbout.username;

      final savedPosts = await postService.getSavePost(username);

      expect(savedPosts, isEmpty);
    });


    test('getPostById returns post for the given post id', () async {
      final postId = '1';

      final post = await postService.getPostById(postId);

      expect(post, isNotNull);
      expect(post!.id, equals(postId));
    });

    test('lockUnlockPost toggles lockedFlag for the given post id', () async {
      final id = '1';

      final initialLockedFlag = posts.firstWhere((post) => post.id == id).lockedFlag;

      await postService.lockUnlockPost(id);

      final updatedLockedFlag = posts.firstWhere((post) => post.id == id).lockedFlag;

      expect(updatedLockedFlag, equals(!initialLockedFlag));
    });

    test('isMyPost returns true if the post with the given id belongs to the given username', () {
      final postId = '1';
      final username = users[1].userAbout.username;

      final isMyPost = postService.isMyPost(postId, username);

      expect(isMyPost, equals(posts.firstWhere((post) => post.id == postId).username == username));
    });
  });
}
