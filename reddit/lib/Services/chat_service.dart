import 'dart:async';

import 'dart:convert';
import 'package:reddit/Models/chat_user.dart';

import 'package:reddit/test_files/test_chats.dart';

import 'package:http/http.dart' as http;
import '../test_files/test_posts.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool testing = const bool.fromEnvironment('testing');

class ChatsService {
  Future<List<ChatUsers>> getChats () async
  {
    if(testing)
    {
      return chatUsers;
    
    }
    else{
      
           final url =
          Uri.parse('https://redditech.me/backend/chats/');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
 final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
      );

print(response.body);
      final List<dynamic> jsonlist = json.decode(response.body);
      final List<ChatUsers> chats = jsonlist.map((jsonitem) {
        return ChatUsers.fromJson(jsonitem);
      }).toList();
      return chats;



    }


  }
 
 Future<List<ChatMessage>> getChatsContent () async
  {
    if(testing)
    {
      return messages;
    
    }
    else{
      return messages;

    }


  }

}
