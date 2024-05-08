import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/widgets/comments_desktop.dart';

// ignore: must_be_immutable
class PostModQueue extends StatefulWidget {
  final QueuesPostItem post;
  final String queueType;

  PostModQueue({super.key, required this.post, required this.queueType});

  @override
  State<PostModQueue> createState() => _PostModQueueState();
}

class _PostModQueueState extends State<PostModQueue> {
  final moderatorController = GetIt.instance.get<ModeratorController>();

  bool? isMuted;
  bool? isApproved;
  bool? isBanned;

  String? removalReasons;
  String? reportedReason;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var QueuesProvider = context.read<handleObjectionProvider>();
    var QueuesUnmoderatedProvider = context.read<handleUnmoderatedProvider>();

    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CommentsDesktop(
                postId: widget.post.postID,
              ),
              //Navigate to Post pagee.. Badrrr
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        margin:
                            const EdgeInsets.only(left: 8, top: 16, right: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.post.profilePicture),
                                radius: 24,
                              ),
                              title: Text(
                                widget.post.username,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                "u/${widget.post.username}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 113, 113, 113),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(CupertinoIcons.nosign),
                                    title: Text(isMuted != null
                                        ? 'Mute user'
                                        : 'Unmute User'),
                                    onTap: () {},
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                    thickness: 1,
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.check),
                                    title: Text(isApproved != null
                                        ? 'Approve user'
                                        : 'Unapprove User'),
                                    onTap: () {},
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                    thickness: 1,
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.gavel,
                                      color: Color.fromARGB(255, 149, 9, 38),
                                    ),
                                    title: Text(
                                      isBanned != null
                                          ? 'Ban user'
                                          : 'Unban User',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 149, 9, 38)),
                                    ),
                                    onTap: () {},
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.post.profilePicture),
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
                        widget.post.createdAt,
                        style: const TextStyle(color: Colors.grey, height: 0),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 8, top: 16, right: 8),
                              child: Column(
                                // Column ely feeh kol el modal bottom sheet
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    // column 3shan icon w tahteeh el text
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: Border.all(
                                                        color:
                                                            Colors.transparent,
                                                        width: 1),
                                                    color: const Color.fromARGB(
                                                        255, 237, 237, 237),
                                                  ),
                                                  child:
                                                      const Icon(Icons.check)),
                                              title: const Text(
                                                'Approve',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              onTap: () async {
                                                var itemType;
                                                if (widget
                                                    .post.postInCommunityFlag) {
                                                  itemType = 'post';
                                                } else {
                                                  itemType = 'post';
                                                }
                                                if (widget.queueType ==
                                                    'unmoderated') {
                                                  print(
                                                      'ana hena bab3at request');
                                                  print(widget.queueType);
                                                  print(itemType);
                                                  print(widget.post.postID);
                                                  await QueuesUnmoderatedProvider
                                                      .handleUnmoderated(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: itemType,
                                                    action: 'approve',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                } else {
                                                  await QueuesProvider
                                                      .handleObjection(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: itemType,
                                                    action: 'approve',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                }
                                              },
                                            ),
                                            ListTile(
                                              leading: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: Border.all(
                                                        color:
                                                            Colors.transparent,
                                                        width: 1),
                                                    color: const Color.fromARGB(
                                                        255, 237, 237, 237),
                                                  ),
                                                  child:
                                                      const Icon(Icons.close)),
                                              title: const Text(
                                                'Remove',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              onTap: () async {
                                                var itemType;
                                                if (widget
                                                    .post.postInCommunityFlag) {
                                                  itemType = 'post';
                                                } else {
                                                  itemType = 'comment';
                                                }
                                                if (widget.queueType ==
                                                    'unmoderated') {
                                                  await QueuesUnmoderatedProvider
                                                      .handleUnmoderated(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: itemType,
                                                    action: 'remove',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                } else {
                                                  await QueuesProvider
                                                      .handleObjection(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: itemType,
                                                    action: 'remove',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert_sharp),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            Row(children: [
              widget.post.nsfwFlag
                  ? const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.dangerous_outlined,
                        color: Color(0xFFE00096),
                        size: 18,
                      ),
                    )
                  : const SizedBox(),
              widget.post.nsfwFlag
                  ? const Text(
                      "NSFW",
                      style: TextStyle(
                          color: Color(0xFFE00096),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5),
                    )
                  : const SizedBox(),
              widget.post.spoilerFlag
                  ? const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.warning,
                        size: 18,
                      ),
                    )
                  : const SizedBox(),
              widget.post.spoilerFlag
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
                    Text(widget.post.postDescription),
                  ],
                ),
                const Spacer(),
                widget.post.queuePostImage.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: screenSize.width * 0.15,
                        height: screenSize.width < 700
                            ? screenSize.height * 0.1
                            : screenSize.height * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            widget.post.queuePostImage[0].imagePath,
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
            widget.queueType == 'removed'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.5),
                            color: const Color.fromARGB(255, 246, 204, 212),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 13,
                            color: Color.fromARGB(255, 169, 100, 75),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        widget.post.moderatorDetails.removed.type != ""
                            ? Text(
                                " Removed: ${widget.post.moderatorDetails.removed.type}",
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 170, 170, 170),
                                    fontSize: 14),
                              )
                            : Text(
                                'Removed',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: const Color.fromARGB(
                                        255, 170, 170, 170)),
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  )
                : (widget.queueType == 'reported'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        child: IntrinsicWidth(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromARGB(255, 254, 244, 190),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.flag,
                                  size: 20,
                                  color: Color.fromARGB(255, 93, 79, 20),
                                  weight: 500,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                widget.post.moderatorDetails.reported.type != ""
                                    ? Text(
                                        " Reported: ${widget.post.moderatorDetails.reported.type}",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 170, 170, 170),
                                            fontSize: 14),
                                      )
                                    : Text(
                                        'Reported',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                255, 170, 170, 170)),
                                      ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()),
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

class CommentsModQueue extends StatefulWidget {
  const CommentsModQueue(
      {super.key, required this.post, required this.queueType});
  final QueuesPostItem post;
  final String queueType;

  @override
  State<CommentsModQueue> createState() => _CommentsModQueueState();
}

class _CommentsModQueueState extends State<CommentsModQueue> {
  final moderatorController = GetIt.instance.get<ModeratorController>();

  bool? isMuted;
  bool? isApproved;
  bool? isBanned;

  String? removalReasons;
  String? reportedReason;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var QueuesProvider = context.read<handleObjectionProvider>();
    var QueuesUnmoderatedProvider = context.read<handleUnmoderatedProvider>();

    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CommentsDesktop(
                postId: widget.post.postID,
              ),
              //Navigate to Post pagee.. Badrrr
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        margin:
                            const EdgeInsets.only(left: 8, top: 16, right: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.post.profilePicture),
                                radius: 24,
                              ),
                              title: Text(
                                widget.post.username,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                "u/${widget.post.username}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 113, 113, 113),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(CupertinoIcons.nosign),
                                    title: Text(isMuted != null
                                        ? 'Mute user'
                                        : 'Unmute User'),
                                    onTap: () {},
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                    thickness: 1,
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.check),
                                    title: Text(isApproved != null
                                        ? 'Approve user'
                                        : 'Unapprove User'),
                                    onTap: () {},
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                    thickness: 1,
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.gavel,
                                      color: Color.fromARGB(255, 149, 9, 38),
                                    ),
                                    title: Text(
                                      isBanned != null
                                          ? 'Ban user'
                                          : 'Unban User',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 149, 9, 38)),
                                    ),
                                    onTap: () {},
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.post.profilePicture),
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
                        widget.post.createdAt,
                        style: const TextStyle(color: Colors.grey, height: 0),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 8, top: 16, right: 8),
                              child: Column(
                                // Column ely feeh kol el modal bottom sheet
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    // column 3shan icon w tahteeh el text
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: Border.all(
                                                        color:
                                                            Colors.transparent,
                                                        width: 1),
                                                    color: const Color.fromARGB(
                                                        255, 237, 237, 237),
                                                  ),
                                                  child:
                                                      const Icon(Icons.check)),
                                              title: const Text(
                                                'Approve',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              onTap: () async {
                                                var itemType;
                                                if (widget
                                                    .post.postInCommunityFlag) {
                                                  itemType = 'post';
                                                } else {
                                                  itemType = 'comment';
                                                }
                                                if (widget.queueType ==
                                                    'unmoderated') {
                                                  print(
                                                      'ana hena bab3at request');
                                                  print(widget.queueType);
                                                  print(itemType);
                                                  print(widget.post.postID);

                                                  await QueuesUnmoderatedProvider
                                                      .handleUnmoderated(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: itemType,
                                                    action: 'approve',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                } else {
                                                  await QueuesProvider
                                                      .handleObjection(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: itemType,
                                                    action: 'approve',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                }
                                              },
                                            ),
                                            ListTile(
                                              leading: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: Border.all(
                                                        color:
                                                            Colors.transparent,
                                                        width: 1),
                                                    color: const Color.fromARGB(
                                                        255, 237, 237, 237),
                                                  ),
                                                  child:
                                                      const Icon(Icons.close)),
                                              title: const Text(
                                                'Remove',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              onTap: () async {
                                                var itemType;
                                                if (widget
                                                    .post.postInCommunityFlag) {
                                                  itemType = 'post';
                                                } else {
                                                  itemType = 'comment';
                                                }
                                                if (widget.queueType ==
                                                    'unmoderated') {
                                                  await QueuesUnmoderatedProvider
                                                      .handleUnmoderated(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: itemType,
                                                    action: 'remove',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                } else {
                                                  await QueuesProvider
                                                      .handleObjection(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: itemType,
                                                    action: 'remove',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                  itemID: widget.post.postID,);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert_sharp),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            Row(children: [
              widget.post.nsfwFlag
                  ? const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.dangerous_outlined,
                        color: Color(0xFFE00096),
                        size: 18,
                      ),
                    )
                  : const SizedBox(),
              widget.post.nsfwFlag
                  ? const Text(
                      "NSFW",
                      style: TextStyle(
                          color: Color(0xFFE00096),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5),
                    )
                  : const SizedBox(),
              widget.post.spoilerFlag
                  ? const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.warning,
                        size: 18,
                      ),
                    )
                  : const SizedBox(),
              widget.post.spoilerFlag
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
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: 4,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 110, 200),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(widget.post.postDescription)
                    ]),
                  ],
                ),
                const Spacer(),
                widget.post.queuePostImage.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: screenSize.width * 0.15,
                        height: screenSize.width < 700
                            ? screenSize.height * 0.1
                            : screenSize.height * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            widget.post.queuePostImage[0].imagePath,
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
            widget.queueType == 'removed'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.5),
                            color: const Color.fromARGB(255, 246, 204, 212),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 13,
                            color: Color.fromARGB(255, 169, 100, 75),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        widget.post.moderatorDetails.removed.type != ""
                            ? Text(
                                " Removed: ${widget.post.moderatorDetails.removed.type}",
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 170, 170, 170),
                                    fontSize: 14),
                              )
                            : Text(
                                'Removed',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: const Color.fromARGB(
                                        255, 170, 170, 170)),
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  )
                : (widget.queueType == 'reported'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        child: IntrinsicWidth(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color.fromARGB(255, 254, 244, 190),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.flag,
                                  size: 20,
                                  color: Color.fromARGB(255, 93, 79, 20),
                                  weight: 500,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                widget.post.moderatorDetails.reported.type != ""
                                    ? Text(
                                        " Reported: ${widget.post.moderatorDetails.reported.type}",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 170, 170, 170),
                                            fontSize: 14),
                                      )
                                    : Text(
                                        'Reported',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                255, 170, 170, 170)),
                                      ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()),
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
