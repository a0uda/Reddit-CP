import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Services/moderator_service.dart';
import 'package:reddit/Services/search_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/Search/comments_ui.dart';

class CommentsSearch extends StatefulWidget {
  final String searchFor;
  final String name;
  final bool inComm;
  const CommentsSearch(
      {super.key,
      required this.searchFor,
      required this.inComm,
      this.name = ""});

  @override
  State<CommentsSearch> createState() => _CommentsSearchState();
}

class _CommentsSearchState extends State<CommentsSearch> {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();
  final SearchService searchService = GetIt.instance.get<SearchService>();
  final ModeratorMockService moderatorService =
      GetIt.instance.get<ModeratorMockService>();
  String selectedOption = "relevance";
  List<Map<String, dynamic>> foundComments = [];
  List<Map<String, dynamic>> temp = [];

  String searchFor = "";
  int pageNum = 1;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  Future<void> getExtraData(Map<String, dynamic> comment) async {
    if (comment["post_id"]["post_in_community_flag"]) {
      Map<String, dynamic> comm = await moderatorService.getCommunityInfo(
          communityName: comment["post_id"]["community_name"]);
      comment["community_profile_picture"] = comm["communityProfilePicture"];
    } else {
      UserAbout? userInPost =
          await userService.getUserAbout(comment["post_id"]["username"]);
      if (userInPost != null) {
        comment["community_profile_picture"] = userInPost.profilePicture!;
      }
    }
    //getprofilesettings -> pp
    UserAbout? userInComment =
        await userService.getUserAbout(comment["username"]);
    if (userInComment != null) {
      comment["profile_picture"] = userInComment.profilePicture!;
    }
  }

  Future<void> fetchComments() async {
    searchFor = widget.searchFor;
    setState(() {
      isLoading = true;
    });
    if (widget.inComm) {
      temp = await searchService.getCommentsInCommunity(
          searchFor, pageNum, selectedOption, widget.name);
    } else {
      temp = await searchService.getSearchComments(
          searchFor, pageNum, selectedOption);
    }
    List<Future<void>> futures =
        temp.map((comment) => getExtraData(comment)).toList();
    await Future.wait(futures);

    foundComments.addAll(temp);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchFor = widget.searchFor;
    fetchComments();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      print("tab ehh");
      pageNum++;
      fetchComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (foundComments.isNotEmpty) {
      return ListView.builder(
        controller: scrollController,
        itemCount: foundComments.length + (isLoading ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index < foundComments.length) {
            final item = foundComments[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 10, bottom: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(13),
                                      child: IntrinsicHeight(
                                        child: Column(
                                          children: [
                                            const ListTile(
                                              title: Text('Sort by'),
                                            ),
                                            RadioListTile(
                                              title:
                                                  const Text('Most relevant'),
                                              value: 'relevance',
                                              activeColor: Colors.black,
                                              groupValue: selectedOption,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedOption = value!;
                                                });
                                                Navigator.of(context).pop();
                                                foundComments = [];
                                                fetchComments();
                                                //fetch tany
                                              },
                                            ),
                                            RadioListTile(
                                              title: const Text('New'),
                                              value: 'new',
                                              groupValue: selectedOption,
                                              activeColor: Colors.black,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedOption = value!;
                                                });
                                                Navigator.of(context).pop();
                                                foundComments = [];
                                                fetchComments();
                                              },
                                            ),
                                            RadioListTile(
                                              title: const Text('Top'),
                                              value: 'top',
                                              groupValue: selectedOption,
                                              activeColor: Colors.black,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedOption = value!;
                                                });
                                                Navigator.of(context).pop();
                                                foundComments = [];
                                                fetchComments();
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey[300],
                              surfaceTintColor: Colors.grey[300]),
                          child: const Text(
                            "Sort",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : const SizedBox(),
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
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(13),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                const ListTile(
                                  title: Text('Sort by'),
                                ),
                                RadioListTile(
                                  title: const Text('Most relevant'),
                                  value: 'relevance',
                                  activeColor: Colors.black,
                                  groupValue: selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                    Navigator.of(context).pop();
                                    foundComments = [];
                                    fetchComments();
                                    //fetch tany
                                  },
                                ),
                                RadioListTile(
                                  title: const Text('New'),
                                  value: 'new',
                                  groupValue: selectedOption,
                                  activeColor: Colors.black,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                    Navigator.of(context).pop();
                                    foundComments = [];
                                    fetchComments();
                                  },
                                ),
                                RadioListTile(
                                  title: const Text('Top'),
                                  value: 'top',
                                  groupValue: selectedOption,
                                  activeColor: Colors.black,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                    Navigator.of(context).pop();
                                    foundComments = [];
                                    fetchComments();
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey[300],
                  surfaceTintColor: Colors.grey[300]),
              child: const Text(
                "Sort",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
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
