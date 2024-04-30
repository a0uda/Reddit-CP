import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reddit/widgets/notifications_settings.dart';

class InboxOptions extends StatefulWidget {
  const InboxOptions({
    super.key,
  });

  @override
  Postoptions createState() => Postoptions();
}

class Postoptions extends State<InboxOptions> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          final rootContext = context;
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: () => {},
                        child: const Row(
                          children: [
                            Icon(
                              CupertinoIcons.pencil,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "New message",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        )),
                    TextButton(
                        onPressed: () => {},
                        child: const Row(
                          children: [
                            Icon(
                              Icons.check_box_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text("Mark all inbox tabs as read",
                                style: TextStyle(color: Colors.black))
                          ],
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.of(rootContext).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationsSettings(),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Edit notification settings",
                                style: TextStyle(color: Colors.black))
                          ],
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        icon: const Icon(Icons.more_horiz));
  }
}
