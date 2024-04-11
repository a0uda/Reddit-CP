import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

    return SizedBox(
      width: (2 / 3) * screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Consumer<ProfilePictureController>(
              builder: (context, profilepicturecontroller, child) {
            return Padding(
              padding: const EdgeInsets.only(left: 20),
              child: userData.profilePicture == null
                  ? const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('images/Greddit.png'),
                    )
                  : File(userData.profilePicture!).existsSync()
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              FileImage(File(userData.profilePicture!)),
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(userData.profilePicture!),
                        ),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 0),
            child: Text(
              userData.displayName ?? userData.username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                userType == 'me'
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${userService.getFollowersCount(userData.username)} followers',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FollowerList(),
                                ),
                              );
                            },
                            padding: const EdgeInsets.only(top: 28),
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            color: Colors.white,
                            iconSize: 12,
                          )
                        ],
                      )
                    : Container(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'u/${userData.username} - ${userData.createdAt}\n${userData.about}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
