import 'package:flutter/material.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
import 'package:reddit/widgets/custom_stateful_settings_tile.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
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

Widget buildPrivateMessages() {
  return CustomStatefulSettingsTile(
    title: 'Private messages',
    leading: const Icon(Icons.mail_outline),
    onTap: () {},
    onChanged: (value) {},
  );
}

Widget buildChatMessages() {
  return CustomStatefulSettingsTile(
    title: 'Chat messages',
    leading: const Icon(Icons.chat_outlined),
    onTap: () {},
    onChanged: (value) {},
  );
}

Widget buildChatRequests() {
  return CustomStatefulSettingsTile(
    title: 'Chat requests',
    leading: const Icon(Icons.mark_unread_chat_alt_outlined),
    onTap: () {},
    onChanged: (value) {},
  );
}

Widget buildMentions() {
  return CustomStatefulSettingsTile(
    title: 'Mentions of u/username',
    leading: const Icon(Icons.person_outlined),
    onTap: () {},
    onChanged: (value) {},
  );
}

Widget buildComments() {
  return CustomStatefulSettingsTile(
    title: 'Comments on your posts',
    leading: const Icon(Icons.comment_outlined),
    onTap: () {},
    onChanged: (value) {},
  );
}

Widget buildUpVotes() {
  return CustomStatefulSettingsTile(
    title: 'Upvotes on your posts',
    leading: const Icon(Icons.keyboard_double_arrow_up_outlined),
    onTap: () {},
    onChanged: (value) {},
  );
}

Widget buildUpVotesComments() {
  return CustomStatefulSettingsTile(
    title: 'Upvotes on your comments',
    leading: const Icon(Icons.keyboard_double_arrow_up_outlined),
    onTap: () {},
    onChanged: (value) {},
  );
}

Widget buildReplies() {
  return CustomStatefulSettingsTile(
    title: 'Replies to your comments',
    leading: const Icon(Icons.reply_outlined),
    onTap: () {},
    onChanged: (value) {},
  );
}

Widget buildNewFollowers() {
  return CustomStatefulSettingsTile(
    title: 'New followers',
    leading: const Icon(Icons.person_add_outlined),
    onTap: () {},
    onChanged: (value) {},
  );
}

Widget buildCakeDay() {
  return CustomStatefulSettingsTile(
    title: 'Cake day',
    leading: const Icon(Icons.cake_outlined),
    onTap: () {},
    onChanged: (value) {},
  );
}

Widget buildModNotifications() {
  return CustomStatefulSettingsTile(
    title: 'Mod notifications',
    leading: const Icon(Icons.notifications_outlined),
    onTap: () {},
    onChanged: (value) {},
  );
}
