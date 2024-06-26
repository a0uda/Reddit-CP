import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reddit/Models/notification_item.dart';
import 'package:reddit/widgets/best_listing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationsService with ChangeNotifier {
  bool testing = const bool.fromEnvironment('testing');

  Future<List<NotificationItem>> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse('https://redditech.me/backend/notifications');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
    );
    print("nottttiif");
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<dynamic> notificationsJson = data['content'];
      int unreadCount = 0;
      for (var notification in notificationsJson) {
        if (notification['unread_flag'] == true) {
          unreadCount++;
        }
      }

      userController.unreadNotificationsCount = unreadCount;
      // notifyListeners();
      return Future.wait(notificationsJson
          .map((json) => NotificationItem.fromJson(json))
          .toList());
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<int> getUnreadNotificationsCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url =
        Uri.parse('https://redditech.me/backend/notifications/unread-count');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      int unreadCount = data['count'];
      userController.unreadNotificationsCount = unreadCount;
      notifyListeners();
      return unreadCount;
    } else {
      return 0;
    }
  }

  Future<bool> hideNotification(String notificationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse('https://redditech.me/backend/notifications/hide');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: jsonEncode({
        'id': notificationId,
      }),
    );
    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      throw Exception('Failed to hide notification');
    }
  }

  Future<bool> markAsRead(String notificationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url =
        Uri.parse('https://redditech.me/backend/notifications/mark-as-read');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: jsonEncode({
        'id': notificationId,
      }),
    );
    // userController.unreadNotificationsCount--;
    getUnreadNotificationsCount();
    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      throw Exception('Failed to mark notification as read');
    }
  }

  Future<bool> muteUnmuteCommunity(String communityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url =
        Uri.parse('https://redditech.me/backend/users/mute-unmute-community');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: jsonEncode({
        'community_name': communityName,
      }),
    );
    print("mute");
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      throw Exception('Failed to mute community');
    }
  }

  Future<bool> markAllAsRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse(
        'https://redditech.me/backend/notifications/mark-all-as-read');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
    );
    userController.unreadNotificationsCount = 0;
    getUnreadNotificationsCount();
    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      throw Exception('Failed to mark all notifications as read');
    }
  }
}
