import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/moderator_item.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/Community/community_responsive.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';
import 'package:reddit/widgets/best_listing.dart';
import 'package:reddit/widgets/comments_desktop.dart';

class PostUI extends StatefulWidget {
  final dynamic post;
  const PostUI({super.key, required this.post});

  @override
  State<PostUI> createState() => _PostUIState();
}

class _PostUIState extends State<PostUI> {
  late Map<String, dynamic> post;
  final UserService userService = GetIt.instance.get<UserService>();
  late PostItem? ogPost;

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
        return '${months}mo';
      } else {
        final int years = now.year - parsedDateTime.year;
        return '$years yrs';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    print(post);
    if (post["is_reposted_flag"]) {
      ogPost = post["ogPost"];
    }
    double desktopFactor = MediaQuery.of(context).size.width > 700 ? 1.3 : 1;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentsDesktop(
              postId: post["_id"],
            ),
          ),
        );
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (post["post_in_community_flag"]) {
                          bool isMod = userController
                              .userAbout!.moderatedCommunities!
                              .any((element) =>
                                  element.name == post["community_name"]);
                          var moderatorProvider =
                              context.read<ModeratorProvider>();
                          if (isMod) {
                            await moderatorProvider.getModAccess(
                                userController.userAbout!.username,
                                post["community_name"]);
                          } else {
                            moderatorProvider.moderatorController.modAccess =
                                ModeratorItem(
                                    everything: false,
                                    managePostsAndComments: false,
                                    manageSettings: false,
                                    manageUsers: false,
                                    username:
                                        userController.userAbout!.username);
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => (CommunityLayout(
                                desktopLayout: DesktopCommunityPage(
                                    isMod: isMod,
                                    communityName: post["community_name"]),
                                mobileLayout: MobileCommunityPage(
                                  isMod: isMod,
                                  communityName: post["community_name"],
                                ),
                              )),
                            ),
                          );
                        } else {
                          UserAbout otherUserData = (await (userService
                              .getUserAbout(post["username"])))!;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(otherUserData, 'other'),
                            ),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          (post["community_profile_picture"] != null &&
                                  post["community_profile_picture"] != "")
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      post["community_profile_picture"]),
                                  radius: 12,
                                )
                              : const CircleAvatar(
                                  backgroundImage:
                                      AssetImage("images/Greddit.png"),
                                  radius: 12,
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            post["post_in_community_flag"]
                                ? "r/${post["community_name"] ?? ""}"
                                : "u/${post["username"]}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11 * desktopFactor,
                                fontFamily: 'Roboto'),
                          ),
                          Text(
                            " · ",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14 * desktopFactor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatDateTime(post["created_at"]),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11 * desktopFactor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      post["nsfw_flag"]
                          ? const Icon(
                              Icons.dangerous_sharp,
                              color: Color(0xFFE00096),
                              size: 12,
                            )
                          : const SizedBox(),
                      post["nsfw_flag"]
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                "NSFW",
                                style: TextStyle(
                                    color: const Color(0xFFE00096),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10 * desktopFactor),
                              ),
                            )
                          : const SizedBox(),
                    ]),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      post["title"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15 * desktopFactor),
                    ),
                    (post["description"] != null && post["description"] != "")
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              post["description"],
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 12 * desktopFactor),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              (post.containsKey("images") && post["images"].isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                width: 80.0 * desktopFactor,
                                height: 60.0 * desktopFactor,
                                child: ImageFiltered(
                                  imageFilter: post["nsfw_flag"]
                                      ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                                      : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                  child: Image.network(
                                    post["images"][0]["path"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          (post["is_reposted_flag"]) ///////////////////////////////////repostedd///////////////////////////
              ? Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey[350]!,
                      width: 0.7,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if ((post["is_reposted_flag"] &&
                                        ogPost!.inCommunityFlag!) ||
                                    post["post_in_community_flag"]) {
                                  bool isMod = userController
                                      .userModeratedCommunities!
                                      .any((element) =>
                                          element.name ==
                                          (post["is_reposted_flag"]
                                              ? ogPost?.communityName
                                              : post["community_name"]));

                                  var moderatorProvider =
                                      context.read<ModeratorProvider>();
                                  if (isMod) {
                                    await moderatorProvider.getModAccess(
                                        userController.userAbout!.username,
                                        post["is_reposted_flag"]
                                            ? ogPost?.communityName
                                            : post["community_name"]);
                                  } else {
                                    moderatorProvider
                                            .moderatorController.modAccess =
                                        ModeratorItem(
                                            everything: false,
                                            managePostsAndComments: false,
                                            manageSettings: false,
                                            manageUsers: false,
                                            username: userController
                                                .userAbout!.username);
                                  }

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => (CommunityLayout(
                                        desktopLayout: DesktopCommunityPage(
                                            isMod: isMod,
                                            communityName:
                                                post["is_reposted_flag"]
                                                    ? ogPost?.communityName
                                                    : post["community_name"]),
                                        mobileLayout: MobileCommunityPage(
                                          isMod: isMod,
                                          communityName:
                                              post["is_reposted_flag"]
                                                  ? ogPost?.communityName
                                                  : post["community_name"],
                                        ),
                                      )),
                                    ),
                                  );
                                } else {
                                  UserAbout otherUserData = await (userService
                                      .getUserAbout(post["is_reposted_flag"]
                                          ? ogPost?.username
                                          : post["username"]))!;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileScreen(otherUserData, 'other'),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  (post["is_reposted_flag"] &&
                                          (ogPost?.profilePicture != "" &&
                                              ogPost?.profilePicture != null))
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(post[
                                                  "is_reposted_flag"]
                                              ? ogPost?.profilePicture
                                              : post[
                                                  "community_profile_picture"]),
                                          radius: 12,
                                        )
                                      : const CircleAvatar(
                                          backgroundImage:
                                              AssetImage("images/Greddit.png"),
                                          radius: 12,
                                        ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    post["post_in_community_flag"]
                                        ? "r/${post["is_reposted_flag"] ? ogPost?.communityName : post["community_name"] ?? ""}"
                                        : "u/${post["is_reposted_flag"] ? ogPost?.username : post["username"] ?? ""}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11 * desktopFactor,
                                        fontFamily: 'Roboto'),
                                  ),
                                  Text(
                                    " · ",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14 * desktopFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    formatDateTime(post["is_reposted_flag"]
                                        ? ogPost?.createdAt.toString()
                                        : post["created_at"]),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11 * desktopFactor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(children: [
                              (post["is_reposted_flag"]
                                      ? ogPost?.nsfwFlag
                                      : post["nsfw_flag"])
                                  ? const Icon(
                                      Icons.dangerous_sharp,
                                      color: Color(0xFFE00096),
                                      size: 12,
                                    )
                                  : const SizedBox(),
                              (post["is_reposted_flag"]
                                      ? ogPost?.nsfwFlag
                                      : post["nsfw_flag"])
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        "NSFW",
                                        style: TextStyle(
                                            color: const Color(0xFFE00096),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10 * desktopFactor),
                                      ),
                                    )
                                  : const SizedBox(),
                            ]),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              post["is_reposted_flag"]
                                  ? ogPost?.title
                                  : post["title"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  fontSize: 16 * desktopFactor),
                            ),
                            post["is_reposted_flag"]
                                ? (ogPost?.description != null &&
                                        ogPost?.description != "")
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          ogPost?.description ?? "",
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 12 * desktopFactor),
                                        ),
                                      )
                                    : const SizedBox()
                                : (post["description"] != null &&
                                        post["description"] != "")
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          post["description"],
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 12 * desktopFactor),
                                        ),
                                      )
                                    : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    post["type"] == "polls"
                                        ? ""
                                        : "${post["upvotes_count"]} upvotes",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 11 * desktopFactor),
                                  ),
                                  Text(
                                    " · ",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14 * desktopFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    post["type"] == "polls"
                                        ? ""
                                        : "${post["comments_count"]} comments",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 11 * desktopFactor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      (post["is_reposted_flag"]
                              ? (ogPost?.images != null &&
                                  ogPost!.images!.isNotEmpty)
                              : (post.containsKey("images") &&
                                  post["images"].isNotEmpty))
                          ? Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        width: 80.0 * desktopFactor,
                                        height: 60.0 * desktopFactor,
                                        child: ImageFiltered(
                                          imageFilter: (post["is_reposted_flag"]
                                                  ? ogPost?.nsfwFlag
                                                  : post["nsfw_flag"])
                                              ? ImageFilter.blur(
                                                  sigmaX: 5, sigmaY: 5)
                                              : ImageFilter.blur(
                                                  sigmaX: 0, sigmaY: 0),
                                          child: Image.network(
                                            post["is_reposted_flag"]
                                                ? ogPost?.images![0].path
                                                : post["images"][0]["path"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Text(
                  post["type"] == "polls"
                      ? ""
                      : "${post["upvotes_count"]} upvotes",
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 11 * desktopFactor),
                ),
                Text(
                  " · ",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14 * desktopFactor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  post["type"] == "polls"
                      ? ""
                      : "${post["comments_count"]} comments",
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 11 * desktopFactor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
