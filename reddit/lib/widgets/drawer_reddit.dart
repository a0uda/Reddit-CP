import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/widgets/drawer_tile.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';
import 'package:reddit/widgets/desktop_layout.dart';

class DrawerReddit extends StatefulWidget {
  final int indexOfPage;
  final bool inHome;

  const DrawerReddit(
      {super.key, required this.indexOfPage, required this.inHome});

  @override
  State<DrawerReddit> createState() => _DrawerRedditState();
}

class _DrawerRedditState extends State<DrawerReddit> {
  bool userMod = true, isExpanded = false;
  final CommunityController communityController =
      GetIt.instance.get<CommunityController>();
  final UserController userController = GetIt.instance.get<UserController>();
  List<Map<String, dynamic>> communitiesDrawer = [];

  Future<void> fetchUserCommunities() async {
    if (userController.userAbout != null) {
      await userController.getUserCommunities();
      print("henaa");
      print(userController.userCommunities);
      await userController.getUserModerated();
      print("moderated");
    }
  }

  @override
  void initState() {
    super.initState();
    //fetchCommunities();
  }

  // Future<void> fetchCommunities() async {
  //   for (CommunityItem community in communities) {
  //     communityController.getCommunity(community.general.communityName);
  //     if (communityController.communityItem != null) {
  //       communitiesDrawer.add({
  //         'name': communityController.communityItem!.general.communityName,
  //         'communityPage': CommunityPage(
  //           communityMembersNo:
  //               communityController.communityItem!.communityMembersNo,
  //           communityName:
  //               communityController.communityItem!.general.communityName,
  //           communityProfilePicturePath:
  //               communityController.communityItem!.communityProfilePicturePath,
  //         ),
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0,
        width: 220,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 20),
            child: Column(
              children: [
                widget.inHome
                    ? ListTile(
                        leading: Icon(
                            widget.indexOfPage == 0
                                ? Icons.home_filled
                                : Icons.home_outlined,
                            color: Colors.black),
                        title: const Text("Home"),
                        onTap: () {
                          if (widget.indexOfPage == 0) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const ResponsiveLayout(
                                  mobileLayout: MobileLayout(
                                    mobilePageMode: 0,
                                  ),
                                  desktopLayout: DesktopHomePage(
                                    indexOfPage: 0,
                                  )),
                            ));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ResponsiveLayout(
                                  mobileLayout: MobileLayout(
                                    mobilePageMode: 0,
                                  ),
                                  desktopLayout: DesktopHomePage(
                                    indexOfPage: 0,
                                  )),
                            ));
                          }
                        },
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                widget.inHome
                    ? ListTile(
                        leading: Icon(
                            widget.indexOfPage == 1
                                ? CupertinoIcons.arrow_up_right_circle_fill
                                : CupertinoIcons.arrow_up_right_circle,
                            color: Colors.black),
                        title: const Text("Popular"),
                        onTap: () {
                          if (widget.indexOfPage == 1) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const ResponsiveLayout(
                                  mobileLayout: MobileLayout(
                                    mobilePageMode: 1,
                                  ),
                                  desktopLayout: DesktopHomePage(
                                    indexOfPage: 1,
                                  )),
                            ));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ResponsiveLayout(
                                  mobileLayout: MobileLayout(
                                    mobilePageMode: 1,
                                  ),
                                  desktopLayout: DesktopHomePage(
                                    indexOfPage: 1,
                                  )),
                            ));
                          }
                        },
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                const Divider(
                  color: Colors.grey,
                  height: 30,
                  indent: 30,
                  endIndent: 30,
                ),
                FutureBuilder<void>(
                  future: fetchUserCommunities(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
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
                        return Consumer<CommunityProvider>(
                          builder: (context, settingsProvider, child) {
                            return Column(
                              children: [
                                DrawerTile(
                                  tileTitle: "COMMUNITIES",
                                  lists: userController.userCommunities ?? [],
                                  isMod: false,
                                ),
                                (userController.userAbout
                                                ?.moderatedCommunities !=
                                            null &&
                                        userController.userAbout
                                                ?.moderatedCommunities !=
                                            [])
                                    ? const Divider(
                                        color: Colors.grey,
                                        height: 30,
                                        indent: 30,
                                        endIndent: 30,
                                      )
                                    : const SizedBox(),
                                (userController.userModeratedCommunities !=
                                            null &&
                                        userController
                                                .userModeratedCommunities !=
                                            [])
                                    ? DrawerTile(
                                        tileTitle: "MODERATION",
                                        lists: userController
                                            .userModeratedCommunities!,
                                        isMod: true,
                                      )
                                    : const SizedBox(),
                              ],
                            );
                          },
                        );
                      default:
                        return const Text('badr');
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
