import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    if (widget.item.containsKey("every_month") && widget.item["every_month"]) {
      dateText =
          " Every month on the ${widget.item["day"]}th day @ ${widget.item["time"]}";
    } else if (widget.item.containsKey("every_hour") &&
        widget.item["every_hour"]) {
      dateText = " Every hour";
    } else if (widget.item.containsKey("every_day") &&
        widget.item["every_day"]) {
      dateText = " Every day at ${widget.item["time"]}";
    } else if (widget.item.containsKey("every_week") &&
        widget.item["every_week"]) {
      dateText =
          " Every week on ${widget.item["day_of_the_week"]} at ${widget.item["time"]}";
    } else if (widget.item.containsKey("recurring") &&
        !widget.item["recurring"]) {
      recurring = false;
      dateText =
          " Scheduled ${widget.item["scheduled_day"]} @ ${widget.item["scheduled_time"]}";
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
              widget.item["postTitle"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 10),
              child: widget.item.containsKey("postContent")
                  ? Text(
                      "${widget.item["postContent"]}",
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
