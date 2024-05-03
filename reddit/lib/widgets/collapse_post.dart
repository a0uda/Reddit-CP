import 'package:flutter/material.dart';
import 'package:reddit/widgets/comments_desktop.dart';

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
            trailing: Text(
                        ' ${formatDateTime(widget.date)}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 117, 116, 115)),
                      ),
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
