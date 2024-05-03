import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
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
    post = widget.post;
  }

// {
//     "_id": "6633921be1b754c2c9163cad",
//     "title": "fvfvv vestigium voluntarius ater audax admitto ",
//     "description": "ff",
//     "created_at": "2024-05-02T13:16:12.804Z",
//     "type": "url",
//     "link_url": "https://www.youtuddbej.com",
//     "images": [],
//     "polls": [],
//     "polls_voting_length": 3,
//     "polls_voting_is_expired_flag": false,
//     "post_in_community_flag": true,
//     "community_name": "malaktest2",
//     "comments_count": 0,
//     "upvotes_count": 1,
//     "spoiler_flag": false,
//     "nsfw_flag": false,
//     "is_reposted_flag": false,
//     "community_id": "6631dd3e6c674a78abcebbc3",
//     "user_id": "662516de07f00cce3c42352a",
//     "username": "malak",
//   }
  @override
  Widget build(BuildContext context) {
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
                      onTap: () {
                        bool isMod = userController
                            .userAbout!.moderatedCommunities!
                            .any((element) =>
                                element.name == post["community_name"]);
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
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                post["community_profile_picture"] ?? ""),
                            radius: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "r/${post["community_name"]}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11 * desktopFactor,
                                fontFamily: 'Roboto'),
                          ),
                          Text(
                            " · ",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14 * desktopFactor ,
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
                      height: 2,
                    ),
                    Text(
                      post["title"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          fontSize: 16 * desktopFactor),
                    ),
                    (post.containsKey("description") &&
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
                  ],
                ),
              ),
              (post.containsKey("profile_picture") &&
                      post["profile_picture"] != "")
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
                                child: Image.network(
                                  post["profile_picture"],
                                  fit: BoxFit.cover,
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
          (post["is_reposted_flag"])
              ? Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.grey[350]!,
                      width: 0.5,
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
                              onTap: () {
                                bool isMod = userController
                                    .userAbout!.moderatedCommunities!
                                    .any((element) =>
                                        element.name == post["community_name"]);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => (CommunityLayout(
                                      desktopLayout: DesktopCommunityPage(
                                          isMod: isMod,
                                          communityName:
                                              post["community_name"]),
                                      mobileLayout: MobileCommunityPage(
                                        isMod: isMod,
                                        communityName: post["community_name"],
                                      ),
                                    )),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        post["community_profile_picture"] ??
                                            ""),
                                    radius: 12,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "r/${post["community_name"]}",
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
                              height: 4,
                            ),
                            Text(
                              post["title"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15 * desktopFactor),
                            ),
                            (post.containsKey("description") &&
                                    post["description"] != "")
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
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "${post["upvotes_count"]} upvotes",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 11 * desktopFactor),
                                  ),
                                  Text(
                                    " · ",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14 * desktopFactor ,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${post["comments_count"]} comments",
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
                      (post.containsKey("profile_picture") &&
                              post["profile_picture"] != "")
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
                                        child: Image.network(
                                          post["profile_picture"],
                                          fit: BoxFit.cover,
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
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                Text(
                  "${post["upvotes_count"]} upvotes",
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 11 * desktopFactor),
                ),
                Text(
                  " · ",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14*desktopFactor*2,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${post["comments_count"]} comments",
                  style: TextStyle(color: Colors.grey[600], fontSize: 11*desktopFactor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
