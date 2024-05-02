import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reddit/widgets/hot_listing.dart';

import 'package:reddit/widgets/listing.dart';

import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/community_item.dart';
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
  List<CommunityItem>? activeCommunities = [];
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
        future: Future.wait([
          userService.getProfileSettings(userData!.username),
          userService.getActiveCommunities(userData!.username)
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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
            showActiveCommunities = snapshot.data![0].activeCommunity;
            activeCommunities = snapshot.data![1];
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
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Text("Active in these communities",
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
                                            child: Card(
                                              color: Colors.white,
                                              child: Column(children: [
                                                SizedBox(
                                                  height: 80,
                                                  width: 160,
                                                  child: Stack(children: [
                                                    Container(
                                                      decoration: community
                                                                      .communityCoverPicturePath ==
                                                                  '' ||
                                                              community
                                                                      .communityCoverPicturePath ==
                                                                  null
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
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    community
                                                                        .communityCoverPicturePath!),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
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
                                                      left: 55,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage:
                                                              AssetImage(community
                                                                  .communityProfilePicturePath),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                                ),
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                    "r/${community.general.communityName}",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                      community.general
                                                          .communityDescription,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255,
                                                              93,
                                                              93,
                                                              93))),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                      "${community.communityMembersNo} members",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey)),
                                                ),
                                              ]),
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
                        builder: (context, BlockUnblockUser, child) {
                      return Listing(
                        type: "profile",
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
