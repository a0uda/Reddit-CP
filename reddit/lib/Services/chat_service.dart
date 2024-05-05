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
print('chatsss');
      final List<dynamic> jsonlist = json.decode(response.body);
      final List<ChatUsers> chats = jsonlist.map((jsonitem) {
        return ChatUsers.fromJson(jsonitem);
      }).toList();
      return chats;



    }


  }
 
 Future<List<ChatMessage>> getChatsContent (String username) async
  {
    if(testing)
    {
      return messages;
    
    }
    else{
          final url =
          Uri.parse('https://redditech.me/backend/chats/$username');

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
print('chatsss');
      final List<dynamic> jsonlist = json.decode(response.body);
      final List<ChatMessage> chats = jsonlist.map((jsonitem) {
        return ChatMessage.fromJson(jsonitem);
      }).toList();
      return chats;



    }


  }



 Future<int> SendChat (String username,String message) async
  {
    if(testing)
    {
    return 200;
    }
    else{
          final url =
          Uri.parse('https://redditech.me/backend/chats/send/$username');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print('send messsaaaggeeee');
 final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body:  json.encode( {
          "message":message
        })

      );
      print(response.statusCode);

return response.statusCode;



    }


  }








}
