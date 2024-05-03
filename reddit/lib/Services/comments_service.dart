import 'dart:async';
import 'dart:convert';

import 'package:reddit/Models/comments.dart';
import 'package:reddit/test_files/test_comments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../test_files/test_posts.dart';

bool testing = const bool.fromEnvironment('testing');

class CommentsService {
  Future<List<Comments>> getCommentByPostId(String postId) async {
    if (testing) {
      List<Comments> commentsList = [];
      for (var comment in comments) {
        if (comment.postId == postId) {
          commentsList.add(comment);
        }
      }

      return commentsList;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/posts/get-comments?id=$postId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(response.body);
        List<Comments> commentsList = [];
        for (var comment in data['content']) {
          commentsList.add(Comments.fromJson(comment));
        }
        print(commentsList);
        return commentsList;
      } else {
        throw Exception('Failed to load comments');
      }
    }
  }

  Future<int> addComment(String postId, String commentDescription,
      String username, String userId) async {
    print("adding comment");
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
      final post = posts.firstWhere((element) => element.id == postId);
      post.commentsCount++;
      return 200;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/comments/new-comment');
      print(token!);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          'id': postId,
          'description': commentDescription,
        }),
      );
      print({
        'id': postId,
        'description': commentDescription,
      });

      if (response.statusCode == 200) {
        print('commentt addededde');
        return 200;
      } else {
        return 400;
      }
    }
  }

  Future<void> upVoteComment(String commentId) async {
    if (testing) {
      for (var comment in comments) {
        if (comment.id == commentId) {
          comment.upvotesCount++;
        }
      }
    } else {
      final url =
          Uri.parse('https://redditech.me/backend/posts-or-comments/vote');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body: json.encode({"id": commentId, "is_post": false, "vote": "1"}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('upvoted');
      } else {
        print('failed to upvote');
      }
    }
  }

  Future<void> downVoteComment(String commentId) async {
    if (testing) {
      for (var comment in comments) {
        if (comment.id == commentId) {
          comment.downvotesCount++;
        }
      }
    } else {
      final url =
          Uri.parse('https://redditech.me/backend/posts-or-comments/vote');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body: json.encode({"id": commentId, "is_post": false, "vote": "-1"}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('downvoted');
      } else {
        print('failed to downvote');
      }
    }
  }

  Comments? getCommentById(String commentId) {
    for (var comment in comments) {
      if (comment.id == commentId) {
        return comment;
      }
    }
    return null;
  }
}
