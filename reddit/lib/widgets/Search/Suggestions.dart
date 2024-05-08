import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/moderator_item.dart';
import 'package:reddit/Services/search_service.dart';
import 'package:reddit/widgets/Community/community_responsive.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';

class SuggestCommunities extends StatefulWidget {
  final String search;
  const SuggestCommunities({super.key, required this.search});

  @override
  State<SuggestCommunities> createState() => _SuggestCommunitiesState();
}

class _SuggestCommunitiesState extends State<SuggestCommunities> {
  List<Map<String, dynamic>> communities = [];
  List<Map<String, dynamic>> foundCommunities = [];
  final SearchService searchService = GetIt.instance.get<SearchService>();
  final UserController userController = GetIt.instance.get<UserController>();
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();

  Future<void> fetchCommunities() async {
    if (widget.search != "") {
      foundCommunities =
          await searchService.getSearchCommunities(widget.search, 1, 5);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchCommunities(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('none');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                foundCommunities.isNotEmpty
                    ? const Text(
                        "Communities",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      )
                    : const SizedBox(),
                ...foundCommunities.map(
                  (community) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ListTile(
                      onTap: () async {
                        moderatorController.profilePictureURL =
                            community["profile_picture"];

                        await userController.getUserModerated();
                        bool isMod = userController.userModeratedCommunities!
                            .any((comm) => comm.name == community["name"]);
                        var moderatorProvider =
                            context.read<ModeratorProvider>();
                        if (isMod) {
                          await moderatorProvider.getModAccess(
                              userController.userAbout!.username,
                              community["name"]);
                        } else {
                          moderatorProvider.moderatorController.modAccess =
                              ModeratorItem(
                                  everything: false,
                                  managePostsAndComments: false,
                                  manageSettings: false,
                                  manageUsers: false,
                                  username: userController.userAbout!.username);
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => (CommunityLayout(
                                  desktopLayout: DesktopCommunityPage(
                                      isMod: isMod,
                                      communityName: community["name"]),
                                  mobileLayout: MobileCommunityPage(
                                    isMod: isMod,
                                    communityName: community["name"],
                                  ),
                                ))));
                      },
                      leading: (community.containsKey("profile_picture") &&
                              community["profile_picture"] != "")
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(community["profile_picture"]),
                              radius: 13,
                            )
                          : const CircleAvatar(
                              backgroundImage:
                                  AssetImage("images/default_reddit.png"),
                              radius: 13,
                            ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "r/${community["name"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${community["members_count"].toString()} members",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
