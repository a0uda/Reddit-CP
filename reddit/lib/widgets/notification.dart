import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/notification_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/notifications_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/comments_desktop.dart';

String formatDateTime(String dateTimeString) {
  final DateTime now = DateTime.now();
  final DateTime parsedDateTime = DateTime.parse(dateTimeString);

  final Duration difference = now.difference(parsedDateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}sec';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else if (difference.inDays < 30) {
    return '${difference.inDays}d';
  } else {
    final int months = now.month -
        parsedDateTime.month +
        (now.year - parsedDateTime.year) * 12;
    if (months < 12) {
      return '$months mth';
    } else {
      final int years = now.year - parsedDateTime.year;
      return '$years yrs';
    }
  }
}

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
    bool isPost = false;

    if (widget.notificationItem.type == 'upvotes_posts' &&
        widget.notificationItem.isInCommunity == true) {
      title =
          'u/${widget.notificationItem.sendingUserUsername} upvoted your post in r/${widget.notificationItem.communityName}';
      subtitle =
          'Go see your post on u/${widget.notificationItem.communityName}';
      isPost = true;
    } else if (widget.notificationItem.type == 'upvotes_posts') {
      title =
          'u/${widget.notificationItem.sendingUserUsername} upvoted your post';
      subtitle = 'Go see your post on u/${userController.userAbout?.username}';
      isPost = true;
    } else if (widget.notificationItem.type == 'comments' &&
        widget.notificationItem.isInCommunity == true) {
      title =
          'u/${widget.notificationItem.sendingUserUsername} replied to your post in r/${widget.notificationItem.communityName}';
      subtitle = '';
      isPost = true;
    } else if (widget.notificationItem.type == 'comments') {
      title =
          'u/${widget.notificationItem.sendingUserUsername} replied to your post';
      subtitle = '';
      isPost = true;
    } else if (widget.notificationItem.type == 'replies' &&
        widget.notificationItem.isInCommunity == true) {
      title =
          'u/${widget.notificationItem.sendingUserUsername} replied to your comment in r/${widget.notificationItem.communityName}';
      subtitle = '';
      isPost = true;
    } else if (widget.notificationItem.type == 'replies') {
      title =
          'u/${widget.notificationItem.sendingUserUsername} replied to your comment';
      subtitle = '';
      isPost = true;
    } else if (widget.notificationItem.type == 'new_followers') {
      title = 'u/${widget.notificationItem.sendingUserUsername} followed you';
      subtitle = '';
    } else if (widget.notificationItem.type == 'upvotes_comments' &&
        widget.notificationItem.isInCommunity == true) {
      title =
          'u/${widget.notificationItem.sendingUserUsername} upvoted your comment in r/${widget.notificationItem.communityName}';
      subtitle = '';
      isPost = true;
    } else if (widget.notificationItem.type == 'upvotes_comments') {
      title =
          'u/${widget.notificationItem.sendingUserUsername} upvoted your comment';
      subtitle = '';
      isPost = true;
    } else {
      title = '';

      subtitle = '';
      isPost = false;
    }
    title += ' • ${formatDateTime(widget.notificationItem.createdAt!)}';

    if (widget.notificationItem.unreadFlag == true) {
      var count = 0;

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: count,
          channelKey: 'basic_channel',
          title: title,
          body: subtitle,
        ),
      );
      count++;
    }

    return ListTile(
      onTap: isPost
          ? () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CommentsDesktop(postId: widget.notificationItem.postId!),
                ),
              );
              await notificationsService
                  .markAsRead(widget.notificationItem.id!);
            }
          : () async {
              var userService = GetIt.instance.get<UserService>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FutureBuilder<UserAbout?>(
                    future: userService.getUserAbout(
                        widget.notificationItem.sendingUserUsername!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.white,
                          child: const SizedBox(
                              height: 30,
                              width: 30,
                              child: Center(
                                child: CircularProgressIndicator(),
                              )),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ProfileScreen(
                          snapshot.data,
                          "other",
                        );
                      }
                    },
                  ),
                ),
              );
              await notificationsService
                  .markAsRead(widget.notificationItem.id!);
            },
      tileColor: widget.notificationItem.unreadFlag == true
          ? const Color.fromARGB(255, 138, 184, 207)
          : null,
      leading: CircleAvatar(
        backgroundImage: (widget.notificationItem.profilePicture != null &&
                widget.notificationItem.profilePicture != '')
            ? NetworkImage(widget.notificationItem.profilePicture!)
            : const NetworkImage(
                "https://static-00.iconduck.com/assets.00/reddit-icon-icon-2048x2048-fdxpdoih.png"),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      subtitle: subtitle != ''
          ? Text(subtitle,
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 12,
                  color: Colors.grey[600]))
          : null,
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
                  widget.notificationItem.communityName == null ||
                          widget.notificationItem.communityName == ''
                      ? Container()
                      : TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await notificationsService.muteUnmuteCommunity(
                                widget.notificationItem.communityName!);
                          },
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
                    onPressed: () => {
                      userController.updateSingleNotificationSetting(
                          userController.userAbout!.username,
                          widget.notificationItem.type!,
                          false)
                    },
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
