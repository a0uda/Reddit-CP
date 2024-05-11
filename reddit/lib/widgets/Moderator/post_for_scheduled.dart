import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';
import 'package:reddit/widgets/Moderator/edit_scheduled_post.dart';

class PostScheduled extends StatefulWidget {
  final VoidCallback fetch;
  final Map<String, dynamic> item;
  const PostScheduled({super.key, required this.item, required this.fetch});

  @override
  State<PostScheduled> createState() => _PostScheduledState();
}

class _PostScheduledState extends State<PostScheduled> {
  String dateText = "";
  late bool recurring;
  final moderatorController = GetIt.instance.get<ModeratorController>();

  @override
  void initState() {
    super.initState();
    recurring = true;
    Map<String, dynamic> item = widget.item;
    DateTime createdAt = DateTime.parse(item["created_at"]);
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
      recurring = false;
      DateTime date =
          DateTime.parse(item["scheduling_details"]["schedule_date"]);
      dateText =
          " Scheduled ${date.month}/${date.day} @ ${date.hour}:${date.minute} ";
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
                        onPressed: () async {
                          //badrrrrr submit
                          if (moderatorController.modAccess.everything ||
                              moderatorController
                                  .modAccess.managePostsAndComments) {
                            var scheduledProvider =
                                context.read<ScheduledProvider>();
                            await scheduledProvider.submitScheduledPost(
                                moderatorController.communityName,
                                widget.item["_id"]);
                            widget.fetch();
                          } else {
                            showError(context);
                          }
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
                      if (moderatorController.modAccess.everything ||
                          moderatorController
                              .modAccess.managePostsAndComments) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditScheduledPost(
                              postId: widget.item["_id"],
                              isLinkPost: false,
                            ),
                          ),
                        );
                      } else {
                        showError(context);
                      }
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
                      if (moderatorController.modAccess.everything ||
                          moderatorController
                              .modAccess.managePostsAndComments) {
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
                                    foregroundColor: const Color.fromARGB(
                                        255, 109, 109, 110),
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
                                  onPressed: () async {
                                    var scheduledProvider =
                                        context.read<ScheduledProvider>();
                                    await scheduledProvider.cancelScheduledPost(
                                        moderatorController.communityName,
                                        widget.item["_id"]);
                                    widget.fetch();
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
                      } else {
                        showError(context);
                      }
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
