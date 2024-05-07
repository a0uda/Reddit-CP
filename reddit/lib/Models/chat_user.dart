
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:intl/intl.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Services/user_service.dart';
  final userService = GetIt.instance.get<UserService>();

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
      imageURL:json['otherProfilePicture'],
     

        ///todo
       
      
        );

  }
}





class ChatMessage{
  String username;
  String messageContent;
  String messageType;
  String createdAt;
  ChatMessage({required this.messageContent, required this.messageType,required this.createdAt,required this.username});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
     final UserController userController = GetIt.instance.get<UserController>();
     var username=userController.userAbout!.username;

    String type=(json['senderId']['username']==username)? 'sender':'receiver';
    DateTime dateTime = DateTime.parse(json['createdAt']);
String formattedTime = DateFormat('HH:mm').format(dateTime);

    print(json['createdAt']);
    return ChatMessage(
      messageContent:  json['message'],
      messageType: type,
      createdAt: formattedTime,
      username: json['senderId']['username'],
    

   
       
      
        );

  }


}
