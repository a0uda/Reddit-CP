import 'package:flutter/material.dart';
import 'package:reddit/widgets/chat_screen.dart';
class ConversationList extends StatefulWidget{
  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  ConversationList({required this.name,required this.messageText,required this.imageUrl,required this.time,required this.isMessageRead});
  @override
  _ConversationListState createState() => _ConversationListState();
}
String formatDateTime(String dateTimeString) {


  final DateTime now = DateTime.now();
  final DateTime parsedDateTime = DateTime.parse(dateTimeString);

  final Duration difference = now.difference(parsedDateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}sec';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else if (difference.inDays < 30) {
    return '${difference.inDays}d';
  } else {
    final int months = now.month -
        parsedDateTime.month +
        (now.year - parsedDateTime.year) * 12;
    if (months < 12) {
      return '$months mth';
    } else {
      final int years = now.year - parsedDateTime.year;
      return '$years yrs';
    }
  }
}


class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async {
           final String result=  await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatPage(name: widget.name, image: widget.imageUrl,), 
            ),
            

          );
          setState(() {
            widget.messageText=result;
    
            
          });
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  widget.imageUrl == "" ?
                  CircleAvatar(
                    backgroundImage: AssetImage("./images/Greddit.png"),
                    maxRadius: 20,
                  ):
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 20,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: TextStyle(fontSize: 16),),
                          SizedBox(height: 4,),
                          Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(formatDateTime(widget.time),style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}