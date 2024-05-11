import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/post_for_scheduled.dart';

class ScheduledPostsList extends StatefulWidget {
  const ScheduledPostsList({super.key});

  @override
  State<ScheduledPostsList> createState() => _ScheduledPostsListState();
}

class _ScheduledPostsListState extends State<ScheduledPostsList> {
  List<Map<String, dynamic>> foundPosts = [];
  List<Map<String, dynamic>> recurringPosts = [];
  List<Map<String, dynamic>> scheduledPosts = [];
  final TextEditingController usernameController = TextEditingController();
  bool postsFetched = false;
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();

  Future<void> fetchScheduled() async {
    if (!postsFetched) {
      await moderatorController.getScheduled(moderatorController.communityName);
      scheduledPosts = [];
      recurringPosts = [];
      for (var post in moderatorController.scheduled) {
        if (post["scheduling_details"]["repetition_option"] == "none") {
          scheduledPosts.add(post);
        } else {
          recurringPosts.add(post);
        }
      }
      postsFetched = true;
      setState(() {
        scheduledPosts = scheduledPosts;
        recurringPosts = recurringPosts;
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

    return FutureBuilder<void>(
      future: fetchScheduled(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('none');
          case ConnectionState.waiting:
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: CircularProgressIndicator(),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return Consumer<ScheduledProvider>(
                builder: (context, scheduledProvider, child) {
              return Scaffold(
                appBar: (screenWidth > 700)
                    ? AppBar(
                        // leading: const SizedBox(
                        //   width: 0,
                        // ),
                        title: const Text(
                          'Scheduled posts',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
                body: RefreshIndicator(
                  onRefresh: () async {
                    postsFetched = false;
                    await fetchScheduled();
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      color: Colors.grey[200],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          recurringPosts.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, top: 10, bottom: 10),
                                  child: Text(
                                    "RECURRING POSTS",
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                )
                              : const SizedBox(),
                          ...recurringPosts.map((item) => PostScheduled(
                                item: item,
                                fetch: () {
                                  setState(() {
                                    postsFetched = false;
                                  });
                                },
                              )),
                          scheduledPosts.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18.0, top: 10, bottom: 10),
                                  child: Text(
                                    "SCHEDULED POSTS",
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                )
                              : const SizedBox(),
                          ...scheduledPosts.map((item) => PostScheduled(
                                item: item,
                                fetch: () {
                                  setState(() {
                                    postsFetched = false;
                                  });
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          default:
            return const Text('badr');
        }
      },
    );
  }
}
