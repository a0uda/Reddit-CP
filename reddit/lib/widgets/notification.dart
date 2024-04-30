import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/notification_item.dart';
import 'package:reddit/Services/notifications_service.dart';

class NotificationCard extends StatefulWidget {
  final NotificationItem notificationItem;

  const NotificationCard({super.key, required this.notificationItem});
  @override
  State<NotificationCard> createState() => NotificationCardState();
}

class NotificationCardState extends State<NotificationCard> {
  late NotificationsService notificationsService =
      Provider.of<NotificationsService>(context, listen: false);
  final UserController userController = GetIt.instance.get<UserController>();
  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;

    if (widget.notificationItem.type == 'upvotes_posts' &&
        widget.notificationItem.isInCommunity == true) {
      title =
          'u/${widget.notificationItem.sendingUserUsername} upvoted your post in ${widget.notificationItem.communityName}';
      subtitle =
          'Go see your post on u/${widget.notificationItem.communityName}';
    } else if (widget.notificationItem.type == 'upvotes_posts') {
      title =
          'u/${widget.notificationItem.sendingUserUsername} upvoted your post';
      subtitle = 'Go see your post on u/${userController.userAbout?.username}';
    } else if (widget.notificationItem.type == 'comments' &&
        widget.notificationItem.isInCommunity == true) {
      title =
          'u/${widget.notificationItem.sendingUserUsername} replied to your post in ${widget.notificationItem.communityName}';
      subtitle = '';
    } else if (widget.notificationItem.type == 'comments') {
      title =
          'u/${widget.notificationItem.sendingUserUsername} replied to your post';
      subtitle = '';
    } else if (widget.notificationItem.type == 'replies' &&
        widget.notificationItem.isInCommunity == true) {
      title =
          'u/${widget.notificationItem.sendingUserUsername} replied to your comment in ${widget.notificationItem.communityName}';
      subtitle = '';
    } else if (widget.notificationItem.type == 'replies') {
      title =
          'u/${widget.notificationItem.sendingUserUsername} replied to your comment';
      subtitle = '';
    } else if (widget.notificationItem.type == 'new_followers') {
      title = 'u/${widget.notificationItem.sendingUserUsername} followed you';
      subtitle = '';
    } else {
      title = '';

      subtitle = '';
    }

    return ListTile(
      leading: const CircleAvatar(
        //TODO: CHANGE THE PICTURE FROM DATABASE
        // backgroundImage: NetworkImage(widget.notificationItem.profilePicture!),
        backgroundImage: AssetImage("images/logo-mobile.png"),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await notificationsService
                          .hideNotification(widget.notificationItem.id!);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Hide this notification",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => {},
                    child: const Row(
                      children: [
                        Icon(
                          Icons.disabled_by_default_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text("Disable updates from this community",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => {},
                    child: const Row(
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Turn off this type of notification",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  ),
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
            },
          );
        },
      ),
    );
  }
}
