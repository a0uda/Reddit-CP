import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/user_about.dart';
import 'profile_header_left_side.dart';
import 'profile_header_right_side.dart';
import 'profile_header_add_social_link.dart';

class ProfileHeader extends StatelessWidget {
  final UserAbout userData;
  final String userType;
  const ProfileHeader(this.userData, this.userType, {super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<BannerPictureController>(
        builder: (context, bannerpicturecontroller, child) {
      return Container(
        decoration: userData.bannerPicture != null
            ? (File(userData.bannerPicture!).existsSync())
                ? BoxDecoration(
                    image: DecorationImage(
                    image: FileImage(File(userData.bannerPicture!)),
                    fit: BoxFit.cover,
                  ))
                : BoxDecoration(
                    image: DecorationImage(
                    image: () {
                      try {
                        return AssetImage(userData.bannerPicture!);
                      } catch (e) {
                        // The asset doesn't exist, return a default asset
                        return const AssetImage(
                            'images/Greddit.png'); // Replace with your default asset path
                      }
                    }(),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProfileHeaderLeftSide(userData, userType),
                ProfileHeaderRightSide(
                    userData: userData, userType: userType),
              ],
            ),
            ProfileHeaderAddSocialLink(userData, userType, true),
          ],
        ),
      );
    });
  }
}
