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

  Future<void> savePost(String? id, String username) async {
    await postService.savePost(id, username);
    notifyListeners();
  }
}

class RefreshHome extends ChangeNotifier {
  bool refresh = false;
  bool get shouldRefresh => refresh;
  set shouldRefresh(bool value) {
    refresh = value;
  }

  void Refresh() {
    notifyListeners();
  }

  void resetRefresh() {
    refresh = false;
  }
}

class Edit extends ChangeNotifier {
  final postService = GetIt.instance.get<PostService>();
  bool refresh = false;
  bool get shouldRefresh => refresh;
  set shouldRefresh(bool value) {
    refresh = value;
  }

  void EditPost(String id, String caption) {
    postService.EditPost(id, caption);
    print('ana geet provider');
    Future.delayed(Duration(seconds: 2));
    notifyListeners();
  }

  void DeletePost(String id) {
    postService.DeletePost(id);
    print('ana geet provider');
    Future.delayed(Duration(seconds: 2));
    notifyListeners();
  }

  void resetRefresh() {
    refresh = false;
  }
}

class LockPost extends ChangeNotifier {
  final postService = GetIt.instance.get<PostService>();

  void lockPost(String? id) {
    postService.lockUnlockPost(id!);
    notifyListeners();
  }
}
