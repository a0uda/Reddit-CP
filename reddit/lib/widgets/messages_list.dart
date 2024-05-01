import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/message_item.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/message_content.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({
    super.key,
  });

  @override
  MessagesState createState() => MessagesState();
}

class MessagesState extends State<MessagesPage> {
  final userService = GetIt.instance.get<UserService>();
  final userController = GetIt.instance.get<UserController>();
  @override
  Widget build(BuildContext context) {
    var followerfollowingcontroller =
        context.read<FollowerFollowingController>();
    return Consumer<MessagesOperations>(
      builder: (context, messagesOperations, child) {
        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            userService.getMessages(userController.userAbout!.username),
            followerfollowingcontroller
                .getFollowing(userController.userAbout!.username)
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
                child: const SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Consumer<BlockUnblockUser>(
                builder: (context, BlockUnblockUser, child) {
                  List<Messages> messagesList = snapshot.data![0];
                  List<FollowersFollowingItem>? following =
                      followerfollowingcontroller.following;
                  List<BlockedUsersItem>? blockedUsers =
                      userController.blockedUsers;
                  messagesList.removeWhere((element) => blockedUsers!.any(
                      (blockedUser) =>
                          blockedUser.username == element.senderUsername ||
                          blockedUser.username == element.receiverUsername));
                  List<Messages> originalMessagesList = List.from(messagesList);
                  if (messagesList.isNotEmpty) {
                    messagesList = processAllMessage(messagesList);
                  }
                  return messagesList.isEmpty
                      ? const Center(
                          child: Text('No messages yet!'),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: messagesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Messages message = messagesList[index];
                            List<Messages> replies =
                                processMessage(originalMessagesList, message);
                            String? messageReceiver = message.isSent
                                ? (message.receiverType == 'user'
                                    ? message.receiverUsername ?? ''
                                    : message.receiverUsername)
                                : (message.senderType == 'user'
                                    ? message.senderUsername
                                    : message.senderVia);
                            return ListTile(
                              onTap: () async {
                                userService.markoneMessageRead(message.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => (MessageContent(
                                      messages: replies,
                                      following: following!,
                                    )),
                                  ),
                                );
                                setState(() {
                                  message.unreadFlag = false;
                                });
                              },
                              tileColor: Colors.white,
                              title: Row(
                                children: [
                                  Text(
                                    "${message.isSent ? message.receiverType == 'user' ? message.receiverUsername ?? '' : 'r/${message.receiverUsername}' : message.senderType == 'user' ? message.senderUsername : message.senderVia}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: message.unreadFlag
                                            ? Colors.black
                                            : const Color.fromARGB(
                                                255, 112, 112, 112),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ' • ${getDateTimeDifferenceWithLabel(message.createdAt ?? '')}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 174, 174, 174),
                                    ),
                                  ),
                                  const Spacer(),
                                  Consumer<FollowerFollowingController>(
                                    builder: (context,
                                        followerFollowingController, child) {
                                      following =
                                          followerFollowingController.following;
                                      return message.receiverType == 'user' &&
                                              !following!.any((element) =>
                                                  element.username ==
                                                  messageReceiver) &&
                                              messageReceiver !=
                                                  userController
                                                      .userAbout!.username
                                          ? GestureDetector(
                                              onTap: () =>
                                                  showMoreOptionsDialog(
                                                      context,
                                                      messageReceiver,
                                                      userController),
                                              child: Icon(
                                                Icons.more_horiz,
                                                color: message.unreadFlag
                                                    ? const Color.fromARGB(
                                                        255, 92, 92, 92)
                                                    : const Color.fromARGB(
                                                        255, 156, 156, 156),
                                              ),
                                            )
                                          : const SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  message.subject != null
                                      ? Text(
                                          message.subject ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: message.unreadFlag
                                                ? Colors.black
                                                : const Color.fromARGB(
                                                    255, 156, 156, 156),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  Text(
                                    message.message ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: message.unreadFlag
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 156, 156, 156),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              color: Color.fromARGB(0, 255, 255, 255),
                              height: 1,
                            );
                          },
                        );
                },
              );
            }
          },
        );
      },
    );
  }

  List<Messages> processMessage(List<Messages> messagesList, Messages message) {
    if (message.parentMessageId == null) {
      return [message];
    }
    List<Messages> replies = messagesList
        .where((msg) =>
            msg.parentMessageId != null &&
            msg.parentMessageId == message.parentMessageId)
        .toList();
    Messages msg =
        messagesList.firstWhere((msg) => msg.id == message.parentMessageId);
    replies.add(msg);
    replies.sort((a, b) {
      DateTime dateA = DateTime.parse(a.createdAt!);
      DateTime dateB = DateTime.parse(b.createdAt!);
      return dateA.compareTo(dateB);
    });
    return replies;
  }

  List<Messages> processAllMessage(List<Messages> messagesList) {
    List<Messages> processedMessages = [];
    List<Messages> messages = List.from(messagesList);
    print('di all messages');
    while (messages.isNotEmpty) {
      Messages message = messages.removeAt(0);
      List<Messages> replies = messagesList
          .where((msg) => msg.parentMessageId == message.id)
          .toList();
      messages.removeWhere((msg) => replies.contains(msg));
      replies.add(message);
      replies.sort((a, b) {
        DateTime dateA = DateTime.parse(a.createdAt!);
        DateTime dateB = DateTime.parse(b.createdAt!);
        return dateA.compareTo(dateB);
      });
      replies.last.subject = replies.first.subject;
      processedMessages.add(replies.last);
    }
    processedMessages.sort((a, b) {
      DateTime dateA = DateTime.parse(a.createdAt!);
      DateTime dateB = DateTime.parse(b.createdAt!);
      return dateB.compareTo(dateA);
    });
    return processedMessages;
  }

  void showMoreOptionsDialog(BuildContext context, String? messageReceiver,
      UserController userController) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                  onPressed: () => {
                        Navigator.pop(context),
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Are you sure?'),
                              content: const Text(
                                "You won't see posts or comments from this user.",
                              ),
                              actions: <Widget>[
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.33,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue[900],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      var blockUnblockUserController =
                                          context.read<BlockUnblockUser>();
                                      await blockUnblockUserController
                                          .blockUser(messageReceiver!);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'BLOCK',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.block,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text("Block Account",
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
        });
  }
}

String getDateTimeDifferenceWithLabel(String dateFromDatabaseString) {
  // Parse the string from the database to a DateTime object
  DateTime dateFromDatabase = DateTime.parse(dateFromDatabaseString);

  // Get the current time
  DateTime currentTime = DateTime.now();

  // Calculate the difference between the current time and the database date
  Duration difference = currentTime.difference(dateFromDatabase);

  // Check the difference in years
  if (difference.inDays >= 365) {
    int years = (difference.inDays / 365).floor();
    return '${years}y';
  }

  // Check the difference in days
  else if (difference.inDays > 0) {
    return '${difference.inDays}d';
  }

  // Check the difference in hours
  else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  }

  // Check the difference in minutes
  else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  }

  // Check the difference in seconds
  else if (difference.inSeconds > 0) {
    return '${difference.inSeconds}s';
  }

  // If all differences are 0, return '0 s'
  else {
    return 'now';
  }
}
