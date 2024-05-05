import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/Community/community_responsive.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';
import 'package:reddit/widgets/best_listing.dart';
import 'package:reddit/widgets/comments_desktop.dart';

class CommentUI extends StatefulWidget {
  final dynamic comment;
  const CommentUI({super.key, required this.comment});

  @override
  State<CommentUI> createState() => _CommentUIState();
}

class _CommentUIState extends State<CommentUI> {
  late dynamic comment;
  final UserService userService = GetIt.instance.get<UserService>();

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
    comment = widget.comment;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentsDesktop(
              postId: comment["post_id"]["_id"],
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              bool isMod = userController.userAbout!.moderatedCommunities!.any(
                  (element) =>
                      element.name == comment["post_id"]["community_name"]);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => (CommunityLayout(
                    desktopLayout: DesktopCommunityPage(
                        isMod: isMod,
                        communityName: comment["post_id"]["community_name"]),
                    mobileLayout: MobileCommunityPage(
                      isMod: isMod,
                      communityName: comment["post_id"]["community_name"],
                    ),
                  )),
                ),
              );
            },
            child: Row(
              children: [
                (comment["community_profile_picture"] != null &&
                        comment["community_profile_picture"] != "")
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(comment["community_profile_picture"]),
                        radius: 12,
                      )
                    : const CircleAvatar(
                        backgroundImage:
                            AssetImage("images/default_reddit.png"),
                        radius: 12,
                      ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  comment["post_id"]["post_in_community_flag"]
                      ? "r/${comment["post_id"]["community_name"]}"
                      : "u/${comment["post_id"]["username"]}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      fontFamily: 'Roboto'),
                ),
                Text(
                  " · ",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  formatDateTime(comment["post_id"]["created_at"]),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(children: [
            comment["post_id"]["nsfw_flag"]
                ? const Icon(
                    Icons.dangerous_sharp,
                    color: Color(0xFFE00096),
                    size: 12,
                  )
                : const SizedBox(),
            comment["post_id"]["nsfw_flag"]
                ? const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      "NSFW",
                      style: TextStyle(
                          color: Color(0xFFE00096),
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  )
                : const SizedBox(),
          ]),
          const SizedBox(
            height: 5,
          ),
          Text(comment["post_id"]["title"]),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 15, 8),
            color: const Color.fromARGB(255, 241, 241, 241),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      (comment["profile_picture"] != null &&
                              comment["profile_picture"] != "")
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(comment["profile_picture"]),
                              radius: 11,
                            )
                          : const CircleAvatar(
                              backgroundImage: AssetImage("images/Greddit.png"),
                              radius: 11,
                            ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () async {
                          UserAbout otherUserData = (await (userService
                              .getUserAbout(comment["username"])))!;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(otherUserData, 'other'),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "u/${comment["username"]}",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 11),
                            ),
                            Text(
                              " · ",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " ${formatDateTime(comment["created_at"])}",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    constraints:
                        const BoxConstraints(maxHeight: 140, minHeight: 0),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: const [Colors.black, Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: bounds.height > 135
                              ? [0.8, 1.0]
                              : [1, 1], // Adjust to control where fading starts
                        ).createShader(
                            Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Text(
                        comment["description"].length > 600
                            ? "${comment["description"].substring(0, 600)}"
                            : "${comment["description"]}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto",
                            fontSize: 12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "${comment["upvotes_count"]} upvotes",
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "${comment["post_id"]["upvotes_count"]} upvotes",
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
              Text(
                " · ",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${comment["post_id"]["comments_count"]} comments",
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
