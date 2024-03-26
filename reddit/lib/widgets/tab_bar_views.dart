import 'package:flutter/material.dart';
import 'tab_bar_posts.dart';
import 'tab_bar_comments.dart';
import 'tab_bar_about.dart';
import '../Models/user_about.dart';

class TabBarViews extends StatelessWidget {
  final UserAbout? userData;
  const TabBarViews(this.userData, {super.key});
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        const Center(child: TabBarPosts()),
        TabBarComments(userData: userData),
        TabBarAbout(userData),
      ],
    );
  }
}
