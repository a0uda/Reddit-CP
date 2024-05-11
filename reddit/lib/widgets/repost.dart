import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/moderator_item.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/community_page.dart';
import 'package:reddit/Services/moderator_service.dart';
import 'package:reddit/widgets/Community/community_responsive.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';
import 'package:reddit/widgets/Moderator/modal_for_remals.dart';
import 'package:reddit/widgets/comments_desktop.dart';
import 'package:reddit/widgets/listing_certain_user.dart';
import 'package:reddit/widgets/options.dart';
import 'package:reddit/widgets/search_community_list.dart';
import 'package:reddit/widgets/share_post.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/widgets/poll_widget.dart';
import 'package:reddit/Models/poll_item.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/widgets/add_text_share.dart';

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

//for merging
class Repost extends StatefulWidget {
  // final String? profileImageUrl;
  final String name;
  final String title;
  final String originalID;
  final String date;
  int likes;
  final int commentsCount;
  final String id;
  final String communityName;
  bool isLocked;
  String? description;
  ModeratorDetails? moderatorDetails;
  bool isPostMod;
  final int vote;
  bool deleted;
  bool isSaved;
  OnLock? onLock;

  OnClearDelete? onclearDelete;

  OnClearEdit? onclearEdit;

  Repost({
    super.key,
    required this.id,
    // required this.profileImageUrl,
    required this.deleted,
    required this.name,
    required this.title,
    required this.originalID,
    required this.date,
    required this.likes,
    this.onclearDelete,
    this.onclearEdit,
    required this.commentsCount,
    required this.isSaved,
    required this.communityName,
    required this.isLocked,
    this.description,
    required this.vote,
    this.isPostMod = false,
    this.moderatorDetails,
    this.onLock,
  });

  @override
  RepostState createState() => RepostState();
}

class RepostState extends State<Repost> {
  PostService postService = GetIt.instance.get<PostService>();
  UserService userService = GetIt.instance.get<UserService>();
  UserController userController = GetIt.instance.get<UserController>();
  ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  ModeratorMockService moderatorService =
      GetIt.instance.get<ModeratorMockService>();
  bool issaved = false;
  bool upVote = false;
  bool downVote = false;
  bool spammedFlag = false;
  bool approvedFlag = false;
  bool removedPost = false;
  late Future fetchPic;
  late Future fetchCommPic;
  late Future fetchRepostPic;
  late Future fetchRepostCommPic;
  String? profilePicture;
  String? repostProfilePic;

  late Future fetch;
  CommunityController communityController =
      GetIt.instance.get<CommunityController>();
  bool isHovering = false;
  bool ishovering = false;
  Color? upVoteColor;
  Color? downVoteColor;
  PostItem? post;

  void handleEditChanged(String postcontent) {
    setState(() {
      widget.description = postcontent;
      widget.onclearEdit!(widget.id, postcontent);
    });
  }

  void handledeleteChanged(bool delete) {
    setState(() {
      widget.onclearDelete!(widget.id);
    });
  }

  Future<void> fetchPicture() async {
    UserAbout user = await userService.getUserAbout(widget.name)!;
    profilePicture = user.profilePicture;
  }

  Future<void> fetchCommPicture() async {
      Map<String, dynamic> comm = await moderatorService.getCommunityInfo(
          communityName: widget.communityName);
      profilePicture = comm['communityProfilePicture'];
    
  }

  Future<void> fetchRepostPicture(String name) async {
    UserAbout user = await userService.getUserAbout(name)!;
    repostProfilePic = user.profilePicture;
  }

  Future<void> fetchRepostCommPicture(String name) async {
    Map<String, dynamic> comm =
        await moderatorService.getCommunityInfo(communityName: name);
    repostProfilePic = comm['communityProfilePicture'];
  }

  Future<void> loadOriginalPost() async {
    post = await postService.getPostById(widget.originalID);
    if (post!.inCommunityFlag!) {
      fetchRepostCommPic = fetchRepostCommPicture(post!.communityName);
    } else {
      fetchRepostPic = fetchRepostPicture(post!.username);
    }
  }

  void incrementCounter() {
    setState(() {
      if (upVote == false) {
        postService.upVote(widget.id);
        upVoteColor = Colors.blue;
        downVoteColor = Colors.black;
        if (downVote == true) {
          postService.upVote(widget.id);
          downVoteColor = Colors.black;
          widget.likes++;
          downVote = false;
        }
        widget.likes++;
      } else {
        postService.upVote(widget.id);
        upVoteColor = Colors.black;
        widget.likes--;
      }
      upVote = !upVote;
      //}
    });
  }

  void decrementCounter() {
    setState(() {
      if (downVote == false) {
        postService.downVote(widget.id);
        downVoteColor = Colors.red;
        upVoteColor = Colors.black;
        if (upVote == true) {
          postService.downVote(widget.id);
          upVoteColor = Colors.black;
          widget.likes--;
          upVote = false;
        }
        widget.likes--;
      } else {
        postService.downVote(widget.id);
        downVoteColor = Colors.black;
        widget.likes++;
      }
      downVote = !downVote;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch = loadOriginalPost();
    spammedFlag = widget.moderatorDetails?.spammedFlag ?? false;
    approvedFlag = widget.moderatorDetails?.approvedFlag ?? false;
    removedPost = widget.moderatorDetails?.removedFlag ?? false;

    if (widget.vote == 1) {
      upVote = true;
    } else if (widget.vote == -1) {
      downVote = true;
    }

    fetchPic = fetchPicture();
    fetchCommPic = fetchCommPicture();
  }
  // List of items in our dropdown menu

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;
    bool ismobile = (width < 700) ? true : false;
    upVoteColor = upVote ? Colors.blue : Colors.black;
    downVoteColor = downVote ? Colors.red : Colors.black;
    if (userController.userAbout != null) {
      String username = userController.userAbout!.username;
      //todo saved posts
    }
    void _handleSaveChanged(bool newValue) {
      setState(() {
        widget.isSaved = newValue;
      });
    }

    void _handleLockChanged(bool newValue) {
      widget.onLock!(widget.id, newValue);
      setState(() {
        widget.isLocked = newValue;
      });
    }

    void moderatorHandleLock() async {
      var postLockController = context.read<LockPost>();
      postLockController.lockPost(widget.id);
      setState(() {
        widget.isLocked = !widget.isLocked;
      });
    }

    String userType;
    print("yarabbb");
    print(widget.deleted);
    return (widget.deleted == false)
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentsDesktop(
                      postId: widget.id,
                      isModInComment: widget.isPostMod,
                    ), // pass the post ID here
                  ),
                ),
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
                      leading: widget.communityName == ''
                          ? FutureBuilder<void>(
                              future: fetchPic,
                              builder: (BuildContext context,
                                  AsyncSnapshot<void> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  print("el sora");
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  if (profilePicture == null ||
                                      profilePicture!.isEmpty) {
                                    return const CircleAvatar(
                                      radius: 15,
                                      backgroundImage:
                                          AssetImage('images/Greddit.png'),
                                    );
                                  } else {
                                    return CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(profilePicture!),
                                      radius: 15,
                                    );
                                  }
                                }
                              },
                            )
                          : FutureBuilder<void>(
                              future: fetchCommPic,
                              builder: (BuildContext context,
                                  AsyncSnapshot<void> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  print("el sora");
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  if (profilePicture == null ||
                                      profilePicture!.isEmpty) {
                                    return const CircleAvatar(
                                      radius: 15,
                                      backgroundImage:
                                          AssetImage('images/Greddit.png'),
                                    );
                                  } else {
                                    return CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(profilePicture!),
                                      radius: 15,
                                    );
                                  }
                                }
                              },
                            ),
                      title: Column(
                        children: [
                          Row(children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: (widget.communityName != "")
                                  ? InkWell(
                                      onTap: () async {
                                        await userController.getUserModerated();
                                        bool isMod = userController
                                            .userModeratedCommunities!
                                            .any((comm) =>
                                                comm.name ==
                                                widget.communityName);
                                        var moderatorProvider =
                                            context.read<ModeratorProvider>();
                                        if (isMod) {
                                          await moderatorProvider.getModAccess(
                                              userController
                                                  .userAbout!.username,
                                              widget.communityName);
                                        } else {
                                          moderatorProvider.moderatorController
                                                  .modAccess =
                                              ModeratorItem(
                                                  everything: false,
                                                  managePostsAndComments: false,
                                                  manageSettings: false,
                                                  manageUsers: false,
                                                  username: userController
                                                      .userAbout!.username);
                                        }
                                        //IS MOD HENA.
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (CommunityLayout(
                                                      desktopLayout:
                                                          DesktopCommunityPage(
                                                              isMod: isMod,
                                                              communityName: widget
                                                                  .communityName),
                                                      mobileLayout:
                                                          MobileCommunityPage(
                                                        isMod: isMod,
                                                        communityName: widget
                                                            .communityName,
                                                      ),
                                                    ))));
                                      },
                                      onHover: (hover) {
                                        setState(() {
                                          isHovering = hover;
                                        });
                                      },
                                      child: Text(
                                        (widget.communityName) ==
                                                "Select Community"
                                            ? widget.name
                                            : widget.communityName,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Arial'),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () => {
                                        userType = userController
                                                    .userAbout!.username ==
                                                widget.name
                                            ? 'me'
                                            : 'other',
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FutureBuilder<UserAbout?>(
                                              future: userService
                                                  .getUserAbout(widget.name),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container(
                                                    color: Colors.white,
                                                    child: const SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        )),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  print(widget.name);
                                                  print(snapshot.data);
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  print(widget.name);
                                                  print(snapshot.data);
                                                  return ProfileScreen(
                                                    snapshot.data,
                                                    userType,
                                                  );
                                                }
                                              },
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Arial'),
                                      ),
                                    ),
                            ),
                            Text(
                              '  • ${formatDateTime(widget.date)}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 117, 116, 115)),
                            ),
                          ]),
                          if (widget.communityName != "")
                            Align(
                              alignment: Alignment.topLeft,
                              child: InkWell(
                                onTap: () => {
                                  userType =
                                      userController.userAbout!.username ==
                                              widget.name
                                          ? 'me'
                                          : 'other',
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FutureBuilder<UserAbout?>(
                                        future: userService
                                            .getUserAbout(widget.name),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container(
                                              color: Colors.white,
                                              child: const SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )),
                                            );
                                          } else if (snapshot.hasError) {
                                            print(widget.name);
                                            print(snapshot.data);
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            print(widget.name);
                                            print(snapshot.data);
                                            return ProfileScreen(
                                              snapshot.data,
                                              userType,
                                            );
                                          }
                                        },
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
                            ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            if (widget.isLocked == true)
                              Icon(
                                Icons.lock,
                                color: Colors.amberAccent[700],
                              ),
                            (widget.isPostMod)
                                ? (spammedFlag)
                                    ? Icon(
                                        Icons.free_cancellation_outlined,
                                        color: Colors.red[800],
                                      )
                                    : (approvedFlag)
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.green[600],
                                          )
                                        : (removedPost)
                                            ? Icon(
                                                Icons.delete_outline,
                                                color: Colors.red[800],
                                              )
                                            : const SizedBox()
                                : const SizedBox(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: (userController.userAbout != null)
                                  ? Options(
                                      onEditChanged: handleEditChanged,
                                      postId: widget.id,
                                      saved: widget.isSaved,
                                      islocked: widget.isLocked,
                                      isMyPost: true, //To be changed
                                      username: widget.name,
                                      onSaveChanged: _handleSaveChanged,
                                      onLockChanged: _handleLockChanged,
                                      onDeleteChanged: handledeleteChanged,
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
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
                              widget.description ?? "",
                              style: const TextStyle(
                                  fontSize: 16, fontFamily: 'Arial'),
                            ),
                          ),

                          //// future
                          ///
                          FutureBuilder(
                              future: fetch,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    color: Colors.white,
                                    child: const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: InkWell(
                                      onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CommentsDesktop(
                                              postId: post!.id,
                                              isModInComment: widget.isPostMod,
                                            ), // pass the post ID here
                                          ),
                                        ),
                                      },
                                      onHover: (value) {
                                        ishovering = value;
                                        setState(() {});
                                      },
                                      child: Card(
                                        color: !ishovering
                                            ? Theme.of(context)
                                                .colorScheme
                                                .background
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                        shadowColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        surfaceTintColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        child: Column(children: <Widget>[
                                          ListTile(
                                            leading: post!.communityName == ''
                                                ? FutureBuilder<void>(
                                                    future: fetchRepostPic,
                                                    builder:
                                                        (BuildContext context,
                                                            AsyncSnapshot<void>
                                                                snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator();
                                                      } else if (snapshot
                                                          .hasError) {
                                                        print("el sora");
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else {
                                                        if (repostProfilePic ==
                                                                null ||
                                                            repostProfilePic!
                                                                .isEmpty) {
                                                          return const CircleAvatar(
                                                            radius: 15,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'images/Greddit.png'),
                                                          );
                                                        } else {
                                                          return CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    repostProfilePic!),
                                                            radius: 15,
                                                          );
                                                        }
                                                      }
                                                    },
                                                  )
                                                : FutureBuilder<void>(
                                                    future: fetchRepostCommPic,
                                                    builder:
                                                        (BuildContext context,
                                                            AsyncSnapshot<void>
                                                                snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator();
                                                      } else if (snapshot
                                                          .hasError) {
                                                        print("el sora");
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      } else {
                                                        if (repostProfilePic ==
                                                                null ||
                                                            repostProfilePic!
                                                                .isEmpty) {
                                                          return const CircleAvatar(
                                                            radius: 15,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'images/Greddit.png'),
                                                          );
                                                        } else {
                                                          return CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    repostProfilePic!),
                                                            radius: 15,
                                                          );
                                                        }
                                                      }
                                                    },
                                                  ),
                                            title: Column(
                                              children: [
                                                Row(children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        (post!.communityName !=
                                                                "")
                                                            ? InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await userController
                                                                      .getUserModerated();
                                                                  bool isMod = userController
                                                                      .userModeratedCommunities!
                                                                      .any((comm) =>
                                                                          comm.name ==
                                                                          post!
                                                                              .communityName);
                                                                  var moderatorProvider =
                                                                      context.read<
                                                                          ModeratorProvider>();
                                                                  if (isMod) {
                                                                    await moderatorProvider.getModAccess(
                                                                        userController
                                                                            .userAbout!
                                                                            .username,
                                                                        post!
                                                                            .communityName);
                                                                  } else {
                                                                    moderatorProvider.moderatorController.modAccess = ModeratorItem(
                                                                        everything:
                                                                            false,
                                                                        managePostsAndComments:
                                                                            false,
                                                                        manageSettings:
                                                                            false,
                                                                        manageUsers:
                                                                            false,
                                                                        username: userController
                                                                            .userAbout!
                                                                            .username);
                                                                  }
                                                                  //IS MOD HENA.
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) => (CommunityLayout(
                                                                                desktopLayout: DesktopCommunityPage(isMod: isMod, communityName: post!.communityName),
                                                                                mobileLayout: MobileCommunityPage(
                                                                                  isMod: isMod,
                                                                                  communityName: post!.communityName,
                                                                                ),
                                                                              ))));
                                                                },
                                                                onHover:
                                                                    (hover) {
                                                                  setState(() {
                                                                    isHovering =
                                                                        hover;
                                                                  });
                                                                },
                                                                child: Text(
                                                                  (post!.communityName) ==
                                                                          "Select Community"
                                                                      ? post!
                                                                          .username
                                                                      : post!
                                                                          .communityName,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Arial'),
                                                                ),
                                                              )
                                                            : InkWell(
                                                                onTap: () => {
                                                                  userType = userController
                                                                              .userAbout!
                                                                              .username ==
                                                                          post!
                                                                              .username
                                                                      ? 'me'
                                                                      : 'other',
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          FutureBuilder<
                                                                              UserAbout?>(
                                                                        future:
                                                                            userService.getUserAbout(post!.username),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          if (snapshot.connectionState ==
                                                                              ConnectionState.waiting) {
                                                                            return Container(
                                                                              color: Colors.white,
                                                                              child: const SizedBox(
                                                                                  height: 30,
                                                                                  width: 30,
                                                                                  child: Center(
                                                                                    child: CircularProgressIndicator(),
                                                                                  )),
                                                                            );
                                                                          } else if (snapshot.hasError) {
                                                                            print(widget.name);
                                                                            print(snapshot.data);
                                                                            return Text('Error: ${snapshot.error}');
                                                                          } else {
                                                                            print(widget.name);
                                                                            print(snapshot.data);
                                                                            return ProfileScreen(
                                                                              snapshot.data,
                                                                              userType,
                                                                            );
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                },
                                                                onHover:
                                                                    (hover) {
                                                                  setState(() {
                                                                    isHovering =
                                                                        hover;
                                                                  });
                                                                },
                                                                child: Text(
                                                                  post!
                                                                      .username,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Arial'),
                                                                ),
                                                              ),
                                                  ),
                                                  Text(
                                                    '  • ${formatDateTime(post!.createdAt.toString())}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255,
                                                            117,
                                                            116,
                                                            115)),
                                                  ),
                                                ]),
                                                if (post!.communityName != "")
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: InkWell(
                                                      onTap: () => {
                                                        userType = userController
                                                                    .userAbout!
                                                                    .username ==
                                                                post!.username
                                                            ? 'me'
                                                            : 'other',
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                FutureBuilder<
                                                                    UserAbout?>(
                                                              future: userService
                                                                  .getUserAbout(
                                                                      post!
                                                                          .username),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return Container(
                                                                    color: Colors
                                                                        .white,
                                                                    child: const SizedBox(
                                                                        height: 30,
                                                                        width: 30,
                                                                        child: Center(
                                                                          child:
                                                                              CircularProgressIndicator(),
                                                                        )),
                                                                  );
                                                                } else if (snapshot
                                                                    .hasError) {
                                                                  print(widget
                                                                      .name);
                                                                  print(snapshot
                                                                      .data);
                                                                  return Text(
                                                                      'Error: ${snapshot.error}');
                                                                } else {
                                                                  print(widget
                                                                      .name);
                                                                  print(snapshot
                                                                      .data);
                                                                  return ProfileScreen(
                                                                    snapshot
                                                                        .data,
                                                                    userType,
                                                                  );
                                                                }
                                                              },
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
                                                        post!.username,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            fontFamily:
                                                                'Arial'),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  post!.title,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Arial'),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  post!.description ?? "",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Arial'),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  );
                                }
                              }),
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
                                    color: upVoteColor,
                                    highlightColor:
                                        Theme.of(context).colorScheme.primary,
                                    icon: const Icon(Icons.arrow_upward_sharp),
                                    onPressed: () {
                                      incrementCounter();
                                    },
                                  ),
                                  Text(
                                    widget.likes.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 20,
                                    color: downVoteColor,
                                    icon: const Icon(
                                        Icons.arrow_downward_outlined),
                                    onPressed: () {
                                      decrementCounter();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (widget.isLocked == false)
                            SizedBox(
                              height: 40.0,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommentsDesktop(
                                          postId: widget.id,
                                          isModInComment: widget.isPostMod,
                                        ), // pass the post ID here
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.messenger_outline,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  label: Text(
                                    widget.commentsCount.toString(),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
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
                              if (!ismobile) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      content: Builder(
                                        builder: ((context) {
                                          return Container(
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.28,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    leading: Text(
                                                      "Share to",
                                                      style: TextStyle(
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.mediation_sharp,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                    title: const Text(
                                                        "Share to Community"),
                                                    onTap: () => {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            scrollable: true,
                                                            content: Builder(
                                                              builder:
                                                                  ((context) {
                                                                return SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.5,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.5,
                                                                  child: SearchCommunityList(
                                                                      postId:
                                                                          widget
                                                                              .id),
                                                                );
                                                              }),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.person,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                    title: const Text(
                                                        "Share to profile"),
                                                    onTap: () => {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            scrollable: true,
                                                            content: Builder(
                                                              builder:
                                                                  ((context) {
                                                                return SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.5,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.5,
                                                                  child:
                                                                      AddtextShare(
                                                                    comName: "",
                                                                    postId:
                                                                        widget
                                                                            .id,
                                                                  ),
                                                                );
                                                              }),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      height: heigth * 0.4,
                                      width: width,
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: Text(
                                              "Share to",
                                              style: TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.mediation_sharp,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            title: const Text(
                                                "Share to Community"),
                                            onTap: () => {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    color: Colors.white,
                                                    height: heigth * 0.9,
                                                    width: width,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: SearchCommunityList(
                                                      postId: widget.id,
                                                    ),
                                                  );
                                                },
                                              ),
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.person,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            title:
                                                const Text("Share to profile"),
                                            onTap: () => {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white),
                                                      height: heigth * 0.8,
                                                      width: width,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: AddtextShare(
                                                        comName: "",
                                                        postId: widget.id,
                                                      ),
                                                    );
                                                  })
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            icon: Icon(Icons.file_upload_outlined,
                                color: Theme.of(context).colorScheme.secondary),
                            label: Text(
                              'Share',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              // Button background color
                              padding: const EdgeInsets.all(6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          widget.isPostMod ? Spacer() : const SizedBox(),
                          widget.isPostMod
                              ? ElevatedButton.icon(
                                  onPressed: () async {
                                    var objection =
                                        context.read<handleObjectionProvider>();
                                    showOptions(
                                      communityName: widget.communityName,
                                      context: context,
                                      isApproved: approvedFlag ?? false,
                                      isRemoved: removedPost ?? false,
                                      lockComments: widget.isLocked ?? false,
                                      removedAsSpam: spammedFlag ?? false,
                                      handleLock: (lock) {
                                        moderatorHandleLock();
                                      },
                                      handleRemoveAsSpam: () async {
                                        await objection.objectItem(
                                            id: widget.id,
                                            itemType: "post",
                                            objectionType: "spammed",
                                            communityName:
                                                widget.communityName);
                                        setState(() {
                                          spammedFlag = true;
                                          approvedFlag = false;
                                          removedPost = false;
                                        });
                                      },
                                      handleApprove: () async {
                                        var queuesProvider = context
                                            .read<handleUnmoderatedProvider>();
                                        await queuesProvider.handleUnmoderated(
                                          objectionType: "unmoderated",
                                          itemType: 'post',
                                          action: 'approve',
                                          communityName: widget.communityName,
                                          itemID: widget.id,
                                        );
                                        setState(() {
                                          approvedFlag = true;
                                          spammedFlag = false;
                                          removedPost = false;
                                        });
                                      },
                                      handleRemovePost:
                                          (removalReaosnTitle) async {
                                        var umoderated = context
                                            .read<handleUnmoderatedProvider>();
                                        await umoderated.handleUnmoderated(
                                          objectionType: "unmoderated",
                                          itemType: 'post',
                                          action: 'remove',
                                          communityName: widget.communityName,
                                          itemID: widget.id,
                                        );

                                        setState(() {
                                          approvedFlag = false;
                                          spammedFlag = false;
                                          removedPost = true;
                                        });
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.shield_outlined,
                                    color: Colors.black,
                                  ),
                                  label: SizedBox(),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}

void showOptions({
  required BuildContext context,
  bool isApproved = false,
  bool isRemoved = false,
  bool removedAsSpam = false,
  bool lockComments = false,
  required String communityName,
  required final Function(bool lock) handleLock,
  required final Function() handleRemoveAsSpam,
  required final Function() handleApprove,
  required final Function(String title) handleRemovePost,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.check,
                color: isApproved ? Colors.grey : Colors.black,
              ),
              title: Text(
                'Approve post',
                style:
                    TextStyle(color: isApproved ? Colors.grey : Colors.black),
              ),
              onTap: isApproved
                  ? null
                  : () {
                      //approve
                      handleApprove();
                      Navigator.of(context).pop();
                    },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.xmark,
                color: isRemoved ? Colors.grey : Colors.black,
              ),
              title: Text(
                'Remove post',
                style: TextStyle(color: isRemoved ? Colors.grey : Colors.black),
              ),
              onTap: isRemoved
                  ? null
                  : () async {
                      //remove
                      await showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (BuildContext context) {
                          return ModalForReasons(
                            handleRemove: (value) {
                              handleRemovePost(value);
                              print("TITLE");
                              print(value);
                            },
                            communityName: "badrmoderatorrrr",
                          );
                        },
                      );
                      Navigator.of(context).pop();
                    },
            ),
            ListTile(
              leading: Icon(
                Icons.free_cancellation_outlined,
                color: removedAsSpam ? Colors.grey : Colors.black,
              ),
              title: Text(
                'Remove as spam',
                style: TextStyle(
                    color: removedAsSpam ? Colors.grey : Colors.black),
              ),
              onTap: removedAsSpam
                  ? null
                  : () {
                      handleRemoveAsSpam();
                      Navigator.of(context).pop();
                      //as spam
                    },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.lock,
                color: lockComments ? Colors.grey : Colors.black,
              ),
              title: Text(
                lockComments ? 'Unlock comments' : 'Lock Comments',
              ),
              onTap: () {
                //lock comments
                handleLock(!lockComments);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
