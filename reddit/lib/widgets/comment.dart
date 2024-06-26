import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/Moderator/modal_for_remals.dart';
import 'package:reddit/widgets/comments_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class Comment extends StatefulWidget {
  final Comments comment;
  int likes;
  bool isSaved;
  bool isComingFromSaved;
  final bool isModInComment;
  Comment({
    super.key,
    required this.comment,
    required this.isSaved,
    this.isComingFromSaved = false,
    required this.likes,
    this.isModInComment = false,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool upVote = false;
  bool downVote = false;

  Color? upVoteColor;
  Color? downVoteColor;

  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();
  final CommentsService commentService = GetIt.instance.get<CommentsService>();
  late SharedPreferences prefs;
  late String username;
  bool spammedFlag = false;
  bool approvedFlag = false;
  bool removedPost = false;

  @override
  void initState() {
    super.initState();
    spammedFlag = widget.comment.moderatorDetails?.spammedFlag ?? false;
    approvedFlag = widget.comment.moderatorDetails?.approvedFlag ?? false;
    removedPost = widget.comment.moderatorDetails?.removedFlag ?? false;
    if (widget.comment.vote == 1) {
      upVote = true;
      upVoteColor = Colors.blue;
    } else if (widget.comment.vote == -1) {
      downVote = true;
      downVoteColor = Colors.red;
    }
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username')!;
  }

  void incrementCounter(String commentId) {
    setState(() {
      if (upVote == false) {
        commentService.upVoteComment(commentId);

        upVoteColor = Colors.blue;
        downVoteColor = Colors.black;

        if (downVote == true) {
          commentService.upVoteComment(commentId);
          downVoteColor = Colors.black;
          widget.likes++;
          downVote = false;
        }
        widget.likes++;
      } else {
        commentService.upVoteComment(commentId);
        upVoteColor = Colors.black;
        widget.likes--;
      }
      upVote = !upVote;
    });
  }

  void decrementCounter(String commentId) {
    setState(() {
      if (downVote == false) {
        commentService.downVoteComment(commentId);
        downVoteColor = Colors.red;
        upVoteColor = Colors.black;
        if (upVote == true) {
          commentService.downVoteComment(commentId);
          upVoteColor = Colors.black;
          upVote = false;
          widget.likes--;
        }
        widget.likes--;
      } else {
        commentService.downVoteComment(commentId);
        downVoteColor = Colors.black;
        widget.likes++;
      }
      downVote = !downVote;
    });
  }

  @override
  Widget build(BuildContext context) {
    String username = userController.userAbout!.username;
    bool isMyComment = (username == widget.comment.username) ? true : false;
    return Card(
      borderOnForeground: true,
      shadowColor: Colors.white,
      color: Colors.white,
      elevation: 2,
      child: GestureDetector(
        onTap: () {
          if (widget.isComingFromSaved) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CommentsWidget(postId: widget.comment.id!)),
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  FutureBuilder<UserAbout>(
                    future: userService.getUserAbout(widget.comment.username!),
                    builder: (BuildContext context,
                        AsyncSnapshot<UserAbout> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        print("el sora");
                        return Text('Error: ${snapshot.error}');
                      } else {
                        print('in comment');
                        print(snapshot.data!);
                        print('username in comment');
                        print(widget.comment.username!);
                        print(snapshot.data!.profilePicture!);
                        if (snapshot.data!.profilePicture == null ||
                            snapshot.data!.profilePicture!.isEmpty) {
                          return const CircleAvatar(
                            radius: 15,
                            backgroundImage: AssetImage('images/Greddit.png'),
                          );
                        } else {
                          return CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data!.profilePicture!),
                            radius: 15,
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.comment.username!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '  • ${formatDateTime(widget.comment.createdAt!)}',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 117, 116, 115)),
                  ),
                  widget.isModInComment ? Spacer() : const SizedBox(),
                  (widget.isModInComment)
                      ? (spammedFlag)
                          ? Icon(
                              Icons.free_cancellation_outlined,
                              color: Colors.red[800],
                            )
                          : (approvedFlag)
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green[600],
                                )
                              : (removedPost)
                                  ? Icon(
                                      Icons.delete_outline,
                                      color: Colors.red[800],
                                    )
                                  : const SizedBox()
                      : const SizedBox(),
                  widget.isModInComment
                      ? ElevatedButton.icon(
                          onPressed: () async {
                            var objection =
                                context.read<handleObjectionProvider>();
                            showOptions(
                              communityName: widget.comment.subredditName ?? "",
                              context: context,
                              isApproved: approvedFlag ?? false,
                              isRemoved: removedPost ?? false,
                              removedAsSpam: spammedFlag ?? false,
                              handleRemoveAsSpam: () async {
                                await objection.objectItem(
                                    id: widget.comment.id!,
                                    itemType: "comment",
                                    objectionType: "spammed",
                                    communityName:
                                        widget.comment.subredditName ?? "");
                                setState(() {
                                  spammedFlag = true;
                                  approvedFlag = false;
                                  removedPost = false;
                                });
                              },
                              handleApprove: () async {
                                var queuesProvider =
                                    context.read<handleUnmoderatedProvider>();
                                await queuesProvider.handleUnmoderated(
                                  objectionType: "unmoderated",
                                  itemType: 'comment',
                                  action: 'approve',
                                  communityName:
                                      widget.comment.subredditName ?? "",
                                  itemID: widget.comment.id ?? "",
                                );
                                setState(() {
                                  approvedFlag = true;
                                  spammedFlag = false;
                                  removedPost = false;
                                });
                              },
                              handleRemovePost: (removalReaosnTitle) async {
                                var umoderated =
                                    context.read<handleUnmoderatedProvider>();
                                await umoderated.handleUnmoderated(
                                  objectionType: "unmoderated",
                                  itemType: 'comment',
                                  action: 'remove',
                                  communityName:
                                      widget.comment.subredditName ?? "",
                                  itemID: widget.comment.id ?? "",
                                );

                                setState(() {
                                  approvedFlag = false;
                                  spammedFlag = false;
                                  removedPost = true;
                                });
                              },
                            );
                          },
                          icon: Icon(
                            Icons.shield_outlined,
                            color: Colors.black,
                          ),
                          label: SizedBox(),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.comment.description!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Arial',
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setMenuState) {
                      return PopupMenuButton<int>(
                        icon: const Icon(Icons.more_horiz),
                        itemBuilder: (context) => [
                          (!widget.isSaved)
                              ? PopupMenuItem(
                                  value: 1,
                                  onTap: () {
                                    userController.saveComment(
                                        username, widget.comment.id!);
                                    setMenuState(() {
                                      widget.isSaved = true;
                                    });
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.save),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Save")
                                    ],
                                  ),
                                )
                              : PopupMenuItem(
                                  value: 1,
                                  onTap: () {
                                    var commentController =
                                        context.read<SaveComment>();
                                    commentController.unsaveComment(
                                        username, widget.comment.id!);
                                    setMenuState(() {
                                      widget.isSaved = false;
                                    });
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.save),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Unsave")
                                    ],
                                  ),
                                ),
                          if (isMyComment)
                            PopupMenuItem(
                              value: 2,
                              child: const Row(
                                children: [
                                  Icon(Icons.flag),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Edit")
                                ],
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  builder: (BuildContext context) {
                                    var editedTextController =
                                        TextEditingController(
                                            text: widget.comment.description);
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: Scaffold(
                                        appBar: AppBar(
                                          automaticallyImplyLeading: false,
                                          title: Row(
                                            children: [
                                              const Spacer(),
                                              Text(
                                                'Edit your comment',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.deepOrange[400]),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                        body: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                TextFormField(
                                                  controller:
                                                      editedTextController,
                                                  minLines: 10,
                                                  maxLines: null,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.deepOrange[400],
                                                  ),
                                                  child: const Text('Save'),
                                                  onPressed: () async {
                                                    await commentService
                                                        .EditComment(
                                                            widget.comment.id!,
                                                            editedTextController
                                                                .text);
                                                    setState(() {
                                                      widget.comment
                                                              .description =
                                                          editedTextController
                                                              .text;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      );
                    },
                  ),
                  IconButton(
                    iconSize: 20,
                    highlightColor: Theme.of(context).colorScheme.primary,
                    icon: const Icon(Icons.reply_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 20,
                    color: upVoteColor,
                    highlightColor: Theme.of(context).colorScheme.primary,
                    icon: const Icon(Icons.arrow_upward_sharp),
                    onPressed: () {
                      incrementCounter(widget.comment.id!);
                    },
                  ),
                  Text(
                    (widget.likes).toString(),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  IconButton(
                    iconSize: 20,
                    color: downVoteColor,
                    icon: const Icon(Icons.arrow_downward_outlined),
                    onPressed: () {
                      decrementCounter(widget.comment.id!);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showOptions({
  required BuildContext context,
  bool isApproved = false,
  bool isRemoved = false,
  bool removedAsSpam = false,
  required String communityName,
  required final Function() handleRemoveAsSpam,
  required final Function() handleApprove,
  required final Function(String title) handleRemovePost,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.check,
                color: isApproved ? Colors.grey : Colors.black,
              ),
              title: Text(
                'Approve comment',
                style:
                    TextStyle(color: isApproved ? Colors.grey : Colors.black),
              ),
              onTap: isApproved
                  ? null
                  : () {
                      //approve
                      handleApprove();
                      Navigator.of(context).pop();
                    },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.xmark,
                color: isRemoved ? Colors.grey : Colors.black,
              ),
              title: Text(
                'Remove comment',
                style: TextStyle(color: isRemoved ? Colors.grey : Colors.black),
              ),
              onTap: isRemoved
                  ? null
                  : () async {
                      //remove
                      await showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (BuildContext context) {
                          return ModalForReasons(
                            handleRemove: (value) {
                              handleRemovePost(value);
                              print("TITLE");
                              print(value);
                            },
                            communityName: "badrmoderatorrrr",
                          );
                        },
                      );
                      Navigator.of(context).pop();
                    },
            ),
            ListTile(
              leading: Icon(
                Icons.free_cancellation_outlined,
                color: removedAsSpam ? Colors.grey : Colors.black,
              ),
              title: Text(
                'Remove as spam',
                style: TextStyle(
                    color: removedAsSpam ? Colors.grey : Colors.black),
              ),
              onTap: removedAsSpam
                  ? null
                  : () {
                      handleRemoveAsSpam();
                      Navigator.of(context).pop();
                      //as spam
                    },
            ),
            // ListTile(
            //   leading: Icon(
            //     CupertinoIcons.lock,
            //     color: lockComments ? Colors.grey : Colors.black,
            //   ),
            //   title: Text(
            //     lockComments ? 'Unlock comments' : 'Lock Comments',
            //   ),
            //   onTap: () {
            //     //lock comments
            //     handleLock(!lockComments);
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        ),
      );
    },
  );
}
