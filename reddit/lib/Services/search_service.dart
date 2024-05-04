import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchService {
  bool testing = const bool.fromEnvironment('testing');

  Future<List<Map<String, dynamic>>> getSearchUsers(
      String searchWord, int pageNum) async {
    if (testing) {
      // List<Map<String, dynamic>> bannedUsers = communities
      //     .firstWhere((community) => community.communityName == communityName)
      //     .bannedUsers;
      // return bannedUsers;
      return [];
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (searchWord == "") {
        searchWord = " ";
      }

      String url =
          'https://redditech.me/backend/search/people?page=$pageNum&pageSize=10&query=$searchWord';

      final Uri uri = Uri.parse(url);
      final response = await http.get(
        uri,
      );
      final decodedData = json.decode(response.body);
      print(decodedData);
      final List<Map<String, dynamic>> foundUsers =
          List<Map<String, dynamic>>.from(decodedData['content']);
      return foundUsers; //badrrr
    }
  }

  Future<List<Map<String, dynamic>>> getSearchCommunities(
      String searchWord, int pageNum, int pageSize) async {
    if (testing) {
      return [];
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (searchWord == "") {
        searchWord = " ";
      }

      String url =
          'https://redditech.me/backend/search/communities?page=$pageNum&pageSize=$pageSize&query=$searchWord';
      // final Map<String, String> queryParams = {
      //   'query': searchWord,
      //   'page': pageNum.toString(),
      //   'pageSize': '10'
      // };

      final Uri uri = Uri.parse(url);
      final response = await http.get(
        uri,
      );
      final decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> foundComm =
          List<Map<String, dynamic>>.from(decodedData['content']);
      print("yaba");

      return foundComm; //badrrr
    }
  }

  Future<List<Map<String, dynamic>>> getSearchComments(
      String searchWord, int pageNum, String sortBy) async {
    if (testing) {
      return [];
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (searchWord == "") {
        searchWord = " ";
      }

      String url =
          'https://redditech.me/backend/search/comments?query=$searchWord&page=$pageNum&sortBy=$sortBy&pageSize=8';
      // final Map<String, String> queryParams = {
      //   'query': searchWord,
      //   'page': pageNum.toString(),
      //   'pageSize': '10'
      // };

      final Uri uri = Uri.parse(url);
      final response = await http.get(
        uri,
      );
      final decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> foundComm =
          List<Map<String, dynamic>>.from(decodedData['content']);
      return foundComm; //badrrr
    }
  }

  Future<List<Map<String, dynamic>>> getSearchPosts(
      String searchWord, int pageNum, String sortBy, String sortTime) async {
    if (testing) {
      return [];
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (searchWord == "") {
        searchWord = " ";
      }

      String url =
          'https://redditech.me/backend/search/posts?query=$searchWord&page=$pageNum&sortBy=$sortBy&pageSize=8&sortTime=$sortTime';
      // final Map<String, String> queryParams = {
      //   'query': searchWord,
      //   'page': pageNum.toString(),
      //   'pageSize': '10'
      // };

      final Uri uri = Uri.parse(url);
      final response = await http.get(
        uri,
      );
      final decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> foundPost =
          List<Map<String, dynamic>>.from(decodedData['content']);
      return foundPost; //badrrr
    }
  }

  Future<List<Map<String, dynamic>>> getPostInCommunity(String searchWord,
      int pageNum, String sortBy, String sortTime, String communityName) async {
    if (testing) {
      return [];
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (searchWord == "") {
        searchWord = " ";
      }

      String url =
          'https://redditech.me/backend/search/community/posts/$communityName?query=$searchWord&page=$pageNum&pageSize=10&sortBy=$sortBy';
      // final Map<String, String> queryParams = {
      //   'query': searchWord,
      //   'page': pageNum.toString(),
      //   'pageSize': '10'
      // };
      // final response = await http.get(
      //   url,
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': token!,
      //   },
      // );

      final Uri uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      final decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> foundPost =
          List<Map<String, dynamic>>.from(decodedData['content']);
      return foundPost; //badrrr
    }
  }

  Future<List<Map<String, dynamic>>> getCommentsInCommunity(String searchWord,
      int pageNum, String sortBy, String communityName) async {
    if (testing) {
      return [];
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (searchWord == "") {
        searchWord = " ";
      }

      String url =
          'https://redditech.me/backend/search/community/comments/$communityName?query=$searchWord&page=$pageNum&sortBy=$sortBy&pageSize=8';
      // final Map<String, String> queryParams = {
      //   'query': searchWord,
      //   'page': pageNum.toString(),
      //   'pageSize': '10'
      // };

      final Uri uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      final decodedData = json.decode(response.body);
      final List<Map<String, dynamic>> foundComm =
          List<Map<String, dynamic>>.from(decodedData['content']);
      return foundComm; //badrrr
    }
  }
}
