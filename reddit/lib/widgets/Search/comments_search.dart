import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Services/search_service.dart';
import 'package:reddit/widgets/Search/comments_ui.dart';

class CommentsSearch extends StatefulWidget {
  final String searchFor;
  const CommentsSearch({super.key, required this.searchFor});

  @override
  State<CommentsSearch> createState() => _CommentsSearchState();
}

class _CommentsSearchState extends State<CommentsSearch> {
  final UserController userController = GetIt.instance.get<UserController>();
  final SearchService searchService = GetIt.instance.get<SearchService>();
  List<Map<String, dynamic>> foundComments = [];
  bool fetched = false;
  String searchFor = "";

  Future<void> fetchPeople() async {
    if (!fetched) {
      searchFor = widget.searchFor;
      foundComments = original;
      fetched = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchFor = widget.searchFor;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchPeople(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('none');
          case ConnectionState.waiting:
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return ListView.builder(
              itemCount: foundComments.length,
              itemBuilder: (BuildContext context, int index) {
                final item = foundComments[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CommentUI(comment: item),
                    ),
                    Divider(
                      color: Colors.grey[300],
                      height: 2,
                    )
                  ],
                );
              },
            );
          default:
            return const Text('badr');
        }
      },
    );
  }
}

List<Map<String, dynamic>> original = [
  {
    "_id": "662fbe6d0cec85af670cbbd8",
    "post_id": {
      "_id": "6624e0ceb67f43e82ce56df5",
      "title": "Test8",
      "description": "ff",
      "created_at": "2024-04-21T09:47:58.302Z",
      "nsfw_flag": true,
      "community_name": "Legros_LLC",
      "comments_count": 4,
      "upvotes_count": 1,
      "user_id": "661ed9a12b42f5ea45ed7f6e",
      "username": "m",
      "__v": 7
    },
    "user_id": "662516de07f00cce3c42352a",
    "username": "malak",
    "created_at": "2024-04-29T15:36:13.653Z",
    "description":
        "test reply2 notcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n\n\n aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaanotcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabadr",
    "comment_in_community_flag": false,
    "community_name": "Legros_LLC",
    "upvotes_count": 1,
  },
  {
    "_id": "662fbe6d0cec85af670cbbd8",
    "post_id": {
      "_id": "6624e0ceb67f43e82ce56df5",
      "title": "Test8",
      "description": "ff",
      "created_at": "2024-04-21T09:47:58.302Z",
      "nsfw_flag": true,
      "community_name": "Legros_LLC",
      "comments_count": 4,
      "upvotes_count": 1,
      "user_id": "661ed9a12b42f5ea45ed7f6e",
      "username": "m",
      "__v": 7
    },
    "user_id": "662516de07f00cce3c42352a",
    "username": "malak",
    "created_at": "2024-04-29T15:36:13.653Z",
    "description":
        "test reply2 notcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n\n\n aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaanotcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabadr",
    "comment_in_community_flag": false,
    "community_name": "Legros_LLC",
    "upvotes_count": 1,
  },
  {
    "_id": "662fbe6d0cec85af670cbbd8",
    "post_id": {
      "_id": "6624e0ceb67f43e82ce56df5",
      "title": "Test8",
      "description": "ff",
      "created_at": "2024-04-21T09:47:58.302Z",
      "nsfw_flag": true,
      "community_name": "Legros_LLC",
      "comments_count": 4,
      "upvotes_count": 1,
      "user_id": "661ed9a12b42f5ea45ed7f6e",
      "username": "m",
      "__v": 7
    },
    "user_id": "662516de07f00cce3c42352a",
    "username": "malak",
    "created_at": "2024-04-29T15:36:13.653Z",
    "description":
        "test reply2 notcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n\n\n aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaanotcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabadr",
    "comment_in_community_flag": false,
    "community_name": "Legros_LLC",
    "upvotes_count": 1,
  },
  {
    "_id": "662fbe6d0cec85af670cbbd8",
    "post_id": {
      "_id": "6624e0ceb67f43e82ce56df5",
      "title": "Test8",
      "description": "ff",
      "created_at": "2024-04-21T09:47:58.302Z",
      "nsfw_flag": true,
      "community_name": "Legros_LLC",
      "comments_count": 4,
      "upvotes_count": 1,
      "user_id": "661ed9a12b42f5ea45ed7f6e",
      "username": "m",
      "__v": 7
    },
    "user_id": "662516de07f00cce3c42352a",
    "username": "malak",
    "created_at": "2024-04-29T15:36:13.653Z",
    "description":
        "test reply2 notcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n\n\n aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaanotcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabadr",
    "comment_in_community_flag": false,
    "community_name": "Legros_LLC",
    "upvotes_count": 1,
  },
  {
    "_id": "662fbe6d0cec85af670cbbd8",
    "post_id": {
      "_id": "6624e0ceb67f43e82ce56df5",
      "title": "Test8",
      "description": "ff",
      "created_at": "2024-04-21T09:47:58.302Z",
      "nsfw_flag": true,
      "community_name": "Legros_LLC",
      "comments_count": 4,
      "upvotes_count": 1,
      "user_id": "661ed9a12b42f5ea45ed7f6e",
      "username": "m",
      "__v": 7
    },
    "user_id": "662516de07f00cce3c42352a",
    "username": "malak",
    "created_at": "2024-04-29T15:36:13.653Z",
    "description":
        "test reply2 notcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n\n\n aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaanotcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabadr",
    "comment_in_community_flag": false,
    "community_name": "Legros_LLC",
    "upvotes_count": 1,
  },
  {
    "_id": "662fbe6d0cec85af670cbbd8",
    "post_id": {
      "_id": "6624e0ceb67f43e82ce56df5",
      "title": "Test8",
      "description": "ff",
      "created_at": "2024-04-21T09:47:58.302Z",
      "nsfw_flag": true,
      "community_name": "Legros_LLC",
      "comments_count": 4,
      "upvotes_count": 1,
      "user_id": "661ed9a12b42f5ea45ed7f6e",
      "username": "m",
      "__v": 7
    },
    "user_id": "662516de07f00cce3c42352a",
    "username": "malak",
    "created_at": "2024-04-29T15:36:13.653Z",
    "description":
        "test reply2 notcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n\n\n aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaanotcounttttttttttttaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabadr",
    "comment_in_community_flag": false,
    "community_name": "Legros_LLC",
    "upvotes_count": 1,
  },
];
