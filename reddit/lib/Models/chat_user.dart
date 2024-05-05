
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';

class ChatUsers {
  String name;
  String messageText;
  String imageURL;
  String time;
  ChatUsers(
      {required this.name,
      required this.messageText,
      required this.imageURL,
      required this.time});


      factory ChatUsers.fromJson(Map<String, dynamic> json) {
   
    
    return ChatUsers(
      name: json['otherUsername'],
      messageText: json['lastMessageText'],
      time: json['lastMessageTimestamp'],
      imageURL: ''

        ///todo
       
      
        );

  }
}





class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
     final UserController userController = GetIt.instance.get<UserController>();
     var username=userController.userAbout!.username;

    String type=(json['senderId']['username']==username)? 'sender':'receiver';
    return ChatMessage(
      messageContent:  json['message'],
      messageType: type,
    

        ///todo
       
      
        );

  }


}
