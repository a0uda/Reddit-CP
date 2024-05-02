import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/message_item.dart';
import 'package:reddit/widgets/Moderator/desktop_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mod_responsive.dart';
import 'package:reddit/widgets/Moderator/moderators.dart';
import 'package:reddit/widgets/Moderator/moderators_list.dart';
import 'package:reddit/widgets/report_options.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageContent extends StatefulWidget {
  final List<Messages> messages;
  final List<FollowersFollowingItem> following;

  const MessageContent({required this.messages, required this.following});

  @override
  _MessageContentState createState() => _MessageContentState();
}

class _MessageContentState extends State<MessageContent> {
  late List<Messages> messages;
  List<bool> showMessageContent = [];
  late List<FollowersFollowingItem> following;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    messages = List.from(widget.messages);
    showMessageContent.add(false);
    for (int i = 1; i < messages.length; i++) {
      showMessageContent.add(false);
    }
    following = List.from(widget.following);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesOperations>(
      builder: (context, messagesOperations, child) {
        UserController userController = GetIt.instance.get<UserController>();
        TextEditingController messageContentController =
            TextEditingController();
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 242, 242, 242),
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          body: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              Messages message = messages[index];
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: index != 0 && showMessageContent[0] == false
                    ? const SizedBox.shrink()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          index == 0
                              ? Text(
                                  message.subject ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showMessageContent[index] =
                                        !showMessageContent[index];
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      showMessageContent[index]
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_right,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${message.senderType == 'user' ? message.senderUsername : 'r/${message.senderVia}'}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              255, 112, 112, 112),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      ' • ${getDateTimeDifferenceWithLabel(message.createdAt ?? '')}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color:
                                            Color.fromARGB(255, 174, 174, 174),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Consumer<FollowerFollowingController>(
                                builder: (context, followerFollowingController,
                                    child) {
                                  if (followerFollowingController
                                      .following!.isNotEmpty) {
                                    following =
                                        followerFollowingController.following!;
                                  }
                                  return message.receiverType == 'user' &&
                                          !following.any((element) =>
                                              element.username ==
                                              message.senderUsername) &&
                                          message.senderUsername !=
                                              userController.userAbout!.username
                                      ? GestureDetector(
                                          onTap: () => {
                                                showMoreOptionsDialog(
                                                    context,
                                                    message.senderUsername,
                                                    userController)
                                              },
                                          child: const Icon(
                                            Icons.more_horiz,
                                            color:
                                                Color.fromARGB(255, 92, 92, 92),
                                          ))
                                      : const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          showMessageContent[index]
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 17),
                                  child: RichText(
                                    text: TextSpan(
                                      children: message.isInvitation!
                                          ? _parseInvitationMessage(
                                              message.message!)
                                          : _parseMessage(message.message!),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 5),
                        ],
                      ),
              );
            },
          ),
          bottomSheet: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: TextButton(
              onPressed: () => {
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
                                  if (messageContentController
                                      .text.isNotEmpty) {
                                    String? receiverUsername =
                                        messages[0].isSent
                                            ? messages[0].receiverUsername
                                            : messages[0].senderType == 'user'
                                                ? messages[0].senderUsername
                                                : messages[0].senderVia;
                                    String? receiverType = messages[0].isSent
                                        ? messages[0].receiverType
                                        : messages[0].senderType;
                                    bool success = await context
                                        .read<MessagesOperations>()
                                        .replyToMessage(
                                          messages[0].id,
                                          receiverUsername!,
                                          receiverType!,
                                          messageContentController.text,
                                        );
                                    if (success) {
                                      messages.add(Messages(
                                        id: (messages.length + 1).toString(),
                                        senderUsername:
                                            userController.userAbout!.username,
                                        senderType: "user",
                                        receiverUsername: receiverUsername,
                                        receiverType: receiverType,
                                        senderVia: null,
                                        message: messageContentController.text,
                                        createdAt:
                                            DateTime.now().toIso8601String(),
                                        deletedAt: null,
                                        unreadFlag: false,
                                        isSent: true,
                                        isReply: true,
                                        parentMessageId: messages[0].id,
                                        subject: null,
                                        isInvitation: false,
                                      ));
                                      showMessageContent.add(false);
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Message is not sent successfully. This User is no longer available.',
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
                                      const SnackBar(
                                        content: Text(
                                          'Please enter a message.',
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
                            child: TextField(
                              controller: messageContentController,
                              decoration: const InputDecoration(
                                hintText: 'Your message',
                              ),
                              maxLines: null,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(left: 2, right: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: const Color.fromARGB(255, 243, 243, 243),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "Reply to the Message",
                      style: TextStyle(
                        color: Color.fromARGB(255, 112, 112, 112),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<TextSpan> _parseInvitationMessage(String message) {
    final List<TextSpan> spans = [];

    final RegExp regex = RegExp(
      r'(moderators page for \/r\/\S+)',
      caseSensitive: false,
    );

    final Iterable<RegExpMatch> matches = regex.allMatches(message);

    int start = 0;

    for (final match in matches) {
      final link = match.group(0);
      if (start < match.start) {
        spans.add(
          TextSpan(
            text: message.substring(start, match.start),
          ),
        );
      }

      final gestureRecognizer = TapGestureRecognizer()
        ..onTap = () {
          final ModeratorController moderatorController =
              GetIt.instance.get<ModeratorController>();
          print(link!.split(' ')[3].replaceFirst('/r/', ''));
          moderatorController.communityName =
              link.split(' ')[3].replaceFirst('/r/', '');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModResponsive(
                  mobileLayout: Moderators(isInvite: true),
                  desktopLayout: DesktopModTools(
                    index: 4,
                    communityName: moderatorController.communityName,
                    isInvite: true,
                  )),
            ),
          );
        };

      spans.add(
        TextSpan(
          text: link,
          style: TextStyle(
            color: Colors.blue[900],
            decoration: TextDecoration.underline,
          ),
          recognizer: gestureRecognizer,
        ),
      );
      start = match.end;
    }

    if (start < message.length) {
      spans.add(
        TextSpan(
          text: message.substring(start),
        ),
      );
    }

    return spans;
  }

  List<TextSpan> _parseMessage(String message) {
    final List<TextSpan> spans = [];

    final RegExp regex = RegExp(
      r'\b(([\w-]+://?|www[.]|\b|^)[^\s]+\.[^\s]+)',
      caseSensitive: false,
    );

    final Iterable<RegExpMatch> matches = regex.allMatches(message);

    int start = 0;

    for (final match in matches) {
      final link = match.group(0);
      if (start < match.start) {
        spans.add(
          TextSpan(
            text: message.substring(start, match.start),
          ),
        );
      }
      final gestureRecognizer = TapGestureRecognizer()
        ..onTap = () {
          _launchURL(link!);
        };

      spans.add(
        TextSpan(
          text: link,
          style: TextStyle(
            color: Colors.blue[900],
            decoration: TextDecoration.underline,
          ),
          recognizer: gestureRecognizer,
        ),
      );
      start = match.end;
    }

    if (start < message.length) {
      spans.add(
        TextSpan(
          text: message.substring(start),
        ),
      );
    }

    return spans;
  }

  void _launchURL(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'http://$url';
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void showMoreOptionsDialog(
      BuildContext context, String? username, UserController userController) {
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
                                          .blockUser(username!);
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
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).pop(),
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                  child: Column(children: [
                                const ListTile(
                                  leading: Text(
                                    "Submit report",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                const ListTile(
                                  leading: Text(
                                      "Thanks for looking out for yourself"),
                                ),
                                ReportOptions(
                                  postId: "12345",
                                  isUser: true,
                                  username: username!,
                                )
                              ]));
                            })
                      },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.report,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text("Report", style: TextStyle(color: Colors.black))
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
