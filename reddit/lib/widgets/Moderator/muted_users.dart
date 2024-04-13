import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/add_muted_user.dart';
import 'package:reddit/widgets/Moderator/banned_user_list.dart';
import 'package:reddit/widgets/Moderator/muted_users_list.dart';

List<Map<String, String>> mutedUsers = [
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Mutedd",
    "muteTime": "1 mo ago",
  },
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Purple-7544",
    "muteTime": "1 mo ago"
  },
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Purple-7544",
    "muteTime": "1 mo ago"
  },
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Purple-7544",
    "muteTime": "1 mo ago"
  },
];

class MutedUsers extends StatefulWidget {
  const MutedUsers({super.key});

  @override
  State<MutedUsers> createState() => _MutedUsersState();
}

class _MutedUsersState extends State<MutedUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Center(child: Text("Muted Users")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddMutedUser(),
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.add)),
          ) //Badrr navigate to mute user page
        ],
      ),
      body: Container(color: Colors.grey[200], child: const MutedUsersList()),
    );
  }
}
