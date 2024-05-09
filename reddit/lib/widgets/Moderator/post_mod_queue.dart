import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Services/post_service.dart';
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
  bool? isApprovedUser;
  bool? isBanned;
  bool isRemoved = false;
  bool isApproved = false;

  String? removalReasons;
  String? reportedReason;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var QueuesProvider = context.read<handleObjectionProvider>();
    var QueuesUnmoderatedProvider = context.read<handleUnmoderatedProvider>();
    var QueuesEditItemProvider = context.read<handleEditItemProvider>();

    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CommentsDesktop(
                postId: widget.post.postID,
                isModInComment: true,
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
                                    title: Text(isApprovedUser != null
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
                                                if (widget.queueType ==
                                                    'unmoderated') {
                                                  print(
                                                      'ana hena bab3at request');
                                                  print(widget.queueType);
                                                  print('post');
                                                  print(widget.post.postID);
                                                  await QueuesUnmoderatedProvider
                                                      .handleUnmoderated(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: 'post',
                                                    action: 'approve',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = true;
                                                    isRemoved = false;
                                                  });
                                                } else if (widget.queueType ==
                                                    'edited') {
                                                  await QueuesEditItemProvider
                                                      .handleEditItem(
                                                    itemType: 'post',
                                                    action: 'approve',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = true;
                                                    isRemoved = false;
                                                  });
                                                } else {
                                                  await QueuesProvider
                                                      .handleObjection(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: 'post',
                                                    action: 'approve',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = true;
                                                    isRemoved = false;
                                                  });
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
                                                if (widget.queueType ==
                                                    'unmoderated') {
                                                  await QueuesUnmoderatedProvider
                                                      .handleUnmoderated(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: 'post',
                                                    action: 'remove',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = false;
                                                    isRemoved = true;
                                                  });
                                                } else if (widget.queueType ==
                                                    'edited') {
                                                  await QueuesEditItemProvider
                                                      .handleEditItem(
                                                    itemType: 'post',
                                                    action: 'remove',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = false;
                                                    isRemoved = true;
                                                  });
                                                } else {
                                                  await QueuesProvider
                                                      .handleObjection(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: 'post',
                                                    action: 'remove',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = false;
                                                    isRemoved = true;
                                                  });
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
            widget.queueType == 'removed' && isApproved
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.5),
                            color: const Color.fromARGB(255, 192, 236, 187),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 13,
                            color: Color.fromARGB(255, 48, 108, 45),
                          ),
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Approved',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 170, 170, 170),
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.queueType == 'removed' && !isApproved && !isRemoved
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
                            SizedBox(width: 3),
                            widget.post.moderatorDetails.removed.removedBy !=
                                        "" &&
                                    widget.post.moderatorDetails.spammed.flag ==
                                        false
                                ? Text(
                                    " Removed by: ${widget.post.moderatorDetails.removed.removedBy}",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 170, 170, 170),
                                      fontSize: 14,
                                    ),
                                  )
                                : widget.post.moderatorDetails.spammed.flag ==
                                        true
                                    ? Text(
                                        " Removed as a spam",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 170, 170, 170),
                                          fontSize: 14,
                                        ),
                                      )
                                    : Text(
                                        'Removed',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: const Color.fromARGB(
                                              255, 170, 170, 170),
                                        ),
                                      ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      )
                    : widget.queueType == 'reported' && isApproved
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 17,
                                  height: 17,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.5),
                                    color: const Color.fromARGB(
                                        255, 192, 236, 187),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 13,
                                    color: Color.fromARGB(255, 48, 108, 45),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Approved',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color.fromARGB(
                                        255, 170, 170, 170),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : widget.queueType == 'reported' && isRemoved
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 17,
                                      height: 17,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.5),
                                        color: const Color.fromARGB(
                                            255, 246, 204, 212),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 13,
                                        color:
                                            Color.fromARGB(255, 169, 100, 75),
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    widget.post.moderatorDetails.removed
                                                    .removedBy !=
                                                "" &&
                                            widget.post.moderatorDetails.spammed
                                                    .flag ==
                                                false
                                        ? Text(
                                            " Removed by: ${widget.post.moderatorDetails.removed.removedBy}",
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 170, 170, 170),
                                              fontSize: 14,
                                            ),
                                          )
                                        : widget.post.moderatorDetails.spammed
                                                    .flag ==
                                                true
                                            ? Text(
                                                " Removed as a spam",
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 170, 170, 170),
                                                  fontSize: 14,
                                                ),
                                              )
                                            : Text(
                                                'Removed',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: const Color.fromARGB(
                                                      255, 170, 170, 170),
                                                ),
                                              ),
                                  ],
                                ),
                              )
                            : widget.queueType == 'reported' &&
                                    !isApproved &&
                                    !isRemoved
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: IntrinsicWidth(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: const Color.fromARGB(
                                              255, 254, 244, 190),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              CupertinoIcons.flag,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 93, 79, 20),
                                              weight: 500,
                                            ),
                                            SizedBox(width: 4),
                                            widget.post.moderatorDetails
                                                        .reported.type !=
                                                    ""
                                                ? Text(
                                                    " Reported: ${widget.post.moderatorDetails.reported.type}",
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              170,
                                                              170,
                                                              170),
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                : Text(
                                                    'Reported',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              170,
                                                              170,
                                                              170),
                                                    ),
                                                  ),
                                            const SizedBox(width: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : widget.queueType == 'edited' && isApproved
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 17,
                                              height: 17,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.5),
                                                color: const Color.fromARGB(
                                                    255, 192, 236, 187),
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                size: 13,
                                                color: Color.fromARGB(
                                                    255, 48, 108, 45),
                                              ),
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              'Approved',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: const Color.fromARGB(
                                                    255, 170, 170, 170),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : widget.queueType == 'edited' && isRemoved
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 17,
                                                  height: 17,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.5),
                                                    color: const Color.fromARGB(
                                                        255, 246, 204, 212),
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 13,
                                                    color: Color.fromARGB(
                                                        255, 169, 100, 75),
                                                  ),
                                                ),
                                                SizedBox(width: 3),
                                                widget
                                                                .post
                                                                .moderatorDetails
                                                                .removed
                                                                .removedBy !=
                                                            "" &&
                                                        widget
                                                                .post
                                                                .moderatorDetails
                                                                .spammed
                                                                .flag ==
                                                            false
                                                    ? Text(
                                                        " Removed by: ${widget.post.moderatorDetails.removed.removedBy}",
                                                        style: TextStyle(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              170, 170, 170),
                                                          fontSize: 14,
                                                        ),
                                                      )
                                                    : widget
                                                                .post
                                                                .moderatorDetails
                                                                .spammed
                                                                .flag ==
                                                            true
                                                        ? Text(
                                                            " Removed as a spam",
                                                            style: TextStyle(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  170,
                                                                  170,
                                                                  170),
                                                              fontSize: 14,
                                                            ),
                                                          )
                                                        : Text(
                                                            'Removed',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  170,
                                                                  170,
                                                                  170),
                                                            ),
                                                          ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.grey,
              height: 2,
            ),
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
  final postService = GetIt.instance.get<PostService>();

  PostItem? postItem;
  bool? isMuted;
  bool? isBanned;

  bool? isApprovedUser;

  bool isApproved = false;
  bool isRemoved = false;

  String? removalReasons;
  String? reportedReason;

  Future<void> getPostByID(String postID) async {
    postItem = await postService.getPostById(postID);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var QueuesProvider = context.read<handleObjectionProvider>();
    var QueuesUnmoderatedProvider = context.read<handleUnmoderatedProvider>();
    var QueuesEditItemProvider = context.read<handleEditItemProvider>();

    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CommentsDesktop(
                postId: widget.post.itemID,
                isModInComment: true,
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
                                    title: Text(isApprovedUser != null
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
                                                    itemType: 'comment',
                                                    action: 'approve',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = true;
                                                    isRemoved = false;
                                                  });
                                                } else if (widget.queueType ==
                                                    'edited') {
                                                  await QueuesEditItemProvider
                                                      .handleEditItem(
                                                    itemType: 'comment',
                                                    action: 'approve',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = true;
                                                    isRemoved = false;
                                                  });
                                                } else {
                                                  await QueuesProvider
                                                      .handleObjection(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: 'comment',
                                                    action: 'approve',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = true;
                                                    isRemoved = false;
                                                  });
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
                                                if (widget.queueType ==
                                                    'unmoderated') {
                                                  await QueuesUnmoderatedProvider
                                                      .handleUnmoderated(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: 'comment',
                                                    action: 'remove',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = false;
                                                    isRemoved = true;
                                                  });
                                                } else if (widget.queueType ==
                                                    'edited') {
                                                  await QueuesEditItemProvider
                                                      .handleEditItem(
                                                    itemType: 'comment',
                                                    action: 'remove',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = false;
                                                    isRemoved = true;
                                                  });
                                                } else {
                                                  await QueuesProvider
                                                      .handleObjection(
                                                    objectionType:
                                                        widget.queueType,
                                                    itemType: 'comment',
                                                    action: 'remove',
                                                    communityName:
                                                        moderatorController
                                                            .communityName,
                                                    itemID: widget.post.postID,
                                                  );
                                                  setState(() {
                                                    isApproved = false;
                                                    isRemoved = true;
                                                  });
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
                    FutureBuilder(
                        future: getPostByID(widget.post.itemID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: LoadingAnimationWidget.twoRotatingArc(
                                  color:
                                      const Color.fromARGB(255, 172, 172, 172),
                                  size: 30),
                            );
                          } else {
                            final postTitle = postItem?.title ?? '';
                            return Text(
                              postTitle,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            );
                          }
                        }),
                    Row(children: [
                      Container(
                        margin: const EdgeInsets.only(left: 4, right: 8),
                        height: 15,
                        width: 5,
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
            widget.queueType == 'removed' && isApproved
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: [
                        Container(
                          width: 17,
                          height: 17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.5),
                            color: const Color.fromARGB(255, 192, 236, 187),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 13,
                            color: Color.fromARGB(255, 48, 108, 45),
                          ),
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Approved',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 170, 170, 170),
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.queueType == 'removed' && !isApproved && !isRemoved
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
                            SizedBox(width: 3),
                            widget.post.moderatorDetails.removed.removedBy !=
                                        "" &&
                                    widget.post.moderatorDetails.spammed.flag ==
                                        false
                                ? Text(
                                    " Removed by: ${widget.post.moderatorDetails.removed.removedBy}",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 170, 170, 170),
                                      fontSize: 14,
                                    ),
                                  )
                                : widget.post.moderatorDetails.spammed.flag ==
                                        true
                                    ? Text(
                                        " Removed as a spam",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 170, 170, 170),
                                          fontSize: 14,
                                        ),
                                      )
                                    : Text(
                                        'Removed',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: const Color.fromARGB(
                                              255, 170, 170, 170),
                                        ),
                                      ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      )
                    : widget.queueType == 'reported' && isApproved
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 17,
                                  height: 17,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.5),
                                    color: const Color.fromARGB(
                                        255, 192, 236, 187),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 13,
                                    color: Color.fromARGB(255, 48, 108, 45),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Approved',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color.fromARGB(
                                        255, 170, 170, 170),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : widget.queueType == 'reported' && isRemoved
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 17,
                                      height: 17,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.5),
                                        color: const Color.fromARGB(
                                            255, 246, 204, 212),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 13,
                                        color:
                                            Color.fromARGB(255, 169, 100, 75),
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    widget.post.moderatorDetails.removed
                                                    .removedBy !=
                                                "" &&
                                            widget.post.moderatorDetails.spammed
                                                    .flag ==
                                                false
                                        ? Text(
                                            " Removed by: ${widget.post.moderatorDetails.removed.removedBy}",
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 170, 170, 170),
                                              fontSize: 14,
                                            ),
                                          )
                                        : widget.post.moderatorDetails.spammed
                                                    .flag ==
                                                true
                                            ? Text(
                                                " Removed as a spam",
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 170, 170, 170),
                                                  fontSize: 14,
                                                ),
                                              )
                                            : Text(
                                                'Removed',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: const Color.fromARGB(
                                                      255, 170, 170, 170),
                                                ),
                                              ),
                                  ],
                                ),
                              )
                            : widget.queueType == 'reported' &&
                                    !isApproved &&
                                    !isRemoved
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: IntrinsicWidth(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: const Color.fromARGB(
                                              255, 254, 244, 190),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              CupertinoIcons.flag,
                                              size: 20,
                                              color: Color.fromARGB(
                                                  255, 93, 79, 20),
                                              weight: 500,
                                            ),
                                            SizedBox(width: 4),
                                            widget.post.moderatorDetails
                                                        .reported.type !=
                                                    ""
                                                ? Text(
                                                    " Reported: ${widget.post.moderatorDetails.reported.type}",
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              170,
                                                              170,
                                                              170),
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                : Text(
                                                    'Reported',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              170,
                                                              170,
                                                              170),
                                                    ),
                                                  ),
                                            const SizedBox(width: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : widget.queueType == 'edited' && isApproved
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 17,
                                              height: 17,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.5),
                                                color: const Color.fromARGB(
                                                    255, 192, 236, 187),
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                size: 13,
                                                color: Color.fromARGB(
                                                    255, 48, 108, 45),
                                              ),
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              'Approved',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: const Color.fromARGB(
                                                    255, 170, 170, 170),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : widget.queueType == 'edited' && isRemoved
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 17,
                                                  height: 17,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.5),
                                                    color: const Color.fromARGB(
                                                        255, 246, 204, 212),
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 13,
                                                    color: Color.fromARGB(
                                                        255, 169, 100, 75),
                                                  ),
                                                ),
                                                SizedBox(width: 3),
                                                widget
                                                                .post
                                                                .moderatorDetails
                                                                .removed
                                                                .removedBy !=
                                                            "" &&
                                                        widget
                                                                .post
                                                                .moderatorDetails
                                                                .spammed
                                                                .flag ==
                                                            false
                                                    ? Text(
                                                        " Removed by: ${widget.post.moderatorDetails.removed.removedBy}",
                                                        style: TextStyle(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              170, 170, 170),
                                                          fontSize: 14,
                                                        ),
                                                      )
                                                    : widget
                                                                .post
                                                                .moderatorDetails
                                                                .spammed
                                                                .flag ==
                                                            true
                                                        ? Text(
                                                            " Removed as a spam",
                                                            style: TextStyle(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  170,
                                                                  170,
                                                                  170),
                                                              fontSize: 14,
                                                            ),
                                                          )
                                                        : Text(
                                                            'Removed',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  170,
                                                                  170,
                                                                  170),
                                                            ),
                                                          ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.grey,
              height: 2,
            ),
          ],
        ),
      ),
    );
  }
}
