import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/add_approved_user.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';
import 'package:reddit/widgets/Moderator/scheduled_list.dart';

class ScheduledPosts extends StatefulWidget {
  const ScheduledPosts({super.key});

  @override
  State<ScheduledPosts> createState() => _ScheduledPostsState();
}

class _ScheduledPostsState extends State<ScheduledPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Center(child: Text("Scheduled posts")),
      ),
      body: Container(
          child: const ScheduledPostsList()),
    );
  }
}
