
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
}
