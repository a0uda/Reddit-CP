import 'package:flutter/material.dart';
import 'package:reddit/Models/active_communities.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/widgets/Community/community_responsive.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';
import 'package:reddit/widgets/listing_certain_user.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Services/user_service.dart';

class TabBarPosts extends StatefulWidget {
  final UserAbout? userData;
  late String? userType;
  TabBarPosts({super.key, this.userData, this.userType});

  @override
  TabBarPostsState createState() => TabBarPostsState();
}

class TabBarPostsState extends State<TabBarPosts> {
  final userService = GetIt.instance.get<UserService>();
  final UserController userController = GetIt.instance.get<UserController>();
  bool? showActiveCommunities;
  List<ActiveCommunities>? activeCommunities = [];
  UserAbout? userData;
  String? userType;

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
    userType = widget.userType;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userService.getActiveCommunities(userData!.username),
        builder: (BuildContext context,
            AsyncSnapshot<ActiveCommunitiesResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('getting bool active communities tmm');
            return Container(
              color: Colors.white,
              child: const SizedBox(
                height: 30,
                width: 30,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            showActiveCommunities = snapshot.data!.showActiveCommunities;
            activeCommunities = snapshot.data!.activeCommunities;
            return Consumer<EditProfileController>(
                builder: (context, editProfileController, child) {
              if (userType == 'me' && userController.profileSettings != null) {
                showActiveCommunities =
                    userController.profileSettings!.activeCommunity;
              }
              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        (showActiveCommunities!)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Text(
                                        activeCommunities!.isNotEmpty
                                            ? 'Active in these communities'
                                            : 'Not active in any communities',
                                        style: TextStyle(fontSize: 14)),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var community
                                            in activeCommunities!)
                                          SizedBox(
                                            width: 160,
                                            child: GestureDetector(
                                              onTap: () {
                                                List<CommunityBackend>
                                                    moderatedCammunities =
                                                    userController.userAbout!
                                                        .moderatedCommunities!;
                                                bool isMod = false;
                                                if (moderatedCammunities.any(
                                                        (element) =>
                                                            element.name ==
                                                            userData!
                                                                .username) ==
                                                    true) {
                                                  isMod = true;
                                                } else {
                                                  isMod = false;
                                                }
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            (CommunityLayout(
                                                              desktopLayout: DesktopCommunityPage(
                                                                  isMod: isMod,
                                                                  communityName:
                                                                      community
                                                                          .name),
                                                              mobileLayout:
                                                                  MobileCommunityPage(
                                                                isMod: isMod,
                                                                communityName:
                                                                    community
                                                                        .name,
                                                              ),
                                                            ))));
                                              },
                                              child: Card(
                                                color: Colors.white,
                                                child: Column(children: [
                                                  SizedBox(
                                                    height: 80,
                                                    width: 160,
                                                    child: Stack(children: [
                                                      Container(
                                                        decoration: community
                                                                .bannerPicture
                                                                .isEmpty
                                                            ? const BoxDecoration(
                                                                color:
                                                                    Colors.blue,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10)),
                                                              )
                                                            : BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        community
                                                                            .bannerPicture)),
                                                                borderRadius: const BorderRadius
                                                                    .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10)),
                                                              ),
                                                        height: 50,
                                                        width: 160,
                                                      ),
                                                      Positioned(
                                                        top: 25,
                                                        left: 50,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.0,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: community
                                                                  .profilePicture
                                                                  .isEmpty
                                                              ? const CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          'images/Greddit.png'))
                                                              : CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          community
                                                                              .profilePicture),
                                                                ),
                                                        ),
                                                      )
                                                    ]),
                                                  ),
                                                  SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                      "r/${community.name}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                        community.description,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    93,
                                                                    93,
                                                                    93))),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                        "${community.membersCount} members",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.grey)),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    child: Consumer<BlockUnblockUser>(
                        builder: (context, blockUnblockUser, child) {
                      return ListingCertainUser(
                        userData: userData,
                      );
                    }),
                  ),
                ],
              );
            });
          }
        });
  }
}
