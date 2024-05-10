import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/image_item.dart';
import 'package:reddit/Models/poll_item.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Models/video_item.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/test_files/test_posts.dart';

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
  });

  group('PostService', () {
    late PostService postService;
    late MockUserService mockUserService;
    late MockClient mockClient;

    setUp(() {
      GetIt.instance.registerSingleton<UserService>(MockUserService());
      mockUserService = GetIt.instance<UserService>() as MockUserService;
      mockClient = MockClient();
      postService = PostService();
    });

    // test('test_getPosts_withTestingTrue', () async {
    //   // Arrange
    //   final followers = [
    //     FollowersFollowingItem(username: 'user1'),
    //     FollowersFollowingItem(username: 'user2')
    //   ];
    //   when(mockUserService.getFollowers('testUser'))
    //       .thenAnswer((_) async => followers);

    //   // Act
    //   final result = await postService.getPosts('testUser', 'best', 1);

    //   // Assert
    //   expect(result, isA<List<PostItem>>());
    //   expect(result.length, 2);
    //   expect(result[0].username, 'user1');
    //   expect(result[1].username, 'user2');
    // });

    
   
  });
}
