import 'package:flutter/material.dart';
import 'package:reddit/widgets/Report.dart';
import 'package:reddit/widgets/Video_Player.dart';

class Post extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final String postContent;
  final String postView;
  final String date;
  final String likes;
  final String comments;
  const Post({
    Key? key,
    required this.profileImageUrl,
    required this.name,
    required this.postContent,
    required this.postView,
    required this.date,
    required this.likes,
    required this.comments,
  }) : super(key: key);

  @override
  PostState createState() => PostState();
}

int counter = 0;
bool isLiked = false;

class PostState extends State<Post> {
  bool isHovering = false;
  bool ishovering = false;
  void IncrementCounter() {
    setState(() {
      if (isLiked == false) {
        //like todo
        isLiked = !isLiked;
      }
    });
  }

  void DecrementCounter() {
    setState(() {
      if (isLiked == true) {
        //unlike todo
        isLiked = !isLiked;
      }
    });
  }

  // List of items in our dropdown menu

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        // open this post TODO
      },
      onHover: (value) {
        ishovering = value;
        setState(() {});
      },
      child: Card(
        color: !ishovering
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.primary,
        shadowColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(widget.profileImageUrl),
              ),
              title: Row(
                children: [
                  InkWell(
                    onTap: () => {
                      //go to profile TODO
                    },
                    onHover: (hover) {
                      setState(() {
                        isHovering = hover;
                      });
                    },
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial'),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(0)),
                  Text(
                    widget.date,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 117, 116, 115)),
                  )
                ],
              ),
              trailing: Options(),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.postContent,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial'),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      // Border width
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          shape: BoxShape.rectangle),
                      child: Text("VIDEO") //VideoScreen(),
                      )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  color: Theme.of(context).colorScheme.secondary,
                  highlightColor: Theme.of(context).colorScheme.primary,
                  icon: Icon(Icons.arrow_upward_outlined),
                  onPressed: () {
                    IncrementCounter();
                  },
                ),
                Text(
                  '${widget.likes}',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward_outlined),
                  onPressed: () {
                    DecrementCounter();
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    //comment
                  },
                  icon: Icon(Icons.messenger_outline,
                      color: Theme.of(context).colorScheme.secondary),
                  label: Text(
                    '${widget.comments}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    // Button background color
                    padding: EdgeInsets.all(6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    //shareee
                  },
                  icon: Icon(Icons.file_upload_outlined,
                      color: Theme.of(context).colorScheme.secondary),
                  label: Text(
                    'Share',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    // Button background color
                    padding: EdgeInsets.all(6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
