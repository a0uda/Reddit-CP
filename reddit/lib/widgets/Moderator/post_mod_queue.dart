import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/add_approved_user.dart';
import 'package:reddit/widgets/Moderator/test_badr.dart';

// ignore: must_be_immutable
class PostModQueue extends StatefulWidget {
  // final String profileImage;
  // final String username;
  // final String postTime;
  // bool? notSafeForWork;
  // bool? spoilerFlag;

  // final String postTitle;
  // String? postDescription;
  // String? postContentImage;

  // String? reportReason;

  final BadrTestPostItem post;

  PostModQueue({super.key, required this.post});

  @override
  State<PostModQueue> createState() => _PostModQueueState();
}

class _PostModQueueState extends State<PostModQueue> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  const AddApprovedUser(), //Navigate to Post pagee.. Badrrr
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // showModalBottomSheet(
                //       backgroundColor: Colors.white,
                //       context: context,              modalsheetbottom mohyyyyyyy for user
                //       builder: (BuildContext context) {
                //         return 
                //       },
                //     ),
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.post.profileImage),
                    radius: 13,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.username,
                        style: const TextStyle(
                            height: 0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.post.postTime,
                        style: const TextStyle(color: Colors.grey, height: 0),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      //show options badrrr mohyyyyyyyyyyyyy
                    },
                    icon: const Icon(Icons.more_vert_sharp),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            Row(children: [
              widget.post.notSafeForWork != null
                  ? const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.dangerous_outlined,
                        color: Color(0xFFE00096),
                        size: 18,
                      ),
                    )
                  : const SizedBox(),
              widget.post.notSafeForWork != null
                  ? const Text(
                      "NSFW",
                      style: TextStyle(
                          color: Color(0xFFE00096),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5),
                    )
                  : const SizedBox(),
              widget.post.spoilerFlag != null
                  ? const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.warning,
                        size: 18,
                      ),
                    )
                  : const SizedBox(),
              widget.post.spoilerFlag != null
                  ? const Text(
                      "SPOILER",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.5),
                    )
                  : const SizedBox()
            ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.postTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.post.postDescription ?? ""),
                  ],
                ),
                const Spacer(),
                widget.post.postContentImage != null
                    ? Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: screenSize.width * 0.15,
                        height: screenSize.width < 700
                            ? screenSize.height * 0.1
                            : screenSize.height * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            widget.post.postContentImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            widget.post.reportReason != null
                ? Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.amber[100],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            CupertinoIcons.flag,
                            color: Colors.grey[700],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Text(
                            " ${widget.post.reportReason!}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              color: Colors.grey,
              height: 2,
            )
          ],
        ),
      ),
    );
  }
}
