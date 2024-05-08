import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/message_item.dart';
import 'package:reddit/Models/moderator_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/Community/community_responsive.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';
import 'package:reddit/widgets/best_listing.dart';
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
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  @override
  Widget build(BuildContext context) {
    var followerfollowingcontroller =
        context.read<FollowerFollowingController>();
    var myProvider = context.read<GetMessagesController>();

    return Consumer<MessagesOperations>(
      builder: (context, messagesOperations, child) {
        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            myProvider.getUserMessages(),
            userController.getFollowing(userController.userAbout!.username)
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
                builder: (context, blockUnblockUser, child) {
                  List<Messages> messagesList = snapshot.data![0];
                  List<FollowersFollowingItem>? following =
                      followerfollowingcontroller.following;
                  List<Messages> originalMessagesList = List.from(messagesList);
                  if (messagesList.isNotEmpty) {
                    messagesList = processAllMessage(messagesList);
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      messagesList = await myProvider.getUserMessages();
                      following = followerfollowingcontroller.following;
                      originalMessagesList = List.from(messagesList);
                      if (messagesList.isNotEmpty) {
                        messagesList = processAllMessage(messagesList);
                      }
                    },
                    child: Consumer<GetMessagesController>(
                      builder: (context, getUserMessages, child) {
                        return messagesList.isEmpty
                            ? const Center(
                                child: Text('No messages yet!'),
                              )
                            : ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: messagesList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Messages message = messagesList[index];
                                  List<Messages> replies = processMessage(
                                      originalMessagesList, message);
                                  String? messageReceiver = message.isSent
                                      ? (message.receiverType == 'user'
                                          ? message.receiverUsername ?? ''
                                          : message.receiverUsername)
                                      : (message.senderType == 'user'
                                          ? message.senderUsername
                                          : message.senderVia);
                                  String? receiverType = message.isSent
                                      ? message.receiverType
                                      : message.senderType;
                                  return ListTile(
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => (MessageContent(
                                            messages: replies,
                                            following: following!,
                                          )),
                                        ),
                                      );
                                      await messagesOperations
                                          .markonAsRead(replies);
                                    },
                                    tileColor: Colors.white,
                                    title: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (messageReceiver != 'reddit') {
                                              if (receiverType == 'user') {
                                                var userType = userController
                                                            .userAbout!
                                                            .username ==
                                                        messageReceiver
                                                    ? 'me'
                                                    : 'other';
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FutureBuilder<
                                                            UserAbout?>(
                                                      future: userService
                                                          .getUserAbout(
                                                              messageReceiver!),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Container(
                                                            color: Colors.white,
                                                            child:
                                                                const SizedBox(
                                                                    height: 30,
                                                                    width: 30,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    )),
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        } else {
                                                          return ProfileScreen(
                                                            snapshot.data,
                                                            userType,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                List<CommunityBackend>
                                                    moderatedCammunities =
                                                    userController.userAbout!
                                                        .moderatedCommunities!;
                                                bool isMod = false;
                                                if (moderatedCammunities.any(
                                                        (element) =>
                                                            element.name ==
                                                            messageReceiver) ==
                                                    true) {
                                                  isMod = true;
                                                } else {
                                                  isMod = false;
                                                }
                                                var moderatorProvider = context
                                                    .read<ModeratorProvider>();
                                                if (isMod) {
                                                  await moderatorProvider
                                                      .getModAccess(
                                                          userController
                                                              .userAbout!
                                                              .username,
                                                          messageReceiver!);
                                                } else {
                                                  moderatorProvider
                                                          .moderatorController
                                                          .modAccess =
                                                      ModeratorItem(
                                                          everything: false,
                                                          managePostsAndComments:
                                                              false,
                                                          manageSettings: false,
                                                          manageUsers: false,
                                                          username:
                                                              userController
                                                                  .userAbout!
                                                                  .username);
                                                }
                                                //IS MOD HENA.
                                                // IS MOD HENA
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        (CommunityLayout(
                                                      desktopLayout:
                                                          DesktopCommunityPage(
                                                              isMod: isMod,
                                                              communityName:
                                                                  messageReceiver!),
                                                      mobileLayout:
                                                          MobileCommunityPage(
                                                        isMod: isMod,
                                                        communityName:
                                                            messageReceiver,
                                                      ),
                                                    )),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: Text(
                                            "${message.isSent ? message.receiverType == 'user' ? message.receiverUsername ?? '' : 'r/${message.receiverUsername}' : message.senderType == 'user' ? message.senderUsername : 'r/${message.senderVia}'}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: messageReceiver ==
                                                        'reddit'
                                                    ? Colors.orange[900]
                                                    : message.unreadFlag &&
                                                            !message.isSent
                                                        ? Colors.black
                                                        : const Color.fromARGB(
                                                            255, 112, 112, 112),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        messageReceiver == 'reddit'
                                            ? Brand(
                                                Brands.reddit,
                                                size: 20,
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          ' • ${getDateTimeDifferenceWithLabel(message.createdAt ?? '')}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 174, 174, 174),
                                          ),
                                        ),
                                        const Spacer(),
                                        Consumer<FollowerFollowingController>(
                                          builder: (context,
                                              followerFollowingController,
                                              child) {
                                            following =
                                                followerFollowingController
                                                    .following;
                                            return message.receiverType ==
                                                        'user' &&
                                                    !following!.any((element) =>
                                                        element.username ==
                                                        messageReceiver) &&
                                                    messageReceiver !=
                                                        userController
                                                            .userAbout!
                                                            .username &&
                                                    messageReceiver !=
                                                        'reddit' &&
                                                    receiverType == 'user'
                                                ? GestureDetector(
                                                    onTap: () =>
                                                        showMoreOptionsDialog(
                                                            context,
                                                            messageReceiver,
                                                            userController),
                                                    child: Icon(
                                                      Icons.more_horiz,
                                                      color: message
                                                                  .unreadFlag &&
                                                              !message.isSent
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 92, 92, 92)
                                                          : const Color
                                                              .fromARGB(255,
                                                              156, 156, 156),
                                                    ),
                                                  )
                                                : const SizedBox.shrink();
                                          },
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        message.subject != null
                                            ? Text(
                                                message.subject ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: message.unreadFlag &&
                                                          !message.isSent
                                                      ? Colors.black
                                                      : const Color.fromARGB(
                                                          255, 156, 156, 156),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        Text(
                                          messageReceiver != 'reddit'
                                              ? message.message ?? ''
                                              : 'Tips to get started ➡️',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: message.unreadFlag &&
                                                    !message.isSent
                                                ? Colors.black
                                                : const Color.fromARGB(
                                                    255, 156, 156, 156),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    color: Color.fromARGB(0, 255, 255, 255),
                                    height: 1,
                                  );
                                },
                              );
                      },
                    ),
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
    for (var message in messagesList) {
      if (message.parentMessageId == null) {
        List<Messages> replies =
            messages.where((msg) => msg.parentMessageId == message.id).toList();
        replies.add(message);

        messages.removeWhere((msg) => replies.contains(msg));
        replies.sort((a, b) {
          DateTime dateA = DateTime.parse(a.createdAt!);
          DateTime dateB = DateTime.parse(b.createdAt!);
          return dateA.compareTo(dateB);
        });
        replies.last.subject = replies.first.subject;
        processedMessages.add(replies.last);
      }
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
