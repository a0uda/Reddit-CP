import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'follower_list.dart';
import 'package:get_it/get_it.dart';
import '../Services/user_service.dart';
import '../Models/user_about.dart';

class ProfileHeaderLeftSide extends StatelessWidget {
  final userService = GetIt.instance.get<UserService>();
  UserAbout userData;
  final String userType;

  ProfileHeaderLeftSide(this.userData, this.userType, {super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<int>(
      future: userService.getFollowersCount(userData.username),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(
          );
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
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Consumer<ProfilePictureController>(
                      builder: (context, profilepicturecontroller, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        userData.profilePicture == null
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
                      ],
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Consumer<EditProfileController>(
                    builder: (context, editProfileController, child) {
                      if (userType == 'me') {
                        var userController =
                            GetIt.instance.get<UserController>();
                        userData = userController.userAbout!;
                      }
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            userData.displayName ?? userData.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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
                              padding: const EdgeInsets.only(top: 26),
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
                      padding: EdgeInsets.only(
                        left: 20,
                        bottom: (userData.about != null &&
                                userData.about!.isNotEmpty)
                            ? 10
                            : 10,
                      ),
                      child: Consumer<EditProfileController>(
                        builder: (context, editProfileController, child) {
                          if (userType == 'me') {
                            var userController =
                                GetIt.instance.get<UserController>();
                            userData = userController.userAbout!;
                          }
                          return Text(
                            'u/${userData.username} - ${userData.createdAt}${userData.about != null && userData.about!.isNotEmpty ? '\n${userData.about}' : ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        },
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
