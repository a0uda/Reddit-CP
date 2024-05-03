import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/notification_item.dart';
import 'package:reddit/Services/notifications_service.dart';
import 'package:reddit/widgets/notification.dart';

class ListingNotifications extends StatefulWidget {
  const ListingNotifications({super.key});

  @override
  State<ListingNotifications> createState() => ListingNotificationsState();
}

class ListingNotificationsState extends State<ListingNotifications> {
  final UserController userController = GetIt.instance.get<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationsService>(
        builder: (context, notificationsService, child) {
          return FutureBuilder<List<NotificationItem>>(
            future: notificationsService.getNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      notificationsService.getNotifications();
                    });
                  },
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return NotificationCard(
                        notificationItem: snapshot.data![index],
                      );
                    },
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
