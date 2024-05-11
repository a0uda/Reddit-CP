import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/chat_user.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/history.dart';
import 'package:reddit/widgets/inbox_options.dart';
import 'package:reddit/widgets/report_options.dart';
import 'profile_header_left_side.dart';
import 'profile_header_right_side.dart';
import 'profile_header_add_social_link.dart';

class ProfileHeader extends StatelessWidget {
  UserAbout userData;
  final String userType;
  bool testing = true;
  ProfileHeader(this.userData, this.userType, {super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<BannerPictureController>(
        builder: (context, bannerpicturecontroller, child) {
      if (userType == 'me') {
        var userController = GetIt.instance.get<UserController>();
        userData = userController.userAbout!;
      }
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: userData.bannerPicture != null &&
                userData.bannerPicture!.isNotEmpty &&
                !testing
            ? BoxDecoration(
                image: DecorationImage(
                image: NetworkImage(userData.bannerPicture!),
                fit: BoxFit.cover,
              ))
            : const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Color.fromARGB(255, 28, 83, 165),
                  ],
                ),
              ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding:
                        const EdgeInsets.only(top: 40, bottom: 20, left: 20),
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    iconSize: 30,
                  ),
                  const Spacer(),
                  userType == 'other'
                      ? IconButton(
                          onPressed: () {
                            showMoreOptionsDialog(context);
                          },
                          padding: const EdgeInsets.only(
                              top: 40, bottom: 20, left: 20, right: 20),
                          icon: const Icon(Icons.more_horiz),
                          color: Colors.white,
                          iconSize: 30,
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProfileHeaderLeftSide(userData, userType),
                ProfileHeaderRightSide(userData: userData, userType: userType),
              ],
            ),
            ProfileHeaderAddSocialLink(userData, userType, true),
          ],
        ),
      );
    });
  }

  void showMoreOptionsDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: () {
                      addNewMessage(context,
                          isProfilePage: true,
                          receiverUsername: userData.username);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text("Send a message",
                            style: TextStyle(color: Colors.black))
                      ],
                    )),
                TextButton(
                    onPressed: () => {
                          // Navigator.pop(context),
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Are you sure?'),
                                content: const Text(
                                  "You won't see posts or comments from this user.",
                                ),
                                actions: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.33,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        key: Key('Cancel'),
                                        'CANCEL',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.33,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await userService.blockUser(
                                            userController.userAbout!.username,
                                            userData.username);
                                        print('gwa block');
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'User blocked Successfully!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Colors.black,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        key: Key('Block'),
                                        'BLOCK',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.block,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text("Block Account",
                            style: TextStyle(color: Colors.black))
                      ],
                    )),
                TextButton(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                    child: ListView(children: [
                                  const ListTile(
                                    leading: Text(
                                      "Submit report",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const ListTile(
                                    leading: Text(
                                        "Thanks for looking out for yourself"),
                                  ),
                                  ReportOptions(
                                    postId: "12345",
                                    isUser: true,
                                    username: userData.username,
                                  )
                                ]));
                              })
                        },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.report,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text("Report", style: TextStyle(color: Colors.black))
                      ],
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
