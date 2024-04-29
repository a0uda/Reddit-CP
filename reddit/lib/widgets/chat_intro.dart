import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/chat_service.dart';
import 'package:reddit/Models/chat_user.dart';
import 'package:reddit/widgets/add_chat.dart';
import 'package:reddit/widgets/chat_tile.dart';

class ChatIntro extends StatefulWidget {
  @override
  _ChatIntroState createState() => _ChatIntroState();
}

class _ChatIntroState extends State<ChatIntro> {
  ChatsService chatService = GetIt.instance.get<ChatsService>();
  List<ChatUsers> chatUsers = [];
  late Future<void> _dataFuture;

  Future<void> fetchChats() async {
    chatUsers = await chatService.getChats();
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    bool ismobile = (width > 700) ? false : true;
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            (!ismobile)
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  )
                : Container(),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Chats",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 253, 119, 10)),
                  onPressed: () {
                     Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddChat(), 
            ),
          );
    
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    'New',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                   
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            FutureBuilder<void>(
                future: _dataFuture,
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  return ListView.builder(
                    itemCount: chatUsers.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 16),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ConversationList(
                        name: chatUsers[index].name,
                        messageText: chatUsers[index].messageText,
                        imageUrl: chatUsers[index].imageURL,
                        time: chatUsers[index].time,
                        isMessageRead:
                            (index == 0 || index == 3) ? true : false,
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
