import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mockito/mockito.dart';
import 'dart:io';

import 'package:reddit/Pages/create_post.dart';

class MockImagePicker extends Mock implements ImagePicker {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockFile extends Mock implements File {}

void main() {
  group('CreatePost Widget Tests', () {
    

    test('test_post_creation_without_title', () async {
      CreatePost createPost = CreatePost();

      // Act
      bodyController.text = "Test Body";

      // Assert
      expect(titleController.text.isEmpty, true);
    });
    test('test_post_creation_with_title', () async {
      CreatePost createPost = CreatePost();

      // Act
      titleController.text = "Test Title";
      bodyController.text = "Test Body";

      // Assert
      expect(titleController.text.isNotEmpty, true);
    });

    
  });
}
