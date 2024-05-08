import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/Models/moderator_item.dart';
import 'package:reddit/widgets/Community/community_responsive.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';
import 'package:reddit/widgets/Create%20Community/create_community_desktop.dart';
import 'package:reddit/widgets/Create%20Community/create_community_page.dart';

void navigateToCommunity(Widget communityPage, BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => (communityPage)));
}

class DrawerTile extends StatefulWidget {
  final List<CommunityBackend> lists;
  final String tileTitle;
  final bool isMod;
  const DrawerTile(
      {super.key,
      required this.tileTitle,
      required this.lists,
      required this.isMod});

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  bool isExpanded = false;
  bool communitiesFetched = false;
  final UserController userController = GetIt.instance.get<UserController>();
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  List<CommunityBackend> lists = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        ListTile(
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
          ),
          title: Text(
            widget.tileTitle,
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        Visibility(
            visible: isExpanded,
            child: Column(
              children: [
                !widget.isMod
                    ? ListTile(
                        leading: const Icon(Icons.add, color: Colors.black),
                        title: const Text("Create Community"),
                        onTap: () {
                          screenWidth > 700
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CreateCommunityPopup();
                                  })
                              : Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CreateCommunity(),
                                ));
                        },
                      )
                    : const SizedBox(),
                AnimatedOpacity(
                  opacity: isExpanded ? 1.0 : 0.0,
                  duration: const Duration(seconds: 0),
                  curve: Curves.bounceInOut,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      print("hnaaa");
                      final item = widget.lists[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(item.profilePictureURL),
                          radius: 10,
                        ),
                        title: Text(item.name),
                        onTap: () async {
                          moderatorController.profilePictureURL =
                              item.profilePictureURL;
                          await userController.getUserModerated();
                          bool isMod = userController.userModeratedCommunities!
                              .any((comm) => comm.name == item.name);
                          var moderatorProvider =
                              context.read<ModeratorProvider>();
                          if (isMod) {
                            await moderatorProvider.getModAccess(
                                userController.userAbout!.username, item.name);
                          } else {
                            moderatorProvider.moderatorController.modAccess =
                                ModeratorItem(
                                    everything: false,
                                    managePostsAndComments: false,
                                    manageSettings: false,
                                    manageUsers: false,
                                    username:
                                        userController.userAbout!.username);
                          }
                          //IS MOD HENA.
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => (CommunityLayout(
                                    desktopLayout: DesktopCommunityPage(
                                        isMod: isMod, communityName: item.name),
                                    mobileLayout: MobileCommunityPage(
                                      isMod: isMod,
                                      communityName: item.name,
                                    ),
                                  ))));
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => (DesktopCommunityPage(
                          //           //communityMembersNo: item.membersCount,
                          //           communityName: item.name,
                          //           //communityProfilePicturePath:
                          //             //  item.profilePictureURL,
                          //             isMod: false,
                          //         ))));
                        },
                      );
                    },
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
