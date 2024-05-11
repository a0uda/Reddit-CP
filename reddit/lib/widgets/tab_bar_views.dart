import 'package:flutter/material.dart';
import 'tab_bar_posts.dart';
import 'tab_bar_comments.dart';
import 'tab_bar_about.dart';
import '../Models/user_about.dart';

class TabBarViews extends StatelessWidget {
  final UserAbout? userData;
  final String? userType;
  const TabBarViews(this.userData, this.userType,{super.key});
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        // TabBarPosts(
        //   userData: userData,
        //   userType: userType,
        // ),
        TabBarComments(userData: userData),
        TabBarAbout(userData,userType),
      ],
    );
  }
}
