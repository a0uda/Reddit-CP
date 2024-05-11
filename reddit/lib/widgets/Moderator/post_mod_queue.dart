import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Services/user_service.dart';
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
  final UserService userService = GetIt.instance.get<UserService>();
  final userController = GetIt.instance.get<UserController>();

  bool isApprovedUser = false;
  bool isBannedUser = false;
  bool isMutedUser = false;
  bool isRemoved = false;
  bool isApproved = false;
  bool usersFetchedApproved = false;
  bool usersFetchedBanned = false;
  bool usersFetchedMuted = false;

  String? removalReasons;
  String? reportedReason;

  List<Map<String, dynamic>> foundBannedUsers = [];
  List<Map<String, dynamic>> foundApprovedUsers = [];
  List<Map<String, dynamic>> foundMutedUsers = [];

  late bool hasPostPermission;
  late bool hasUsersPermission;

  void checkPostPermission() {
    if (moderatorController.modAccess.everything ||
        moderatorController.modAccess.managePostsAndComments) {
      hasPostPermission = true;
    } else {
      hasPostPermission = false;
    }
  }

  void checkUsersPermission() {
    if (moderatorController.modAccess.everything ||
        moderatorController.modAccess.manageUsers) {
      hasUsersPermission = true;
    } else {
      hasUsersPermission = false;
    }
  }

  Future<void> fetchBannedUsers() async {
    if (!usersFetchedBanned) {
      await moderatorController
          .getBannedUsers(moderatorController.communityName);
      setState(() {
        foundBannedUsers = moderatorController.bannedUsers;
        usersFetchedBanned = true;
      });
    }
  }

  Future<void> fetchApprovedUsers() async {
    if (!usersFetchedApproved) {
      await moderatorController
          .getApprovedUser(moderatorController.communityName);
      setState(() {
        foundApprovedUsers = moderatorController.approvedUsers;
        usersFetchedApproved = true;
      });
    }
  }

  Future<void> fetchMutedUsers() async {
    if (!usersFetchedMuted) {
      await moderatorController
          .getMutedUsers(moderatorController.communityName);
      setState(() {
        foundMutedUsers = moderatorController.mutedUsers;
        usersFetchedMuted = true;
      });
    }
  }

  Future<void> checkApprovedUser() async {
    await fetchApprovedUsers();
    for (var user in foundApprovedUsers) {
      if (user['username'] == widget.post.username) {
        setState(() {
          isApprovedUser = true;
        });
      }
    }
  }

  addApprovedUser() async {
    var approvedUserProvider = context.read<ApprovedUserProvider>();
    await approvedUserProvider.addApprovedUsers(
        widget.post.username, moderatorController.communityName);
    Navigator.of(context).pop();
  }

  Future<void> removeApprovedUser() async {
    var approvedUserProvider = context.read<ApprovedUserProvider>();
    await approvedUserProvider.removeApprovedUsers(
        widget.post.username, moderatorController.communityName);
    Navigator.of(context).pop();
  }

  Future<void> checkBannedUser() async {
    await fetchBannedUsers();
    for (var user in foundApprovedUsers) {
      if (user['username'] == widget.post.username) {
        setState(() {
          isBannedUser = true;
        });
      }
    }
  }

  Future<void> checkMutedUser() async {
    await fetchMutedUsers();
    for (var user in foundApprovedUsers) {
      if (user['username'] == widget.post.username) {
        setState(() {
          isMutedUser = true;
        });
      }
    }
  }

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

  @override
  void initState() {
    super.initState();
    checkPostPermission();
    checkUsersPermission();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var QueuesProvider = context.read<handleObjectionProvider>();
    var QueuesUnmoderatedProvider = context.read<handleUnmoderatedProvider>();
    var QueuesEditItemProvider = context.read<handleEditItemProvider>();
    var mutedUserProvider = context.read<MutedUserProvider>();
    double desktopFactor = MediaQuery.of(context).size.width > 700 ? 1.3 : 1;

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
                              leading: widget.post.profilePicture != ""
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          widget.post.profilePicture),
                                      radius: 24,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/Greddit.png'),
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
                              onTap: () {
                                String userType =
                                    userController.userAbout!.username ==
                                            widget.post.username
                                        ? 'me'
                                        : 'other';
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FutureBuilder<UserAbout?>(
                                      future: userService
                                          .getUserAbout(widget.post.username),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            color: Colors.white,
                                            child: const Center(
                                                child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child:
                                                  CircularProgressIndicator(),
                                            )),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return ProfileScreen(
                                            snapshot.data,
                                            userType,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  FutureBuilder(
                                    future: checkMutedUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                                  color: const Color.fromARGB(
                                                      255, 172, 172, 172),
                                                  size: 30),
                                        );
                                      } else {
                                        return ListTile(
                                          leading:
                                              const Icon(CupertinoIcons.nosign),
                                          title: Text(isMutedUser
                                              ? 'Unmute user'
                                              : 'Mute User'),
                                          onTap: () async {
                                            if (hasUsersPermission) {
                                              if (!isMutedUser) {
                                                await mutedUserProvider
                                                    .addMutedUsers(
                                                        widget.post.username,
                                                        moderatorController
                                                            .communityName);
                                                Navigator.pop(context);
                                              } else {
                                                await mutedUserProvider
                                                    .unMuteUser(
                                                        widget.post.username,
                                                        moderatorController
                                                            .communityName);
                                                Navigator.pop(context);
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                        child: const Text(
                                                          'You do not have permission to change this setting',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: const Text(
                                                              'Please contact the owner of the community for more information',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child:
                                                                OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        37,
                                                                        79,
                                                                        165),
                                                                side: const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165)),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16,
                                                                        top: 16,
                                                                        bottom:
                                                                            16),
                                                              ),
                                                              child: const Text(
                                                                'OK',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                    thickness: 1,
                                  ),
                                  FutureBuilder(
                                    future: checkApprovedUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                                  color: const Color.fromARGB(
                                                      255, 172, 172, 172),
                                                  size: 30),
                                        );
                                      } else {
                                        return ListTile(
                                          leading: const Icon(Icons.check),
                                          title: Text(isApprovedUser
                                              ? 'Unpprove user'
                                              : 'Approve User'),
                                          onTap: () async {
                                            if (hasUsersPermission) {
                                              if (!isApprovedUser) {
                                                await addApprovedUser();
                                              } else {
                                                await removeApprovedUser();
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                        child: const Text(
                                                          'You do not have permission to change this setting',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: const Text(
                                                              'Please contact the owner of the community for more information',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child:
                                                                OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        37,
                                                                        79,
                                                                        165),
                                                                side: const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165)),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16,
                                                                        top: 16,
                                                                        bottom:
                                                                            16),
                                                              ),
                                                              child: const Text(
                                                                'OK',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                    thickness: 1,
                                  ),
                                  FutureBuilder(
                                    future: checkBannedUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                                  color: const Color.fromARGB(
                                                      255, 172, 172, 172),
                                                  size: 30),
                                        );
                                      } else {
                                        return ListTile(
                                          leading: const Icon(
                                            Icons.gavel,
                                            color:
                                                Color.fromARGB(255, 149, 9, 38),
                                          ),
                                          title: Text(
                                            isBannedUser
                                                ? 'Unban user'
                                                : 'Ban User',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 149, 9, 38)),
                                          ),
                                          onTap: () {
                                            if (hasUsersPermission) {
                                              // Navigator.of(context)
                                              //     .push(MaterialPageRoute(
                                              //   builder: (context) =>
                                              //       AddBannedUser(),
                                              // ));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                        child: const Text(
                                                          'You do not have permission to change this setting',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: const Text(
                                                              'Please contact the owner of the community for more information',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child:
                                                                OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        37,
                                                                        79,
                                                                        165),
                                                                side: const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165)),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16,
                                                                        top: 16,
                                                                        bottom:
                                                                            16),
                                                              ),
                                                              child: const Text(
                                                                'OK',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                        );
                                      }
                                    },
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
                  widget.post.profilePicture != ""
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.post.profilePicture),
                          radius: 13,
                        )
                      : CircleAvatar(
                          backgroundImage: AssetImage("images/Greddit.png"),
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
                        formatDateTime(widget.post.createdAt),
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
                                                if (hasPostPermission) {
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
                                                      itemID:
                                                          widget.post.postID,
                                                    );
                                                    setState(() {
                                                      isApproved = true;
                                                      isRemoved = false;
                                                    });
                                                  } else if ((widget
                                                      .post
                                                      .moderatorDetails
                                                      .removed
                                                      .flag)) {
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
                                                      itemID:
                                                          widget.post.postID,
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
                                                      itemID:
                                                          widget.post.postID,
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
                                                      itemID:
                                                          widget.post.postID,
                                                    );
                                                    setState(() {
                                                      isApproved = true;
                                                      isRemoved = false;
                                                    });
                                                  }
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CupertinoAlertDialog(
                                                          title: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: const Text(
                                                              'You do not have permission to change this setting',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          content: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                                child:
                                                                    const Text(
                                                                  'Please contact the owner of the community for more information',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                                child:
                                                                    OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  style: OutlinedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165),
                                                                    side: const BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165)),
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16,
                                                                        top: 16,
                                                                        bottom:
                                                                            16),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
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
                                                if (hasPostPermission) {
                                                  if (widget.queueType ==
                                                          'unmoderated' ||
                                                      widget
                                                          .post
                                                          .moderatorDetails
                                                          .removed
                                                          .flag) {
                                                    await QueuesUnmoderatedProvider
                                                        .handleUnmoderated(
                                                      objectionType:
                                                          widget.queueType,
                                                      itemType: 'post',
                                                      action: 'remove',
                                                      communityName:
                                                          moderatorController
                                                              .communityName,
                                                      itemID:
                                                          widget.post.postID,
                                                    );
                                                    setState(() {
                                                      isApproved = false;
                                                      isRemoved = true;
                                                    });
                                                  } else if ((widget
                                                      .post
                                                      .moderatorDetails
                                                      .removed
                                                      .flag)) {
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
                                                      action: 'remove',
                                                      communityName:
                                                          moderatorController
                                                              .communityName,
                                                      itemID:
                                                          widget.post.postID,
                                                    );
                                                  } else if (widget.queueType ==
                                                      'edited') {
                                                    await QueuesEditItemProvider
                                                        .handleEditItem(
                                                      itemType: 'post',
                                                      action: 'remove',
                                                      communityName:
                                                          moderatorController
                                                              .communityName,
                                                      itemID:
                                                          widget.post.postID,
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
                                                      itemID:
                                                          widget.post.postID,
                                                    );
                                                    setState(() {
                                                      isApproved = false;
                                                      isRemoved = true;
                                                    });
                                                  }
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CupertinoAlertDialog(
                                                          title: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: const Text(
                                                              'You do not have permission to change this setting',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          content: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                                child:
                                                                    const Text(
                                                                  'Please contact the owner of the community for more information',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                                child:
                                                                    OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  style: OutlinedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165),
                                                                    side: const BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165)),
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16,
                                                                        top: 16,
                                                                        bottom:
                                                                            16),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
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
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.postTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.post.postDescription,
                      ),
                    ],
                  ),
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
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: 80.0 * desktopFactor,
                            height: 60.0 * desktopFactor,
                            child: ImageFiltered(
                              imageFilter: widget.post.nsfwFlag
                                  ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                              child: Image.network(
                                widget.post.queuePostImage[0].imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                                        : isApproved
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Row(children: [
                                                  Container(
                                                    width: 17,
                                                    height: 17,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.5),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              192,
                                                              236,
                                                              187),
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              170,
                                                              170,
                                                              170),
                                                    ),
                                                  )
                                                ]),
                                              )
                                            : isRemoved
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 17,
                                                          height: 17,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.5),
                                                            color: const Color
                                                                .fromARGB(255,
                                                                246, 204, 212),
                                                          ),
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 13,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    169,
                                                                    100,
                                                                    75),
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
                                                                style:
                                                                    TextStyle(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      170,
                                                                      170,
                                                                      170),
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
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          170,
                                                                          170,
                                                                          170),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    'Removed',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
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
  bool isApprovedUser = false;
  bool isBannedUser = false;
  bool isMutedUser = false;
  bool isRemoved = false;
  bool isApproved = false;
  bool usersFetchedApproved = false;
  bool usersFetchedBanned = false;
  bool usersFetchedMuted = false;

  String? removalReasons;
  String? reportedReason;

  List<Map<String, dynamic>> foundBannedUsers = [];
  List<Map<String, dynamic>> foundApprovedUsers = [];
  List<Map<String, dynamic>> foundMutedUsers = [];

  late bool hasPostPermission;
  late bool hasUsersPermission;

  void checkPostPermission() {
    if (moderatorController.modAccess.everything ||
        moderatorController.modAccess.managePostsAndComments) {
      hasPostPermission = true;
    } else {
      hasPostPermission = false;
    }
  }

  void checkUsersPermission() {
    if (moderatorController.modAccess.everything ||
        moderatorController.modAccess.manageUsers) {
      hasUsersPermission = true;
    } else {
      hasUsersPermission = false;
    }
  }

  Future<void> fetchBannedUsers() async {
    if (!usersFetchedBanned) {
      await moderatorController
          .getBannedUsers(moderatorController.communityName);
      setState(() {
        foundBannedUsers = moderatorController.bannedUsers;
        usersFetchedBanned = true;
      });
    }
  }

  Future<void> fetchApprovedUsers() async {
    if (!usersFetchedApproved) {
      await moderatorController
          .getApprovedUser(moderatorController.communityName);
      setState(() {
        foundApprovedUsers = moderatorController.approvedUsers;
        usersFetchedApproved = true;
      });
    }
  }

  Future<void> fetchMutedUsers() async {
    if (!usersFetchedMuted) {
      await moderatorController
          .getMutedUsers(moderatorController.communityName);
      setState(() {
        foundMutedUsers = moderatorController.mutedUsers;
        usersFetchedMuted = true;
      });
    }
  }

  Future<void> checkApprovedUser() async {
    await fetchApprovedUsers();
    for (var user in foundApprovedUsers) {
      if (user['username'] == widget.post.username) {
        setState(() {
          isApprovedUser = true;
        });
      }
    }
  }

  Future<void> addApprovedUser() async {
    var approvedUserProvider = context.read<ApprovedUserProvider>();
    await approvedUserProvider.addApprovedUsers(
        widget.post.username, moderatorController.communityName);
    Navigator.of(context).pop();
  }

  Future<void> removeApprovedUser() async {
    var approvedUserProvider = context.read<ApprovedUserProvider>();
    await approvedUserProvider.removeApprovedUsers(
        widget.post.username, moderatorController.communityName);
    Navigator.of(context).pop();
  }

  Future<void> checkBannedUser() async {
    await fetchBannedUsers();
    for (var user in foundApprovedUsers) {
      if (user['username'] == widget.post.username) {
        setState(() {
          isBannedUser = true;
        });
      }
    }
  }

  Future<void> checkMutedUser() async {
    await fetchMutedUsers();
    for (var user in foundApprovedUsers) {
      if (user['username'] == widget.post.username) {
        setState(() {
          isMutedUser = true;
        });
      }
    }
  }

  Future<void> getPostByID(String postID) async {
    postItem = await postService.getPostById(postID);
  }

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

  @override
  void initState() {
    super.initState();
    checkPostPermission();
    checkUsersPermission();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var QueuesProvider = context.read<handleObjectionProvider>();
    var QueuesUnmoderatedProvider = context.read<handleUnmoderatedProvider>();
    var QueuesEditItemProvider = context.read<handleEditItemProvider>();
    var mutedUserProvider = context.read<MutedUserProvider>();
    double desktopFactor = MediaQuery.of(context).size.width > 700 ? 1.3 : 1;

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
                                  FutureBuilder(
                                    future: checkMutedUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                                  color: const Color.fromARGB(
                                                      255, 172, 172, 172),
                                                  size: 30),
                                        );
                                      } else {
                                        return ListTile(
                                          leading:
                                              const Icon(CupertinoIcons.nosign),
                                          title: Text(isMutedUser
                                              ? 'Unmute user'
                                              : 'Mute User'),
                                          onTap: () async {
                                            if (hasUsersPermission) {
                                              if (!isMutedUser) {
                                                await mutedUserProvider
                                                    .addMutedUsers(
                                                        widget.post.username,
                                                        moderatorController
                                                            .communityName);
                                                Navigator.pop(context);
                                              } else {
                                                await mutedUserProvider
                                                    .unMuteUser(
                                                        widget.post.username,
                                                        moderatorController
                                                            .communityName);
                                                Navigator.pop(context);
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                        child: const Text(
                                                          'You do not have permission to change this setting',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: const Text(
                                                              'Please contact the owner of the community for more information',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child:
                                                                OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        37,
                                                                        79,
                                                                        165),
                                                                side: const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165)),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16,
                                                                        top: 16,
                                                                        bottom:
                                                                            16),
                                                              ),
                                                              child: const Text(
                                                                'OK',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                    thickness: 1,
                                  ),
                                  FutureBuilder(
                                    future: checkApprovedUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                                  color: const Color.fromARGB(
                                                      255, 172, 172, 172),
                                                  size: 30),
                                        );
                                      } else {
                                        return ListTile(
                                          leading: const Icon(Icons.check),
                                          title: Text(isApprovedUser
                                              ? 'Unpprove user'
                                              : 'Approve User'),
                                          onTap: () async {
                                            if (hasUsersPermission) {
                                              if (!isApprovedUser) {
                                                await addApprovedUser();
                                              } else {
                                                await removeApprovedUser();
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                        child: const Text(
                                                          'You do not have permission to change this setting',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: const Text(
                                                              'Please contact the owner of the community for more information',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child:
                                                                OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        37,
                                                                        79,
                                                                        165),
                                                                side: const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165)),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16,
                                                                        top: 16,
                                                                        bottom:
                                                                            16),
                                                              ),
                                                              child: const Text(
                                                                'OK',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                    thickness: 1,
                                  ),
                                  FutureBuilder(
                                    future: checkBannedUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                                  color: const Color.fromARGB(
                                                      255, 172, 172, 172),
                                                  size: 30),
                                        );
                                      } else {
                                        return ListTile(
                                          leading: const Icon(
                                            Icons.gavel,
                                            color:
                                                Color.fromARGB(255, 149, 9, 38),
                                          ),
                                          title: Text(
                                            isBannedUser
                                                ? 'Unban user'
                                                : 'Ban User',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 149, 9, 38)),
                                          ),
                                          onTap: () {
                                            if (hasUsersPermission) {
                                              // Navigator.of(context)
                                              //     .push(MaterialPageRoute(
                                              //   builder: (context) =>
                                              //       AddBannedUser(),
                                              // ));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoAlertDialog(
                                                      title: Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                        child: const Text(
                                                          'You do not have permission to change this setting',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 16),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: const Text(
                                                              'Please contact the owner of the community for more information',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child:
                                                                OutlinedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        37,
                                                                        79,
                                                                        165),
                                                                side: const BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165)),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16,
                                                                        top: 16,
                                                                        bottom:
                                                                            16),
                                                              ),
                                                              child: const Text(
                                                                'OK',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                        );
                                      }
                                    },
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
                        formatDateTime(widget.post.createdAt),
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
                                                if (hasPostPermission) {
                                                  if (widget.queueType ==
                                                      'unmoderated') {
                                                    print(
                                                        'ana hena bab3at request');
                                                    print(widget.queueType);
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
                                                      itemID:
                                                          widget.post.postID,
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
                                                      itemID:
                                                          widget.post.postID,
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
                                                      itemID:
                                                          widget.post.postID,
                                                    );
                                                    setState(() {
                                                      isApproved = true;
                                                      isRemoved = false;
                                                    });
                                                  }
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CupertinoAlertDialog(
                                                          title: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: const Text(
                                                              'You do not have permission to change this setting',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          content: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                                child:
                                                                    const Text(
                                                                  'Please contact the owner of the community for more information',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                                child:
                                                                    OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  style: OutlinedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165),
                                                                    side: const BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165)),
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16,
                                                                        top: 16,
                                                                        bottom:
                                                                            16),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
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
                                                if (hasPostPermission) {
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
                                                      itemID:
                                                          widget.post.postID,
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
                                                      itemID:
                                                          widget.post.postID,
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
                                                      itemID:
                                                          widget.post.postID,
                                                    );
                                                    setState(() {
                                                      isApproved = false;
                                                      isRemoved = true;
                                                    });
                                                  }
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CupertinoAlertDialog(
                                                          title: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: const Text(
                                                              'You do not have permission to change this setting',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          content: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                                child:
                                                                    const Text(
                                                                  'Please contact the owner of the community for more information',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                                child:
                                                                    OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  style: OutlinedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165),
                                                                    side: const BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            37,
                                                                            79,
                                                                            165)),
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            16,
                                                                        top: 16,
                                                                        bottom:
                                                                            16),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
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
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey),
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
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: 80.0 * desktopFactor,
                            height: 60.0 * desktopFactor,
                            child: ImageFiltered(
                              imageFilter: widget.post.nsfwFlag
                                  ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                              child: Image.network(
                                widget.post.queuePostImage[0].imageLink,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                                        : isApproved
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Row(children: [
                                                  Container(
                                                    width: 17,
                                                    height: 17,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.5),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              192,
                                                              236,
                                                              187),
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
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              170,
                                                              170,
                                                              170),
                                                    ),
                                                  )
                                                ]),
                                              )
                                            : isRemoved
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 17,
                                                          height: 17,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.5),
                                                            color: const Color
                                                                .fromARGB(255,
                                                                246, 204, 212),
                                                          ),
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 13,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    169,
                                                                    100,
                                                                    75),
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
                                                                style:
                                                                    TextStyle(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      170,
                                                                      170,
                                                                      170),
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
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          170,
                                                                          170,
                                                                          170),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    'Removed',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
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
