import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/Services/user_service.dart';
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
  Comment({
    super.key,
    required this.comment,
    required this.isSaved,
    this.isComingFromSaved = false,
    required this.likes,
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

  @override
  void initState() {
    super.initState();
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
        commentService.downVoteComment(commentId);
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
        commentService.upVoteComment(commentId);
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
                                  builder: (BuildContext context) {
                                    var editedTextController =
                                        TextEditingController(
                                            text: widget.comment.description);
                                    return Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Edit your comment',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Colors.deepOrange[400]),
                                            ),
                                            TextFormField(
                                              controller: editedTextController,
                                              minLines: 10,
                                              maxLines: null,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
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
                                                  widget.comment.description =
                                                      editedTextController.text;
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
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
