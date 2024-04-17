import 'package:flutter/material.dart';
import 'package:reddit/widgets/comments_desktop.dart';

class CollapsePost extends StatefulWidget {
  // final String? profileImageUrl;
  final String name;
  final String title;
  final String date;
  final String id;
  final String communityName;
  final bool isLocked;
  final bool isNSFW;
  final bool isSpoiler;

  CollapsePost({
    super.key,
    required this.id,
    // required this.profileImageUrl,
    required this.name,
    required this.title,
    required this.date,
    required this.communityName,
    required this.isLocked,
    required this.isNSFW,
    required this.isSpoiler,
  });

  @override
  State<CollapsePost> createState() => _CollapsePostState();
}

class _CollapsePostState extends State<CollapsePost> {
  String getPostTitle() {
    if (widget.isNSFW) {
      return 'NSFW Content';
    } else if (widget.isSpoiler) {
      return 'Spoiler Content';
    } else {
      return widget.title;
    }
  }

  Icon getPostIcon() {
    if (widget.isNSFW) {
      return const Icon(Icons.warning);
    } else if (widget.isSpoiler) {
      return const Icon(Icons.visibility_off);
    } else {
      return const Icon(Icons.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('images/reddit-logo.png'),
            ),
            title: Text(widget.communityName),
            subtitle: Text(widget.name),
            trailing: Text(widget.date.substring(0, 10)),
            onTap: () => {
              // open this post TODO
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentsDesktop(
                      postId: widget.id), // pass the post ID here
                ),
              ),
            },
          ),
          getPostIcon(),
          Text(getPostTitle()),
        ],
      ),
    );
  }
}
