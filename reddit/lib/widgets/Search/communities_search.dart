import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/Services/search_service.dart';
import 'package:reddit/widgets/Community/community_responsive.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';

class CommunitiesSearch extends StatefulWidget {
  final String searchFor;
  const CommunitiesSearch({super.key, required this.searchFor});

  @override
  State<CommunitiesSearch> createState() => _CommunitiesSearchState();
}

class _CommunitiesSearchState extends State<CommunitiesSearch> {
  List<CommunityBackend> joined = [];
  final UserController userController = GetIt.instance.get<UserController>();
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  final SearchService searchService = GetIt.instance.get<SearchService>();
  List<Map<String, dynamic>> foundCommunities = [];
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;
  String searchFor = "";

  Future<void> fetchCommunities() async {
    searchFor = widget.searchFor;

    setState(() {
      isLoading = true;
    });
    foundCommunities
        .addAll(await searchService.getSearchCommunities(searchFor, page, 10));
    print("IDD");
    print(userController.userAbout!.id);
    if (userController.userCommunities == null) {
      await userController.getUserCommunities();
      joined = userController.userCommunities!;
    } else {
      joined = userController.userCommunities!;
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToCommunity(String name, String pp) {
    List<CommunityBackend> moderated =
        userController.userAbout!.moderatedCommunities ?? [];
    moderatorController.profilePictureURL = pp;
    bool isMod = moderated.any((element) => element.name == name);
    moderatorController.communityName = name;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => (CommunityLayout(
          desktopLayout:
              DesktopCommunityPage(isMod: isMod, communityName: name),
          mobileLayout: MobileCommunityPage(
            isMod: isMod,
            communityName: name,
          ),
        )),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchFor = widget.searchFor;
    fetchCommunities();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      page++;
      fetchCommunities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: foundCommunities.length + (isLoading ? 1 : 0),
      itemBuilder: (context, int index) {
        if (index < foundCommunities.length) {
          final item = foundCommunities[index];
          String description = item["general_settings"]["description"];
          if (description.length > 80) {
            description = "${description.substring(0, 80)}...";
          }
          bool isJoined = joined.any((element) => element.name == item["name"]);
          return Column(
            children: [
              ListTile(
                onTap: () {
                  navigateToCommunity(item["name"], item["profile_picture"]);
                },
                tileColor: Colors.white,
                leading: (item["profile_picture"] != null &&
                        item["profile_picture"] != "")
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(item["profile_picture"]),
                        radius: 15,
                      )
                    : const CircleAvatar(
                        backgroundImage:
                            AssetImage("images/default_reddit.png"),
                        radius: 15,
                      ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "r/${item["name"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        item["general_settings"]["nsfw_flag"]
                            ? const Icon(
                                Icons.dangerous_sharp,
                                color: Color(0xFFE00096),
                                size: 13,
                              )
                            : const SizedBox(),
                        item["general_settings"]["nsfw_flag"]
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
                          '${item["members_count"]} members',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 10),
                        ),
                      ],
                    ),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    ),
                  ],
                ),
                trailing: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  //check typr of community
                  return ElevatedButton(
                    onPressed: () async {
                      if (!isJoined) {
                        setState(() {
                          isJoined = true;
                        });
                        // await followerfollowingcontroller
                        //     .followUser(item["username"]);
                      } else {
                        setState(() {
                          isJoined = false;
                        });
                        // await followerfollowingcontroller
                        //     .unfollowUser(item["username"]);
                      }
                      //badrrrr followw
                    },
                    style: ElevatedButton.styleFrom(
                      side: isJoined
                          ? const BorderSide(
                              color: Color.fromARGB(255, 3, 55, 146),
                            )
                          : null,
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      backgroundColor: isJoined
                          ? Colors.white
                          : const Color.fromARGB(255, 3, 55, 146),
                      foregroundColor: isJoined
                          ? const Color.fromARGB(255, 3, 55, 146)
                          : Colors.white,
                    ),
                    child: isJoined ? const Text("Joined") : const Text("Join"),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Divider(
                  height: 1,
                  color: Colors.grey[300],
                ),
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
    "_id": "6629881c676aa6854cccdf8a",
    "name": "malaktest",
    "members_count": 0,
    "general_settings": {
      "description":
          "Arto damnatio inventore constans vilicus depono thema vulnus patruus. Vester defaeco varius comburo strenuus. Nisi ocer aureus deinde voluptas ago congregatio corporis catena argumentum. Hic ullam coaegresco statim communis deludo pauper vomer votum. Dicta veritas clam aeternus asperiores adipisci talus tripudio consequuntur.",
      "type": "Public",
      "nsfw_flag": false,
    },
    "profile_picture": "Greddit.png",
  },
  {
    "_id": "6629881c676aa6854cccdf8a",
    "name": "Legros_LLC",
    "members_count": 500,
    "general_settings": {
      "description":
          "Arto damnatio inventore constans vilicus depono thema vulnus patruus. Vester defaeco varius comburo strenuus. Nisi ocer aureus deinde voluptas ago congregatio corporis catena argumentum. Hic ullam coaegresco statim communis deludo pauper vomer votum. Dicta veritas clam aeternus asperiores adipisci talus tripudio consequuntur.",
      "type": "Public",
      "nsfw_flag": true,
    },
    "profile_picture": "Greddit.png",
  },
  {
    "_id": "6629881c676aa6854cccdf8a",
    "name": "malaktest",
    "members_count": 0,
    "general_settings": {
      "description":
          "Arto damnatio inventore constans vilicus depono thema vulnus patruus. Vester defaeco varius comburo strenuus. Nisi ocer aureus deinde voluptas ago congregatio corporis catena argumentum. Hic ullam coaegresco statim communis deludo pauper vomer votum. Dicta veritas clam aeternus asperiores adipisci talus tripudio consequuntur.",
      "type": "Public",
      "nsfw_flag": true,
    },
    "profile_picture": "Greddit.png",
  },
];
