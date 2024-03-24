import 'package:flutter/material.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../Services/user_service.dart';
import '../Controllers/user_controller.dart';
import 'package:get_it/get_it.dart';

class ProfileHeaderRightSide extends StatefulWidget {
  final String userType;
  final UserAbout userData;
  Function? onUpdate;

  ProfileHeaderRightSide(
      {super.key, required this.userData, required this.userType,this.onUpdate});

  @override
  _ProfileHeaderRightSideState createState() =>
      _ProfileHeaderRightSideState(userData: userData, userType: userType, onUpdate: onUpdate);
}

class _ProfileHeaderRightSideState extends State<ProfileHeaderRightSide> {
  String
      userType; //if user type is 'me' then show edit button, else show message and follow button
  UserAbout userData;
  Function? onUpdate;
  _ProfileHeaderRightSideState(
      {required this.userData, required this.userType, this.onUpdate});

  final UserController userController = GetIt.I.get<UserController>();
  final UserService userService = GetIt.I.get<UserService>();

  @override
  Widget build(BuildContext context) {
    userService.getFollowers(userController.userAbout!.username);
    final List<FollowersFollowingItem>? followingList =
        userService.getFollowing(userController.userAbout!.username);
    return SizedBox(
      width: (1 / 3) * MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30),
              child: IconButton(
                icon: Icon(Icons.share, color: Colors.white, size: 40),
                onPressed: () async {
                  const link =
                      'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr'; //to be changed
                  await Share.share('Check out this profile on Reddit: $link');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30),
              child: TextButton(
                onPressed: () {
                  if (userType == 'me') {
                  } else {
                    setState(() {
                      if (followingList!
                          .where((element) =>
                              element.username == userData.username)
                          .isEmpty) {
                        userService.followUser(userData.username,
                            userController.userAbout!.username);
                      } else {
                        userService.unfollowUser(userData.username,
                            userController.userAbout!.username);
                      }
                      onUpdate!();
                    });
                  }
                },
                child: userType == 'me'
                    ? Container(
                        child: Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: (!followingList!
                                .where((element) =>
                                    element.username == userData.username)
                                .isEmpty)
                            ? [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                Flexible(
                                  child: Text(
                                    'Following',
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ]
                            : [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Follow',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                      ),
                style: TextButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(0, 68, 70, 71), // example background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            userType != 'me'
                ? Padding(
                    padding: const EdgeInsets.only(top: 20, left: 15),
                    child: IconButton(
                      icon: Icon(Icons.message, color: Colors.white, size: 30),
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(0, 68, 70, 71),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
