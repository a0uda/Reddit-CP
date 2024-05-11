import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/chat_service.dart';
import 'package:reddit/Models/chat_user.dart';
import 'package:reddit/widgets/chat_search.dart';
import 'package:reddit/widgets/chat_tile.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;

typedef OnNewChat = void Function();

class ChatIntro extends StatefulWidget {
  @override
  _ChatIntroState createState() => _ChatIntroState();
}

class _ChatIntroState extends State<ChatIntro> {
  ChatsService chatService = GetIt.instance.get<ChatsService>();
  late Io.Socket socket;
  List<ChatUsers> chatUsers = [];
  List<ChatUsers> foundChats = [];
  late Future<void> _dataFuture;

  bool isInit = true;
  bool setStateAyHaga = false;
  void handleNewChat() {
    setState(() {
      _dataFuture = fetchChats();
    });
    print('Ana abdullah w geet hena');
  }

  // Future<void> fetchCallback() async {
  //   if (isInit) {
  //     await fetchChats();
  //     isInit = false;
  //   } else {
  //     await fetchChatsPartTwo();
  //     setState(() {
  //       setStateAyHaga = !setStateAyHaga;
  //     });
  //   }
  // }

  Future<void> fetchChatsPartTwo() async {
    chatUsers = await chatService.getChats();
    foundChats = chatUsers;
    print(chatUsers);
  }

  Future<void> fetchChats() async {
    chatUsers = await chatService.getChats();
    foundChats = chatUsers;
    print(chatUsers);
    SocketInit();
  }

  Future<void> SocketInit() async {
    socket = chatService.getSocket();

    socket.on("newMessage", ((data) {
      print(data);

      setState(() {
        _dataFuture = fetchChats();
      });
    }));
  }

  void searchUsers(String search) {
    setState(() {
      foundChats = chatUsers.where((user) {
        final name = user.name.toString().toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
    });
  }

  void update() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    socket.clearListeners();
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
                      socket.clearListeners();
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
                          backgroundColor:
                              const Color.fromARGB(255, 3, 55, 146)),
                      onPressed: () {
                        //            Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         AddChat(),
                        //   ),
                        // );
                        showSearch(
                            context: context,
                            delegate: ChatSearch(onNewChat: handleNewChat));
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
                onChanged: searchUsers,
              ),
            ),
            FutureBuilder<void>(
                future: _dataFuture,
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  return ListView.builder(
                    itemCount: foundChats.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 16),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ConversationList(
                        name: foundChats[index].name,
                        messageText: foundChats[index].messageText,
                        imageUrl: foundChats[index].imageURL,
                        time: foundChats[index].time.split('T')[0],
                        isMessageRead:
                            (index == 0 || index == 3) ? true : false,
                        onNewChat: handleNewChat,
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
