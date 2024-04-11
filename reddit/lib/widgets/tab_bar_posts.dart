import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Services/user_service.dart';

class TabBarPosts extends StatefulWidget {
  const TabBarPosts({super.key});

  @override
  TabBarPostsState createState() => TabBarPostsState();
}

class TabBarPostsState extends State<TabBarPosts> {
  final userController = GetIt.instance.get<UserController>();
  final userService = GetIt.instance.get<UserService>();
  bool? showActiveCommunities;
  List<CommunityItem>? activeCommunities = [];

  @override
  void initState() {
    super.initState();
    showActiveCommunities = userService
        .getProfileSettings(userController.userAbout!.username)!
        .activeCommunity;
    activeCommunities =
        userService.getActiveCommunities(userController.userAbout!.username);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileController>(
        builder: (context, editProfileController, child) {
      return Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //////////////////////////// Drop Down List for Listing post ////////////////////////////

            (userService
                    .getProfileSettings(userController.userAbout!.username)!
                    .activeCommunity)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Active in these communities",
                          style: TextStyle(fontSize: 14)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var community in activeCommunities!)
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
                                          decoration:const  BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                          ),
                                          height: 50,
                                          width: 160,
                                        ),
                                        Positioned(
                                          top: 25,
                                          left: 55,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: AssetImage(community
                                                  .communityProfilePicturePath),
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                        "r/${community.communityName}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                          community.communityDescription,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 93, 93, 93))),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                          "${community.communityMembersNo} members",
                                          textAlign: TextAlign.center,
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
                : Container(),

            //////////////////////////// User Posts ////////////////////////////
          ],
        ),
      );
    });
  }
}
