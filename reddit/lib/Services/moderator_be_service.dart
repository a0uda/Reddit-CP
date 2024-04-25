import 'dart:convert';
import 'package:reddit/Models/community_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

bool testing = const bool.fromEnvironment('testing');

class ModeratorMockService {
  Future<GeneralSettings> getGeneralSettings(String communityName) async {
    {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/communities/get-general-settings/$communityName');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token!},
      );
      final Map<String, dynamic> decodedSettings = json.decode(response.body);
      final GeneralSettings generalSettings = GeneralSettings(
        communityID: decodedSettings["_id"],
        communityName: decodedSettings["title"],
        communityDescription: decodedSettings["description"],
        communityType: decodedSettings["type"],
        nsfwFlag: decodedSettings["nsfw_flag"],
      );
      return generalSettings;
    }
  }

  Future<Map<String, dynamic>> getPostsAndComments(String communityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(
        'https://redditech.me/backend/communities/get-posts-and-comments/$communityName');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
    );
    final Map<String, dynamic> decodedSettings = json.decode(response.body);
    return {
      "postTypes": decodedSettings["post_type_options"],
      "allowImages": decodedSettings[
          "allow_image_uploads_and_links_to_image_hosting_sites"],
      "allowPolls": decodedSettings["allow_polls"],
      "allowVideo": decodedSettings["allow_videos"],
    };
  }
}
