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
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();
  final SearchService searchService = GetIt.instance.get<SearchService>();
  List<Map<String, dynamic>> foundUsers = [];
  bool fetched = false;
  String searchFor = "";

  Future<void> fetchPeople() async {
    if (!fetched) {
      searchFor = widget.searchFor;
      for (var org in original) {
        if (org["username"].toLowerCase().contains(searchFor.toLowerCase())) {
          foundUsers.add(org);
        }

        var followerfollowingcontroller =
            context.read<FollowerFollowingController>();

        if (followerfollowingcontroller.following == null) {
          following = await followerfollowingcontroller
              .getFollowing(userController.userAbout!.username);
        } else {
          following = followerfollowingcontroller.following!;
        }
        fetched = true;
      }
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
              itemCount: foundUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final item = foundUsers[index];
                bool isFollowing =
                    following.any((user) => user.username == item["username"]);
                final createdAt = DateTime.parse(item["created_at"]!);
                return Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        UserAbout otherUserData = (await (userService
                            .getUserAbout(item["username"])))!;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(otherUserData, 'other'),
                          ),
                        );
                      },
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(item["profile_picture"]!),
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
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 10),
                              ),
                            ],
                          )
                        ],
                      ),
                      trailing: item["profile_settings"]["allow_followers"]
                          ? StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                              return ElevatedButton(
                                onPressed: () async {
                                  var followerfollowingcontroller = context
                                      .read<FollowerFollowingController>();

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
                                          color:
                                              Color.fromARGB(255, 0, 69, 172),
                                        )
                                      : null,
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 8, 14, 8),
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
];
