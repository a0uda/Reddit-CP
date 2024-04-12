import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Services/post_service.dart';

class PostController {
  final postService = GetIt.instance.get<PostService>();
  List<PostItem>? postItems;

  void getPost() async {
    postItems = postService.fetchPosts();
  }
}
class SavePost extends ChangeNotifier {

  final postService = GetIt.instance.get<PostService>();

  void unSavePost(String? id,String username) {
    postService.unSavePost(id,username);
    notifyListeners();
  }

 
}

