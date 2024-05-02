import 'dart:async';


import 'package:reddit/Models/chat_user.dart';

import 'package:reddit/test_files/test_chats.dart';

import 'package:http/http.dart' as http;
import '../test_files/test_posts.dart';

bool testing = const bool.fromEnvironment('testing');

class ChatsService {
  Future<List<ChatUsers>> getChats () async
  {
    if(testing)
    {
      return chatUsers;
    
    }
    else{
      return chatUsers;

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
