import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Services/notifications_service.dart';
import 'package:reddit/widgets/notifications_settings.dart';

class InboxOptions extends StatefulWidget {
  const InboxOptions({
    super.key,
  });

  @override
  InboxOptionState createState() => InboxOptionState();
}

class InboxOptionState extends State<InboxOptions> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => {
              showModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    late NotificationsService notificationsService =
                        Provider.of<NotificationsService>(context,
                            listen: false);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              addNewMessage(context);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  CupertinoIcons.pencil,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "New message",
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            )),
                        TextButton(
                            onPressed: () async {
                              var messageController =
                                  context.read<MessagesOperations>();
                              await messageController.markallAsRead();
                              await notificationsService.markAllAsRead();
                              Navigator.pop(context);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text("Mark all inbox tabs as read",
                                    style: TextStyle(color: Colors.black))
                              ],
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsSettings(),
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Edit notification settings",
                                    style: TextStyle(color: Colors.black))
                              ],
                            )),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Close',
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  })
            },
        icon: const Icon(Icons.more_horiz));
  }
}

void addNewMessage(BuildContext context,
    {bool isProfilePage = false, String receiverUsername = ''}) {
  TextEditingController receiverUsernameController = TextEditingController();
  TextEditingController messageContentController = TextEditingController();
  TextEditingController subjectContentController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    if (messageContentController.text.isNotEmpty &&
                        receiverUsernameController.text.isNotEmpty &&
                        subjectContentController.text.isNotEmpty) {
                      bool success =
                          await context.read<MessagesOperations>().sendMessage(
                                receiverUsernameController.text,
                                messageContentController.text,
                                subjectContentController.text,
                              );
                      if (success) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Message is not sent successfully.\nThis is not a valid username.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.black,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            receiverUsernameController.text.isEmpty
                                ? 'Please enter the receiver username'
                                : subjectContentController.text.isEmpty
                                    ? 'Please enter subject'
                                    : 'Please enter the message content',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.black,
                        ),
                      );
                    }
                  },
                  child: Text("SEND",
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: receiverUsernameController
                      ..text = isProfilePage ? 'u/$receiverUsername' : '',
                    decoration: isProfilePage
                        ? const InputDecoration(
                            prefixStyle: TextStyle(
                              color: Colors.black,
                            ),
                            counterText: '',
                          )
                        : const InputDecoration(
                            prefixText: 'u/',
                            prefixStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: 'username',
                            counterText: '',
                          ),
                    autofocus: !isProfilePage,
                    enabled: !isProfilePage,
                    maxLength: 20,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: subjectContentController,
                    decoration: const InputDecoration(
                      hintText: 'Subject',
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: messageContentController,
                    decoration: const InputDecoration(
                      hintText: 'Message',
                    ),
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
