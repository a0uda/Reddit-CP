import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/widgets/Moderator/add_approved_user.dart';

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

  final QueuesPostItem post;

  PostModQueue({super.key, required this.post});

  @override
  State<PostModQueue> createState() => _PostModQueueState();
}

class _PostModQueueState extends State<PostModQueue> {
  bool? isMuted;
  bool? isApproved;
  bool? isBanned;

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
                                  Row(
                                    // awl row ely feeh el icons
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        // column 3shan icon w tahteeh el text
                                        children: [
                                          Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 1),
                                                color: const Color.fromARGB(
                                                    255, 237, 237, 237),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  CupertinoIcons.lock,
                                                ),
                                                onPressed: () {},
                                              )),
                                          const Text(
                                            'Lock',
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      Column(
                                        // column 3shan icon w tahteeh el text
                                        children: [
                                          Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 1),
                                                color: const Color.fromARGB(
                                                    255, 237, 237, 237),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(CupertinoIcons
                                                    .arrowshape_turn_up_right),
                                                onPressed: () {},
                                              )),
                                          const Text(
                                            'Share',
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      Column(
                                        // column 3shan icon w tahteeh el text
                                        children: [
                                          Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 1),
                                                color: const Color.fromARGB(
                                                    255, 237, 237, 237),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () {},
                                              )),
                                          const Text(
                                            'Remove',
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      Column(
                                        // column 3shan icon w tahteeh el text
                                        children: [
                                          Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 1),
                                                color: const Color.fromARGB(
                                                    255, 237, 237, 237),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(Icons.check),
                                                onPressed: () {},
                                              )),
                                          const Text(
                                            'Approve',
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(CupertinoIcons.flag),
                                          title: const Text(
                                            'Reported',
                                          ),
                                          onTap: () {},
                                        ),
                                        ListTile(
                                          leading:
                                              const Icon(CupertinoIcons.flag_slash),
                                          title: const Text(
                                              'Ignore Reports and Approve'),
                                          onTap: () {},
                                        ),
                                        ListTile(
                                          leading: const Icon(
                                              Icons.dangerous_outlined),
                                          title: Text(
                                              widget.post.nsfwFlag 
                                                  ? 'Unmark as NSFW'
                                                  : 'Mark as NFSW'),
                                          onTap: () {},
                                        ),
                                        ListTile(
                                          leading:
                                              const Icon(CupertinoIcons.exclamationmark_octagon),
                                          title: Text(
                                              widget.post.spoilerFlag
                                                  ? 'Unmark as spoiler'
                                                  : 'Mark as spoiler'),
                                          onTap: () {},
                                        )
                                      ],
                                    ),
                                  )
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
                widget.post.queuePostImage.isNotEmpty ?
                    Container(
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
            // widget.post.moderatorDetails.removedRemovalReason != ""
            //     ? Container(
            //         padding: const EdgeInsets.all(4),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(3),
            //           color: Colors.amber[100],
            //         ),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(left: 4.0),
            //               child: Icon(
            //                 CupertinoIcons.flag,
            //                 color: Colors.grey[700],
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(right: 4.0),
            //               child: Text(
            //                 " ${widget.post.moderatorDetails.removedRemovalReason}",
            //                 style: TextStyle(color: Colors.grey[700]),
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     : const SizedBox(),
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
