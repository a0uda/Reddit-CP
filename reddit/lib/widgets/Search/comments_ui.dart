import 'package:flutter/material.dart';

class CommentUI extends StatefulWidget {
  final dynamic comment;
  const CommentUI({super.key, required this.comment});

  @override
  State<CommentUI> createState() => _CommentUIState();
}

class _CommentUIState extends State<CommentUI> {
  late dynamic comment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    comment = widget.comment;
  }

  // {
  //   "_id": "662fbe6d0cec85af670cbbd8",
  //   "post_id": {
  //     "_id": "6624e0ceb67f43e82ce56df5",
  //     "title": "Test8",
  //     "description": "ff",
  //     "created_at": "2024-04-21T09:47:58.302Z",
  //     "community_name": "Thiel___Wolff",
  //     "comments_count": 4,
  //     "upvotes_count": 1,
  //     "user_id": "661ed9a12b42f5ea45ed7f6e",
  //     "username": "m",
  //     "__v": 7
  //   },
  //   "user_id": "662516de07f00cce3c42352a",
  //   "username": "malak",
  //   "created_at": "2024-04-29T15:36:13.653Z",
  //   "description": "test reply2 notcountttttttttttt",
  //   "comment_in_community_flag": false,
  //   "community_name": "Thiel___Wolff",
  //   "upvotes_count": 1,
  // },

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(comment["community_profile_picture"] ?? ""),
                  radius: 12,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "r/${comment["post_id"]["community_name"]}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 11),
                ),
                Text(
                  " · ${comment["post_id"]["created_at"]}",
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(comment["post_id"]["title"]),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 15, 8),
            color: Color.fromARGB(255, 241, 241, 241),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(comment["profile_picture"] ?? ""),
                        radius: 11,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "u/${comment["username"]}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                      Text(
                        " · ${comment["created_at"]}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                    ],
                  ),
                  Text(
                    "${comment["description"]}",
                    style: const TextStyle(fontFamily: "Roboto", fontSize: 12),
                  ),
                  Text(
                    "${comment["upvotes_count"]} upvotes",
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "${comment["post_id"]["upvotes_count"]} upvotes",
                style: TextStyle(color: Colors.grey[600] , fontSize: 11),
              ),
              Text(
                " · ",
                style: TextStyle(color: Colors.grey[600] , fontSize: 14  , fontWeight: FontWeight.bold),
              ),
              Text(
                "${comment["post_id"]["comments_count"]} comments",
                style: TextStyle(color: Colors.grey[600] , fontSize: 11),
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
