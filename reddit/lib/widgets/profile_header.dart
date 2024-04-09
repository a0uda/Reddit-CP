import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'profile_header_left_side.dart';
import 'profile_header_right_side.dart';
import 'profile_header_add_social_link.dart';

class ProfileHeader extends StatelessWidget {
  var userData;
  String userType;
  Function? onUpdate;
  ProfileHeader(this.userData, this.userType, this.onUpdate, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
                  userData: userData, userType: userType, onUpdate: onUpdate),
            ],
          ),
          Consumer<SocialLinksController>(
            builder: (context, socialLinksController, child) {
              return ProfileHeaderAddSocialLink(userData, userType, true);
            },
          ),
        ],
      ),
    );
  }
}
