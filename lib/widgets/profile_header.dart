import 'package:flutter/material.dart';
import 'profile_header_left_side.dart';
import 'profile_header_right_side.dart';
import 'profile_header_add_social_link.dart';

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: Container(
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
        child: ListView(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ProfileHeaderLeftSide(),
                ProfileHeaderRightSide(),
              ],
            ),
            ProfileHeaderAddSocialLink(),
          ],
        ),
      ),
    );
  }
}
