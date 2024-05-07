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
    return Container(
      padding: const EdgeInsets.only(left: 20),
      width: (2 / 3) * screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Consumer<ProfilePictureController>(
              builder: (context, profilepicturecontroller, child) {
            if (userType == 'me') {
              var userController = GetIt.instance.get<UserController>();
              userData = userController.userAbout!;
            }
            return userData.profilePicture == null ||
                    userData.profilePicture == ''
                ? const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('images/Greddit.png'),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userData.profilePicture!),
                    onBackgroundImageError: (_, __) =>
                        const AssetImage('images/Greddit.png'),
                  );
          }),
          Consumer<EditProfileController>(
            builder: (context, editProfileController, child) {
              if (userType == 'me') {
                var userController = GetIt.instance.get<UserController>();
                userData = userController.userAbout!;
              }
              return Flexible(
                child: Text(
                  (userData.displayName == null || userData.displayName == '')
                      ? userData.username
                      : userData.displayName ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
          userType == 'me'
              ? Consumer<BlockUnblockUser>(
                  builder: (context, blockUnblockUser, child) {
                  return FutureBuilder<int>(
                      future: userService.getFollowersCount(userData.username),
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int followersCount = snapshot.data!;
                          return Row(
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
                              followersCount > 0
                                  ? IconButton(
                                      padding: const EdgeInsets.only(top: 26),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const FollowerList(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.arrow_forward_ios_rounded),
                                      color: Colors.white,
                                      iconSize: 13,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          );
                        }
                      });
                })
              : Container(),
          Flexible(
            child: Text(
              'u/${userData.username} - ${userData.createdAt}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Consumer<EditProfileController>(
            builder: (context, editProfileController, child) {
              if (userType == 'me') {
                var userController = GetIt.instance.get<UserController>();
                userData = userController.userAbout!;
              }
              return Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom:
                          userData.about != null && userData.about!.isNotEmpty
                              ? 10
                              : 0),
                  child: Text(
                    userData.about != null && userData.about!.isNotEmpty
                        ? '${userData.about}'
                        : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    softWrap: true,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
