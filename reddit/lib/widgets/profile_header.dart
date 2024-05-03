import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/user_about.dart';
import 'profile_header_left_side.dart';
import 'profile_header_right_side.dart';
import 'profile_header_add_social_link.dart';

class ProfileHeader extends StatelessWidget {
  UserAbout userData;
  final String userType;
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
        decoration:
            userData.bannerPicture != null && userData.bannerPicture!.isNotEmpty
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
}
