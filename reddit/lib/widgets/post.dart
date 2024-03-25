import 'package:flutter/material.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/widgets/report.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reddit/widgets/video_player.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reddit/widgets/poll_widget.dart';
import 'package:reddit/Models/poll_item.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/user_service.dart';

class Post extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final String title;
  final String postContent;
  final String date;
  final String likes;
  final String comments;
  final String? imageUrl;
  final String? linkUrl;
  final String? videoUrl;
  final PollItem? poll;
  final int? id;
  final String communityName;

  const Post({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.title,
    required this.postContent,
    required this.date,
    required this.likes,
    required this.comments,
    this.imageUrl,
    this.linkUrl,
    this.videoUrl,
    this.poll,
    this.id,
    required this.communityName,
  });

  @override
  PostState createState() => PostState();
}

int counter = 0;
bool upVote = false;
bool downVote = false;

class PostState extends State<Post> {
  bool isHovering = false;
  bool ishovering = false;
  void incrementCounter() {
    setState(() {
      counter++;
      // if (isLiked == false) {
      //like todo
      upVote = !upVote;

      //}
    });
  }

  void decrementCounter() {
    setState(() {
      // if (isLiked == true) {
      //unlike todo
      downVote = !downVote;
      // }
    });
  }

  // List of items in our dropdown menu

  @override
  Widget build(BuildContext context) {
    UserService userService = GetIt.instance.get<UserService>();
    UserController userController = GetIt.instance.get<UserController>();
    String userType;
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
              title: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => {
                        //TODO: go to community
                      },
                      onHover: (hover) {
                        setState(() {
                          isHovering = hover;
                        });
                      },
                      child: Text(
                        widget.communityName,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arial'),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => {
                          userType =
                              userController.userAbout!.username == widget.name
                                  ? 'me'
                                  : 'other',
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                userService.getUserAbout(widget.name),
                                userType,
                                null,
                              ),
                            ),
                          ),
                        },
                        onHover: (hover) {
                          setState(() {
                            isHovering = hover;
                          });
                        },
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              fontFamily: 'Arial'),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(0)),
                      Text(
                        '  • ${widget.date.substring(0, 10)}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 117, 116, 115)),
                      )
                    ],
                  ),
                ],
              ),
              trailing: const Options(),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 18,
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
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse(widget.linkUrl!))) {
                            await launchUrl(Uri.parse(widget.linkUrl!));
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Invalid Link'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                                color: Colors.deepOrange),
                                          )),
                                    ],
                                  );
                                });
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
                        child: const Text("VIDEO") //TODO: VideoScreen(),
                        ),
                  if (widget.poll != null)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: PollView(
                        id: widget.id!,
                        question: widget.poll!.question,
                        options: widget.poll!.options
                            .asMap()
                            .map((index, option) => MapEntry(index,
                                {option: widget.poll!.votes[index].toDouble()}))
                            .values
                            .toList(),
                        option1UserVotes: widget.poll!.option1Votes,
                        option2UserVotes: widget.poll!.option2Votes,
                        currentUser: userController.userAbout!.username,
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 40.0, // Set the height
                    child: Card(
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            iconSize: 20,
                            color: Theme.of(context).colorScheme.secondary,
                            highlightColor:
                                Theme.of(context).colorScheme.primary,
                            icon: const Icon(Icons.arrow_upward_sharp),
                            onPressed: () {
                              incrementCounter();
                            },
                          ),
                          Text(
                            widget.likes,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.arrow_downward_outlined),
                            onPressed: () {
                              decrementCounter();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0, // Set the height
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          //comment
                        },
                        icon: Icon(Icons.messenger_outline,
                            color: Theme.of(context).colorScheme.secondary),
                        label: Text(
                          widget.comments,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          // Button background color
                          padding: const EdgeInsets.all(6),
                        ),
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
                      padding: const EdgeInsets.all(6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
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
