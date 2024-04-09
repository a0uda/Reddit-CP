import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/test_files/test_posts.dart';
import 'package:reddit/widgets/post.dart';

class CommentsWidget extends StatefulWidget {
  final Comments comment;

  const CommentsWidget({Key? key, required this.comment}) : super(key: key);

  @override
  State<CommentsWidget> createState() => CommentsWidgetState();
}

class CommentsWidgetState extends State<CommentsWidget> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = GetIt.instance.get<UserController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                      userController.userAbout!.profilePicture ??
                          'images/Greddit.png'),
                ),
                const SizedBox(
                    width:
                        10), // Add some space between the picture and the username
                Text(
                  widget.comment.username!,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial'),
                ),
              ],
            ),
          ),
          //the comments body
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              widget.comment.description!,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Arial'),
              textAlign: TextAlign.left,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  iconSize: 20,
                  highlightColor: Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.open_in_new_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: 20,
                  highlightColor: Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.reply_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  iconSize: 20,
                  //color: upVoteColor,
                  highlightColor: Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.arrow_upward_sharp),
                  onPressed: () {
                    // incrementCounter();
                  },
                ),
                Text(
                  widget.comment.upvotesCount.toString(),
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  // color: downVoteColor,
                  icon: const Icon(Icons.arrow_downward_outlined),
                  onPressed: () {
                    // decrementCounter();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
