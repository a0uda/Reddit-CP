import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/search_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/best_listing.dart';

class PeopleList extends StatefulWidget {
  final String searchFor;
  const PeopleList({super.key, required this.searchFor});

  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  List<FollowersFollowingItem> following = [];
  ScrollController scrollController = ScrollController();
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();
  final SearchService searchService = GetIt.instance.get<SearchService>();
  List<Map<String, dynamic>> foundUsers = [];
  List<Map<String, dynamic>> temp = [];
  bool isLoading = false;
  int page = 1;
  String searchFor = "";

  Future<void> fetchPeople() async {
    searchFor = widget.searchFor;
    var followerfollowingcontroller =
        context.read<FollowerFollowingController>();

    setState(() {
      isLoading = true;
    });
    temp = await searchService.getSearchUsers(searchFor, page);
    foundUsers.addAll(temp);
    if (followerfollowingcontroller.following.isEmpty) {
      following = await followerfollowingcontroller
          .getFollowing(userController.userAbout!.username);
    } else {
      following = followerfollowingcontroller.following!;
    }
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
    fetchPeople();
    searchFor = widget.searchFor;
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      page++;
      fetchPeople();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: foundUsers.length + (isLoading ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index < foundUsers.length) {
          final item = foundUsers[index];
          bool isFollowing =
              following.any((user) => user.username == item["username"]);
          final createdAt = DateTime.parse(item["created_at"]!);
          return Column(
            children: [
              ListTile(
                onTap: () async {
                  UserAbout otherUserData =
                      (await (userService.getUserAbout(item["username"])))!;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(otherUserData, 'other'),
                    ),
                  );
                },
                tileColor: Colors.white,
                leading: (item["profile_picture"] != null &&
                        item["profile_picture"] != "")
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(item["profile_picture"]),
                        radius: 15,
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage("images/Greddit.png"),
                        radius: 15,
                      ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "u/${item["username"]!}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        item["profile_settings"]["nsfw_flag"]
                            ? const Icon(
                                Icons.dangerous_sharp,
                                color: Color(0xFFE00096),
                                size: 13,
                              )
                            : const SizedBox(),
                        item["profile_settings"]["nsfw_flag"]
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
                        Text(
                          '${createdAt.day}-${createdAt.month}-${createdAt.year}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 10),
                        ),
                      ],
                    )
                  ],
                ),
                trailing: item["profile_settings"]["allow_followers"]
                    ? StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                        return ElevatedButton(
                          onPressed: () async {
                            var followerfollowingcontroller =
                                context.read<FollowerFollowingController>();

                            if (!isFollowing) {
                              setState(() {
                                isFollowing = true;
                              });
                              await followerfollowingcontroller
                                  .followUser(item["username"]);
                            } else {
                              setState(() {
                                isFollowing = false;
                              });
                              await followerfollowingcontroller
                                  .unfollowUser(item["username"]);
                            }
                            //badrrrr followw
                          },
                          style: ElevatedButton.styleFrom(
                            side: isFollowing
                                ? const BorderSide(
                                    color: Color.fromARGB(255, 0, 69, 172),
                                  )
                                : null,
                            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                            backgroundColor: isFollowing
                                ? Colors.white
                                : const Color.fromARGB(255, 0, 69, 172),
                            foregroundColor: isFollowing
                                ? const Color.fromARGB(255, 0, 69, 172)
                                : Colors.white,
                          ),
                          child: isFollowing
                              ? const Text("Unfollow")
                              : const Text("Follow"),
                        );
                      })
                    : null,
              ),
              Divider(
                height: 1,
                color: Colors.grey[300],
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
  }
}

List<Map<String, dynamic>> original = [
  {
    "_id": "1234",
    "username": "badr",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": false,
      "allow_followers": true,
    },
  },
  {
    "_id": "1234",
    "username": "halla",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": false,
      "allow_followers": true,
    },
  },
  {
    "_id": "1234",
    "username": "aywa",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": false,
      "allow_followers": true,
    },
  },
  {
    "_id": "1234",
    "username": "ba2a",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": false,
      "allow_followers": false,
    },
  },
  {
    "_id": "1234",
    "username": "wayyyyydd",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": false,
      "allow_followers": true,
    },
  },
  {
    "_id": "1234",
    "username": "nice",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": true,
      "allow_followers": true,
    },
  },
  {
    "_id": "1234",
    "username": "halla",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": false,
      "allow_followers": true,
    },
  },
  {
    "_id": "1234",
    "username": "aywa",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": false,
      "allow_followers": true,
    },
  },
  {
    "_id": "1234",
    "username": "ba2a",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": false,
      "allow_followers": false,
    },
  },
  {
    "_id": "1234",
    "username": "wayyyyydd",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": false,
      "allow_followers": true,
    },
  },
  {
    "_id": "1234",
    "username": "nice",
    "profile_picture": "",
    "created_at": "2024-04-21T13:38:34.445Z",
    "profile_settings": {
      "nsfw_flag": true,
      "allow_followers": true,
    },
  },
];
