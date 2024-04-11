import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import '../Services/user_service.dart';
import 'package:get_it/get_it.dart';
import '../Models/user_about.dart';

class TabBarAbout extends StatelessWidget {
  final UserService userService = GetIt.instance.get<UserService>();
  final UserAbout? userData;

  TabBarAbout(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Consumer<FollowerFollowingController>(
            builder: (context, followerFollowingController, child) {
          return Container(
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, top: 20, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${userService.getFollowersCount(userData!.username)}',
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Followers',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Color.fromARGB(255, 142, 141, 141),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, top: 20, left: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${userService.getFollowingCount(userData!.username)}',
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Following',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Color.fromARGB(255, 142, 141, 141),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(
          height: 20, // Add empty space
        ),
        userData!.about!.isEmpty
            ? Container()
            : Consumer<EditProfileController>(
                builder: (context, editProfileController, child) {
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
      ],
    );
  }
}
