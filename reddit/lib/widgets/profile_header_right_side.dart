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
      {super.key,
      required this.userData,
      required this.userType,
      this.onUpdate});

  @override
  _ProfileHeaderRightSideState createState() => _ProfileHeaderRightSideState(
      userData: userData, userType: userType, onUpdate: onUpdate);
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

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double widgetSize =
        screenWidth < screenHeight ? screenWidth : screenHeight;

    return SizedBox(
      width: (1 / 3) * MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(right: (1 / 25) * widgetSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: (1 / 25) * widgetSize, left: (1 / 17) * widgetSize),
              child: IconButton(
                icon: Icon(Icons.share,
                    color: Colors.white, size: 0.07 * widgetSize),
                onPressed: () async {
                  const link =
                      'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr'; //to be changed
                  await Share.share('Check out this profile on Reddit: $link');
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: (1 / 25) * widgetSize, left: (1 / 17) * widgetSize),
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
                        padding: EdgeInsets.all(
                          (1 / 75) * widgetSize,
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              color: Colors.white, fontSize: 0.03 * widgetSize),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(
                          (1 / 75) * widgetSize,
                        ),
                        child: Row(
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
                                    size: 0.03 * widgetSize,
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Following',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 0.03 * widgetSize),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ]
                              : [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 0.03 * widgetSize,
                                  ),
                                  Text(
                                    'Follow',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 0.03 * widgetSize),
                                  ),
                                ],
                        ),
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
                    padding: EdgeInsets.only(
                        top: (1 / 25) * widgetSize,
                        left: (1 / 33) * widgetSize),
                    child: IconButton(
                      icon: Icon(Icons.message,
                          color: Colors.white, size: 0.06 * widgetSize),
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
