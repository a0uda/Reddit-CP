import 'package:flutter/material.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/widgets/custom_stateful_settings_tile.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  final UserController userController = GetIt.instance.get<UserController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: <Widget>[
          SettingsGroup(
            title: 'MESSAGES',
            titleTextStyle: TextStyle(
                height: 2,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: Colors.grey[700]),
            children: <Widget>[
              buildPrivateMessages(),
              buildChatMessages(),
              buildChatRequests(),
            ],
          ),
          SettingsGroup(
            title: 'ACTIVITY',
            titleTextStyle: TextStyle(
                height: 2,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: Colors.grey[700]),
            children: <Widget>[
              buildMentions(),
              buildComments(),
              buildUpVotes(),
              buildUpVotesComments(),
              buildReplies(),
              buildNewFollowers(),
            ],
          ),
          SettingsGroup(
            title: 'UPDATES',
            titleTextStyle: TextStyle(
                height: 2,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: Colors.grey[700]),
            children: <Widget>[
              buildCakeDay(),
            ],
          ),
          SettingsGroup(
            title: 'MODERATION',
            titleTextStyle: TextStyle(
                height: 2,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                color: Colors.grey[700]),
            children: <Widget>[
              buildModNotifications(),
            ],
          ),
        ],
      ),
    );
  }
}

final UserController userController = GetIt.instance.get<UserController>();
void handleNotificationSettingChange(String setting, bool value) {
  print('Updating notification settings');
  switch (setting) {
    case 'Private messages':
      userController.notificationsSettings!.privateMessages = value;
      break;
    case 'Chat messages':
      userController.notificationsSettings!.chatMessages = value;
      break;
    case 'Chat requests':
      userController.notificationsSettings!.chatRequests = value;
      break;
    case 'Mentions of u/username':
      userController.notificationsSettings!.mentions = value;
      break;
    case 'Comments on your posts':
      userController.notificationsSettings!.comments = value;
      break;
    case 'Upvotes on your posts':
      userController.notificationsSettings!.upvotesPosts = value;
      break;
    case 'Upvotes on your comments':
      userController.notificationsSettings!.upvotesComments = value;
      break;
    case 'Replies to your comments':
      userController.notificationsSettings!.replies = value;
      break;
    case 'New followers':
      userController.notificationsSettings!.newFollowers = value;
      break;
    // Add cases for other notification settings
  }
  // Call the function to update settings on the server
  //userController.updateNotificationSettings();
}

Widget buildPrivateMessages() {
  return CustomStatefulSettingsTile(
      switchValue: userController.notificationsSettings!.privateMessages,
      title: 'Private messages',
      leading: const Icon(Icons.mail_outline),
      onTap: () {},
      onChanged: handleNotificationSettingChange);
}

Widget buildChatMessages() {
  return CustomStatefulSettingsTile(
      switchValue: userController.notificationsSettings!.chatMessages,
      title: 'Chat messages',
      leading: const Icon(Icons.chat_outlined),
      onTap: () {},
      onChanged: handleNotificationSettingChange);
}

Widget buildChatRequests() {
  return CustomStatefulSettingsTile(
    switchValue: userController.notificationsSettings!.chatRequests,
    title: 'Chat requests',
    leading: const Icon(Icons.mark_unread_chat_alt_outlined),
    onTap: () {},
    onChanged: handleNotificationSettingChange,
  );
}

Widget buildMentions() {
  return CustomStatefulSettingsTile(
    switchValue: userController.notificationsSettings!.mentions,
    title: 'Mentions of u/username',
    leading: const Icon(Icons.person_outlined),
    onTap: () {},
    onChanged: handleNotificationSettingChange,
  );
}

Widget buildComments() {
  return CustomStatefulSettingsTile(
      switchValue: userController.notificationsSettings!.comments,
      title: 'Comments on your posts',
      leading: const Icon(Icons.comment_outlined),
      onTap: () {},
      onChanged: handleNotificationSettingChange);
}

Widget buildUpVotes() {
  return CustomStatefulSettingsTile(
      switchValue: userController.notificationsSettings!.upvotesPosts,
      title: 'Upvotes on your posts',
      leading: const Icon(Icons.keyboard_double_arrow_up_outlined),
      onTap: () {},
      onChanged: handleNotificationSettingChange);
}

Widget buildUpVotesComments() {
  return CustomStatefulSettingsTile(
      switchValue: userController.notificationsSettings!.upvotesComments,
      title: 'Upvotes on your comments',
      leading: const Icon(Icons.keyboard_double_arrow_up_outlined),
      onTap: () {},
      onChanged: handleNotificationSettingChange);
}

Widget buildReplies() {
  return CustomStatefulSettingsTile(
      switchValue: userController.notificationsSettings!.replies,
      title: 'Replies to your comments',
      leading: const Icon(Icons.reply_outlined),
      onTap: () {},
      onChanged: handleNotificationSettingChange);
}

Widget buildNewFollowers() {
  return CustomStatefulSettingsTile(
      switchValue: userController.notificationsSettings!.newFollowers,
      title: 'New followers',
      leading: const Icon(Icons.person_add_outlined),
      onTap: () {},
      onChanged: handleNotificationSettingChange);
}

Widget buildCakeDay() {
  return CustomStatefulSettingsTile(
      switchValue: true,
      title: 'Cake day',
      leading: const Icon(Icons.cake_outlined),
      onTap: () {},
      onChanged: handleNotificationSettingChange);
}

Widget buildModNotifications() {
  return CustomStatefulSettingsTile(
      switchValue: true,
      title: 'Mod notifications',
      leading: const Icon(Icons.notifications_outlined),
      onTap: () {},
      onChanged: handleNotificationSettingChange);
}
