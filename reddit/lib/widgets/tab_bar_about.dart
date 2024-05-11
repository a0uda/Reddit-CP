import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import '../Services/user_service.dart';
import 'package:get_it/get_it.dart';
import '../Models/user_about.dart';

class TabBarAbout extends StatelessWidget {
  final UserService userService = GetIt.instance.get<UserService>();
  late UserAbout? userData;
  late String? userType;

  TabBarAbout(this.userData, this.userType, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(220, 215, 213, 213),
                    width: 0.5,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 20, top: 20, left: 20, right: 20),
                child: Consumer<BlockUnblockUser>(
                    builder: (context, BlockUnblockUser, child) {
                  return Consumer<FollowerFollowingController>(
                      builder: (context, followerFollowingController, child) {
                    return FutureBuilder<List<int>>(
                        future: Future.wait([
                          userService.getFollowersCount(userData!.username),
                          userService.getFollowingCount(userData!.username),
                        ]),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<int>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 102, 102, 102),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            int followersCount = snapshot.data![0];
                            int followingCount = snapshot.data![1];

                            return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "$followersCount\nFollowers",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "$followingCount\nFollowing",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ]);
                          }
                        });
                  });
                }),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20, // Add empty space
        ),
        userData!.about!.isEmpty
            ? Container()
            : Consumer<EditProfileController>(
                builder: (context, editProfileController, child) {
                if (userType == 'me') {
                  var userController = GetIt.instance.get<UserController>();
                  userData = userController.userAbout!;
                }
                if (userData!.about!.isEmpty) {
                  return SizedBox.shrink();
                }
                return Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Text(
                    userData!.about!,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                );
              }),
      ]),
    ]);
  }
}
