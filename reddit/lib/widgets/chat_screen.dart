import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/chat_user.dart';
import 'package:reddit/Services/chat_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as Io;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/chat_controller.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String image;

  ChatPage({
    required this.name,
    required this.image,
  });
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatsService chatservice = GetIt.instance.get<ChatsService>();
  late Io.Socket socket;
  var previoususername = '';
  final userController = GetIt.instance.get<UserController>();
  TextEditingController textController = TextEditingController();
  String lastmessage = '';
  ChatsService chatService = GetIt.instance.get<ChatsService>();
  List<ChatMessage> messages = [];
  late Future<void> _dataFuture;
  Future<void> fetchMessages() async {
    messages = await chatService.getChatsContent(widget.name);
    print(messages.length);
  }

  void Handlemessage(data) {
    print('message');
    print(data);
    DateTime dateTime = DateTime.parse(data['createdAt']);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    messages.add(ChatMessage(
        messageContent: data['message'],
        messageType: 'receiver',
        createdAt: formattedTime,
        username: widget.name));
    update();
  }

  Future<void> SocketInit() async {
    socket.on("newMessage", Handlemessage);
  }

  void update() {
    setState(() {});
  }

  void initState() {
    super.initState();
    socket = chatservice.getSocket();
    SocketInit();
    _dataFuture = fetchMessages();
  }

  @override
  void dispose() {
    super.dispose();
    socket.off('newMessage', Handlemessage);
  }

  @override
  Widget build(BuildContext context) {
    var chatController = context.read<Chat>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            socket.off('newMessage', Handlemessage);

            if (messages.length != 0)
              lastmessage = messages[messages.length - 1].messageContent;

            Navigator.pop(context, lastmessage);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Column(children: [
                Align(
                  alignment: Alignment.center,
                  child: widget.image == ""
                      ? CircleAvatar(
                          backgroundImage: AssetImage("images/Greddit.png"),
                          maxRadius: 40,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(widget.image),
                          maxRadius: 40,
                        ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.name,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                FutureBuilder<void>(
                    future: _dataFuture,
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        itemBuilder: (context, index) {
                          if (index != messages.length - 1)
                            previoususername =
                                messages[messages.length - index - 2].username!;
                          else {
                            previoususername = '';
                          }
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 2, bottom: 2),
                            child: Align(
                              alignment: (messages[messages.length - index - 1]
                                          .messageType ==
                                      "receiver"
                                  ? Alignment.topLeft
                                  : Alignment.topLeft),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: (messages[messages.length - index - 1]
                                              .messageType ==
                                          "receiver"
                                      ? Color.fromARGB(255, 255, 255, 255)
                                      : const Color.fromARGB(
                                          255, 255, 255, 255)),
                                ),
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Card(
                                  color: (messages[messages.length - index - 1]
                                              .messageType ==
                                          "receiver"
                                      ? Color.fromARGB(255, 255, 255, 255)
                                      : const Color.fromARGB(
                                          255, 255, 255, 255)),
                                  elevation: 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (messages[messages.length - index - 1]
                                                  .username !=
                                              previoususername)
                                          ? Row(children: [
                                              CircleAvatar(
                                                backgroundImage: (messages[
                                                                messages.length -
                                                                    index -
                                                                    1]
                                                            .username ==
                                                        userController
                                                            .userAbout!
                                                            .username)
                                                    ? NetworkImage(
                                                        userController
                                                            .userAbout!
                                                            .profilePicture!)
                                                    : 
                                                    NetworkImage(
                                                        widget.image),
                                                maxRadius: 13,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                messages[messages.length -
                                                        index -
                                                        1]
                                                    .username,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  messages[messages.length -
                                                          index -
                                                          1]
                                                      .createdAt,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              )
                                            ])
                                          : Container(),

                                      //content
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          messages[messages.length - index - 1]
                                              .messageContent,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        //content
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
              ]),
            ),
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
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    IconButton(
                      iconSize: 20,
                      color: Color.fromARGB(255, 253, 119, 10),
                      highlightColor: Theme.of(context).colorScheme.primary,
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        //send message
                        if (!textController.text.isEmpty) {
                          int response = await chatController.Sendmessage(
                              widget.name, textController.text);
                          chatController.refresh = true;

                          if ((response >= 200) && (response < 300)) {
                            setState(() {
                              messages.add(ChatMessage(
                                  messageContent: textController.text,
                                  username: userController.userAbout!.username,
                                  messageType: 'sender',
                                  createdAt: DateFormat('HH:mm')
                                      .format(DateTime.now())));
                              textController.clear();
                            });
                          }
                        }
                      },
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
