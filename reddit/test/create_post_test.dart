
//     // The user selects a community from the list of user communities.
// import 'package:reddit/Pages/create_post.dart';
// import 'package:test/test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:get_it/get_it.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:reddit/Services/post_service.dart';
// import 'package:reddit/Services/community_service.dart';
// import 'package:reddit/controllers/community_controller.dart';
// import 'package:reddit/controllers/user_controller.dart';
// import 'package:reddit/Services/moderator_service.dart';
// import 'package:reddit/controllers/moderator_controller.dart';
// import 'package:reddit/models/community_item.dart';
// import 'package:reddit/widgets/video_player_widget.dart';
// // import 'package:reddit/widgets/modal_for_schedule.dart';
// // import 'package:reddit/widgets/modal_for_rules.dart';

// class MockPostService extends Mock implements PostService {}

// class MockCommunityService extends Mock implements CommunityService {}

// class MockCommunityController extends Mock implements CommunityController {}

// class MockUserController extends Mock implements UserController {}

// class MockModeratorMockService extends Mock implements ModeratorMockService {}

// class MockModeratorController extends Mock implements ModeratorController {}

// class MockXFile extends Mock implements XFile {}

// class MockVideoPlayerController extends Mock implements VideoPlayerController {}

// class MockFirebaseStorage extends Mock implements FirebaseStorage {}

// void main() {
//   group('CreatePost', () {
//     late CreatePost createPostState;
//     late MockPostService mockPostService;
//     late MockCommunityService mockCommunityService;
//     late MockCommunityController mockCommunityController;
//     late MockUserController mockUserController;
//     late MockModeratorMockService mockModeratorService;
//     late MockModeratorController mockModeratorController;
//     late MockXFile mockXFile;
//     late MockVideoPlayerController mockVideoPlayerController;
//     late MockFirebaseStorage mockFirebaseStorage;

//     setUp(() {
//       mockPostService = MockPostService();
//       mockCommunityService = MockCommunityService();
//       mockCommunityController = MockCommunityController();
//       mockUserController = MockUserController();
//       mockModeratorService = MockModeratorMockService();
//       mockModeratorController = MockModeratorController();
//       mockXFile = MockXFile();
//       mockVideoPlayerController = MockVideoPlayerController();
//       mockFirebaseStorage = MockFirebaseStorage();

//       GetIt.instance.registerSingleton<PostService>(mockPostService);
//       GetIt.instance.registerSingleton<CommunityService>(mockCommunityService);
//       GetIt.instance.registerSingleton<CommunityController>(mockCommunityController);
//       GetIt.instance.registerSingleton<UserController>(mockUserController);
//       GetIt.instance.registerSingleton<ModeratorMockService>(mockModeratorService);
//       GetIt.instance.registerSingleton<ModeratorController>(mockModeratorController);

//       createPostState = CreatePost();
//     });

//     tearDown(() {
//       GetIt.instance.reset();
//     });

//     test('should update selectedCommunity when user selects a community', () async {
//       // Arrange
//       final selectedCommunity = 'Community A';

//       when(mockUserController.getUserCommunities()).thenAnswer((_) async => {});
//       when(mockUserController.userCommunities).thenReturn([CommunityBackend(name: selectedCommunity)]);

//       // Act
//       await createPostState.;

//       // Assert
//       expect(createPostState.selectedCommunity, selectedCommunity);
//     });
    
//     // The user selects a community from the list and it is displayed as the selected community.
// void test_select_community() {
//   // Arrange
//   final createPostState = _CreatePostState();
  
//   // Act
//   createPostState.selectedCommunity = "Community A";
  
//   // Assert
//   expect(createPostState.selectedCommunity, "Community A");
// }

//     // The user does not enter a title for the post and an error message is displayed.
// void test_empty_title_error() {
//   // Arrange
//   final createPostState = CreatePostState();
  
//   // Act
//   createPostState.titleController.text = "";
//   createPostState.onPressed();
  
//   // Assert
//   expect(createPostState.showErrorMessage, true);
// }

//   });
// }

   