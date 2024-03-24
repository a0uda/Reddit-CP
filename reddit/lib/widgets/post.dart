import 'package:flutter/material.dart';
import 'package:reddit/widgets/report.dart';
import 'package:reddit/widgets/video_player.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Services/post_service.dart';
import 'package:reddit/widgets/poll_widget.dart';

class Post extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final String postContent;
  final String postView;
  final String date;
  final String likes;
  final String comments;
  final String? imageUrl;
  final String? linkUrl;
  final String? videoUrl;
  final PollItem? poll;

  const Post({
    Key? key,
    required this.profileImageUrl,
    required this.name,
    required this.postContent,
    required this.postView,
    required this.date,
    required this.likes,
    required this.comments,
    this.imageUrl,
    this.linkUrl,
    this.videoUrl,
    this.poll,
  });

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
    if (widget.imageUrl != null) {
      print(widget.imageUrl);
    }
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.postContent,
                      style: const TextStyle(fontSize: 16, fontFamily: 'Arial'),
                    ),
                  ),
                  if (widget.imageUrl != null) Image.network(widget.imageUrl!),
                  if (widget.linkUrl != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        child: Text(
                          widget.linkUrl!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Arial',
                            color: Colors.blue,
                          ),
                        ),
                        //TODO: open link
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse(widget.linkUrl!))) {
                            await launchUrl(Uri.parse(widget.linkUrl!));
                          } else {
                            const AlertDialog(
                              title: Text('Error'),
                              content: Text('Could not open link'),
                            );
                          }
                        },
                      ),
                    ),
                  if (widget.videoUrl != null)
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        // Border width
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            shape: BoxShape.rectangle),
                        child: Text("VIDEO") //TODO: VideoScreen(),
                        ),
                  if (widget.poll != null)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: PollView(
                        question: widget.poll!.question,
                        options: widget.poll!.options
                            .map((option) => {option: 0.0})
                            .toList(),
                      ),
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
