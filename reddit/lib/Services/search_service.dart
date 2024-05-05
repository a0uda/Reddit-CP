import 'dart:convert';

import 'package:reddit/Models/community_item.dart';
import 'package:reddit/test_files/test_posts_mohy.dart';
import 'package:reddit/widgets/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../test_files/test_communities.dart';
import 'package:http/http.dart' as http;

class SearchService {
  bool testing = const bool.fromEnvironment('testing');

  Future<List<Map<String, dynamic>>> getSearchUsers(String searchWord) async {
    if (testing) {
      // List<Map<String, dynamic>> bannedUsers = communities
      //     .firstWhere((community) => community.communityName == communityName)
      //     .bannedUsers;
      // return bannedUsers;
      return [];
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String url = 'https://redditech.me/backend/search/people';
      final Map<String, String> queryParams = {
        'query': searchWord,
        'page': '1',
        'pageSize': '5'
      };

      final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
      );
      print("ALOOOOOOOOO");
      final decodedData = json.decode(response.body)['content'];
      print(decodedData);
      final List<Map<String, dynamic>> foundUsers =
          (decodedData as List).map((user) {
        return {
          "_id": user["_id"],
          "username": user["username"],
          "profile_picture": user["profile_picture"],
          "created_at": user["created_at"],
          "profile_settings": user["profile_settings"],
        };
      }).toList();
      return foundUsers; //badrrr
    }
  }
}
