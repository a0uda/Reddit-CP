import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Services/chat_service.dart';
import 'package:reddit/Services/post_service.dart';

class Chat extends ChangeNotifier {
  bool refresh = false;
  bool get shouldRefresh => refresh;
  set shouldRefresh(bool value) {
    refresh = value;
  }

  final chatService = GetIt.instance.get<ChatsService>();
  void resetRefresh() {
    refresh = false;
  }

  Future<int> Sendmessage(String username, String message) async {
    int response = await chatService.SendChat(username, message);

    notifyListeners();
    return response;
  }

  void receivedchat(String username, String message) async {
    notifyListeners();
  }
}
