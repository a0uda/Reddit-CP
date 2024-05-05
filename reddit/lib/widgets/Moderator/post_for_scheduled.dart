import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reddit/widgets/Moderator/edit_scheduled_post.dart';

class PostScheduled extends StatefulWidget {
  final Map<String, dynamic> item;
  const PostScheduled({super.key, required this.item});

  @override
  State<PostScheduled> createState() => _PostScheduledState();
}

class _PostScheduledState extends State<PostScheduled> {
  String dateText = "";
  late bool recurring;

  @override
  void initState() {
    super.initState();
    recurring = true;
    Map<String, dynamic> item = widget.item;
    DateTime createdAt = DateTime.parse(item["created_at"]);
    String dayOfWeek = DateFormat('EEEE').format(createdAt);
    if (item["scheduling_details"]["repetition_option"] == "monthly") {
      dateText =
          " Every month on the ${createdAt.day.toString()}th day @ ${createdAt.hour}";
    } else if (item["scheduling_details"]["repetition_option"] == "hourly") {
      dateText = " Every hour";
    } else if (item["scheduling_details"]["repetition_option"] == "daily") {
      dateText = " Every day at ${createdAt.hour.toString()}";
    } else if (item["scheduling_details"]["repetition_option"] == "weekly") {
      dateText =
          " Every week on ${DateFormat('EEEE').format(createdAt)} at ${createdAt.hour}";
    } else if (item["scheduling_details"]["repetition_option"] == "none") {
      recurring = true;
      dateText =
          " Scheduled ${item["scheduling_details"]["schedule_date"].month}/${item["scheduling_details"]["schedule_date"].day} @ ${item["scheduling_details"]["schedule_date"].hour}:${item["scheduling_details"]["schedule_date"].minute} ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 2),
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5),
              child: Row(
                children: [
                  Icon(
                    recurring
                        ? CupertinoIcons.arrow_2_squarepath
                        : Icons.watch_later_outlined,
                    size: 14,
                  ),
                  Text(
                    "  $dateText",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0.5,
              color: Colors.grey[200],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: Text(
                "u/${widget.item["username"]}",
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
            Text(
              widget.item["title"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 10),
              child: widget.item["description"] != ""
                  ? Text(
                      "${widget.item["description"]}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    )
                  : const SizedBox(),
            ),
            Row(
              children: [
                !recurring
                    ? ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            surfaceTintColor: Colors.transparent,
                            padding: const EdgeInsets.all(0)),
                        onPressed: () {
                          //badrrrrr submit
                        },
                        icon: Icon(
                          CupertinoIcons.paperplane_fill,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        label: Text(
                          "Submit Post",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ))
                    : const SizedBox(),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      surfaceTintColor: Colors.transparent,
                      padding: const EdgeInsets.only(left: 8),
                    ),
                    onPressed: () {
                      //badrrrrr
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EditScheduledPost(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    label: Text(
                      "Edit Post",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    )),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      surfaceTintColor: Colors.transparent,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: const Text(
                              'Are you sure you want to cancel this scheduled post?',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  backgroundColor: Colors.grey[300],
                                  foregroundColor:
                                      const Color.fromARGB(255, 109, 109, 110),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    side: const BorderSide(
                                        color: Color.fromARGB(0, 238, 12, 0)),
                                  ),
                                ),
                                child: const Text(
                                  'Go Back',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  //cancell posttttt.
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 17, 0),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    side: const BorderSide(
                                      color: Color.fromARGB(0, 240, 6, 6),
                                    ),
                                  ),
                                ),
                                child: const Text('Cancel Post'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    label: Text(
                      "Cancel Post",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// {
//       "scheduling_details": {
//         "repetition_option": "none",
//         "schedule_date": "2025-05-04T03:11:00.000Z"
//       },
//       "user_details": {
//         "total_views": 0,
//         "upvote_rate": 0,
//         "total_shares": 0
//       },
//       "_id": "6635f035a08ae9782c6e7ee3",
//       "title": "Back to the future",
//       "description": "This is a description for my test post.",
//       "created_at": "2024-05-04T08:22:14.641Z",
//       "edited_at": null,
//       "deleted_at": null,
//       "deleted": false,
//       "type": "text",
//       "link_url": null,
//       "images": [],
//       "videos": [],
//       "polls": [],
//       "polls_voting_length": 3,
//       "polls_voting_is_expired_flag": false,
//       "post_in_community_flag": true,
//       "community_name": "Adams_Group",
//       "comments_count": 0,
//       "views_count": 0,
//       "shares_count": 0,
//       "upvotes_count": 1,
//       "downvotes_count": 0,
//       "oc_flag": true,
//       "spoiler_flag": false,
//       "nsfw_flag": false,
//       "locked_flag": false,
//       "allowreplies_flag": true,
//       "set_suggested_sort": "None (Recommended)",
//       "scheduled_flag": false,
//       "is_reposted_flag": false,
//       "user_id": "663561b6720b7a2283bd8277",
//       "username": "fatema",
//       "__v": 0
//     }