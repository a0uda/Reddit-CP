import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/add_approved_user.dart';
import 'package:reddit/widgets/Moderator/post_for_scheduled.dart';

List<Map<String, dynamic>> recurringPosts = [
  {
    "username": "badr",
    "postTitle": "every month",
    "postContent": "content",
    "every_month": true,
    "day": "30",
    "time": "12:00",
  },
  {
    "username": "badr",
    "postTitle": "every hour",
    "postContent": "content",
    "every_hour": true,
  },
  {
    "username": "badr",
    "postTitle": "every day",
    "postContent": "content",
    "every_day": true,
    "time": "12:00",
  },
  {
    "username": "badr",
    "postTitle": "Title",
    "postContent": "content",
    "every_week": true,
    "day_of_the_week": "Monday",
    "time": "12:00",
  },
];
List<Map<String, dynamic>> scheduledPosts = [
  {
    "username": "mohy",
    "postTitle": "Title",
    "postContent": "content",
    "scheduled_day": "4/29",
    "scheduled_time": "11:00",
    "recurring": false,
  },
  {
    "username": "mohy",
    "postTitle": "Title",
    "postContent": "content",
    "scheduled_day": "4/29",
    "scheduled_time": "11:00",
    "recurring": false,
  },
  {
    "username": "mohy",
    "postTitle": "Title",
    "postContent": "content",
    "scheduled_day": "4/29",
    "scheduled_time": "11:00",
    "recurring": false,
  },
];

class ScheduledPostsList extends StatefulWidget {
  const ScheduledPostsList({super.key});

  @override
  State<ScheduledPostsList> createState() => _ScheduledPostsListState();
}

class _ScheduledPostsListState extends State<ScheduledPostsList> {
  List<Map<String, dynamic>> foundUsers = [];
  final TextEditingController usernameController = TextEditingController();
  bool usersFetched = false;
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();

  Future<void> fetchApprovedUsers() async {
    if (false) {
      await moderatorController
          .getApprovedUser(moderatorController.communityName);
      usernameController.text = "";
      setState(() {
        foundUsers = moderatorController.approvedUsers;
        usersFetched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<ApprovedUserProvider>(
        builder: (context, approvedUserProvider, child) {
      return SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (screenWidth > 700)
                  ? AppBar(
                      leading: const SizedBox(
                        width: 0,
                      ),
                      title: const Text(
                        'Scheduled posts',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 10, bottom: 10),
                child: Text(
                  "RECURRING POSTS",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
              ...recurringPosts.map((item) => PostScheduled(item: item)),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 10, bottom: 10),
                child: Text(
                  "SCHEDULED POSTS",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
              ...scheduledPosts.map((item) => PostScheduled(item: item)),
            ],
          ),
        ),
      );
    });
  }
}
