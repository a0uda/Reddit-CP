import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Pages/community_page.dart';
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
  final CommunityController communityController = GetIt.instance.get<CommunityController>(); 
  List<Map<String, dynamic>> communities = []; 

  @override
  void initState() {
    super.initState();
    fetchCommunities(); 
  }
  Future<void> fetchCommunities() async {
    for (String communityName in communityNames) {
      communityController.getCommunity(communityName);
      if (communityController.communityItem != null) {
          communities.add({
            'name': communityName,
            'communityPage': CommunityPage(
              communityDescription: communityController.communityItem!.general.communityDescription,
              communityMembersNo: communityController.communityItem!.communityMembersNo,
              communityName: communityController.communityItem!.general.communityName,
              communityProfilePicturePath: communityController.communityItem!.communityProfilePicturePath,
              communityRule: communityController.communityItem!.communityRules,
            ),
          });
      }
    }
  }


  List<String> communityNames = [
    'Flutter Enthusiasts',
    'Cooking Masters',
    'Fitness Warriors',
    'Photography Passion',
    'Gaming Universe',
  ];

  var userModList = [];
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
                widget.inHome
                    ? ListTile(
                        leading: Icon(
                            widget.indexOfPage == 2
                                ? CupertinoIcons.graph_circle_fill
                                : CupertinoIcons.graph_circle,
                            color: Colors.black),
                        title: const Text("All"),
                        onTap: () {
                          if (widget.indexOfPage == 2) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const ResponsiveLayout(
                                  mobileLayout: MobileLayout(
                                    mobilePageMode: 2,
                                  ),
                                  desktopLayout: DesktopHomePage(
                                    indexOfPage: 2,
                                  )),
                            ));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ResponsiveLayout(
                                  mobileLayout: MobileLayout(
                                    mobilePageMode: 2,
                                  ),
                                  desktopLayout: DesktopHomePage(
                                    indexOfPage: 2,
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
                            widget.indexOfPage == 3
                                ? Icons.watch_later
                                : Icons.watch_later_outlined,
                            color: Colors.black),
                        title: const Text("Latest"),
                        onTap: () {
                          if (widget.indexOfPage == 3) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const ResponsiveLayout(
                                  mobileLayout: MobileLayout(
                                    mobilePageMode: 3,
                                  ),
                                  desktopLayout: DesktopHomePage(
                                    indexOfPage: 3,
                                  )),
                            ));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ResponsiveLayout(
                                  mobileLayout: MobileLayout(
                                    mobilePageMode: 3,
                                  ),
                                  desktopLayout: DesktopHomePage(
                                    indexOfPage: 3,
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
                
                DrawerTile(tileTitle: "COMMUNITIES", lists: communities),
                const Divider(
                  color: Colors.grey,
                  height: 30,
                  indent: 30,
                  endIndent: 30,
                ),
                userMod
                    ? DrawerTile(
                        tileTitle: "MODERATION",
                        lists: communities,
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ));
  }
}

 List<String> communityNames = [
    'Flutter Enthusiasts',
    'Cooking Masters',
    'Fitness Warriors',
    'Photography Passion',
    'Gaming Universe',
  ];

// List<Map<String, dynamic>> communites = [
//   {
//     'name': "r/mostafa",
//     'communityPage': CommunityPage(
//       communityDescription: "nas betheb fouda",
//       communityMembersNo: community.,
      
//     )
//   },
//   {
//     'name': "r/badr",
//     'communityPage': CommunityPage(
//       communityDescription: "nas betheb fouda",
//     )
//   },
//   {
//     'name': "r/badrinho",
//     'communityPage': CommunityPage(
//       communityDescription: "nas betheb fouda",
//     )
//   },
// ];
// List<Map<String, dynamic>> moderatorCommunities = [
//   {
//     'name': "r/mostafa",
//     'communityPage': CommunityPage(
//       communityDescription: "nas betheb fouda",
//     )
//   },
//   {
//     'name': "r/badr",
//     'communityPage': CommunityPage(
//       communityDescription: "nas betheb fouda",
//     )
//   },
//   {
//     'name': "r/badrinho",
//     'communityPage': CommunityPage(
//       communityDescription: "nas betheb fouda",
//     )
//   },
// ];

