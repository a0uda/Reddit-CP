import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/chat_user.dart';
import 'package:reddit/Services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String name;
  ChatPage({
    required this.name,
  });
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatsService chatService = GetIt.instance.get<ChatsService>();
  List<ChatMessage> messages = [];
  late Future<void> _dataFuture;
  Future<void> fetchMessages() async {
    messages = await chatService.getChatsContent();
  }

  void initState() {
    super.initState();
    _dataFuture = fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(""),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ), //status
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: FutureBuilder<void>(
                future: _dataFuture,
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  return ListView.builder(
                    itemCount: messages.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 2, bottom: 2),
                        child: Align(
                          alignment: (messages[index].messageType == "receiver"
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: (messages[index].messageType == "receiver"
                                  ?  Color.fromARGB(255, 163, 228, 246)
                                  : Colors.grey.shade200),
                            ),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Card(
                              color: (messages[index].messageType == "receiver"
                                  ?   Color.fromARGB(255, 163, 228, 246)
                                  : Colors.grey.shade200),
                              elevation: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messages[index].messageContent,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      '7 pm',
                                      style: TextStyle(
                                          fontSize: 12,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton.small(
                      onPressed: () {},
                             shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            90),),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Color.fromARGB(255, 10, 116, 51),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
