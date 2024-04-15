import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'follower_list.dart';
import 'package:get_it/get_it.dart';
import '../Services/user_service.dart';
import '../Models/user_about.dart';

class ProfileHeaderLeftSide extends StatelessWidget {
  final userService = GetIt.instance.get<UserService>();
  final UserAbout userData;
  final String userType;

  ProfileHeaderLeftSide(this.userData, this.userType, {super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<int>(
      future: userService.getFollowersCount(userData.username),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Display a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Display error message if any
        } else {
          int followersCount = snapshot.data!;
          return SizedBox(
            width: (2 / 3) * screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Consumer<ProfilePictureController>(
                    builder: (context, profilepicturecontroller, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: userData.profilePicture == null
                            ? const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('images/Greddit.png'),
                              )
                            : File(userData.profilePicture!).existsSync()
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(
                                        File(userData.profilePicture!)),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage(userData.profilePicture!),
                                  ),
                      ),
                    ],
                  );
                }),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        userData.displayName ?? userData.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                userType == 'me'
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '$followersCount followers',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              padding: const EdgeInsets.only(top: 27),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const FollowerList(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
                              color: Colors.white,
                              iconSize: 13,
                            )
                          ],
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 10),
                      child: Text(
                        'u/${userData.username} - ${userData.createdAt}\n${userData.about}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
