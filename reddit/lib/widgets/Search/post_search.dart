import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Services/search_service.dart';
import 'package:reddit/widgets/Search/comments_ui.dart';

class PostSearch extends StatefulWidget {
  final String searchFor;
  const PostSearch({super.key, required this.searchFor});

  @override
  State<PostSearch> createState() => _CommentsSearchState();
}

class _CommentsSearchState extends State<PostSearch> {
  final UserController userController = GetIt.instance.get<UserController>();
  final SearchService searchService = GetIt.instance.get<SearchService>();
  List<Map<String, dynamic>> foundPosts = [];
  bool fetched = false;
  String searchFor = "";

  Future<void> fetchPeople() async {
    if (!fetched) {
      searchFor = widget.searchFor;
      foundPosts = originalposts;
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
              itemCount: foundPosts.length,
              itemBuilder: (BuildContext context, int index) {
                final item = foundPosts[index];
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

List<Map<String, dynamic>> originalposts = [
  {
    "_id": "6633921be1b754c2c9163cad",
    "title": "fvfvv vestigium voluntarius ater audax admitto ",
    "description": "ff",
    "created_at": "2024-05-02T13:16:12.804Z",
    "type": "url",
    "link_url": "https://www.youtuddbej.com",
    "images": [],
    "polls": [],
    "polls_voting_length": 3,
    "polls_voting_is_expired_flag": false,
    "post_in_community_flag": true,
    "community_name": "malaktest2",
    "comments_count": 0,
    "upvotes_count": 1,
    "downvotes_count": 0,
    "oc_flag": false,
    "spoiler_flag": false,
    "nsfw_flag": false,
    "locked_flag": false,
    "allowreplies_flag": true,
    "set_suggested_sort": "None (Recommended)",
    "scheduled_flag": false,
    "is_reposted_flag": false,
    "community_id": "6631dd3e6c674a78abcebbc3",
    "user_id": "662516de07f00cce3c42352a",
    "username": "malak",
    "__v": 0
  }
];
