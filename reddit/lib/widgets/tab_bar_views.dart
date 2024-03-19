import 'package:flutter/material.dart';
import 'tab_bar_posts.dart';
import 'tab_bar_comments.dart';
import 'tab_bar_about.dart';

class TabBarViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Center(child: TabBarPosts()),
        TabBarComments(),
        TabBarAbout(),
      ],
    );
  }
}
