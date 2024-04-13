import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/add_banned_user.dart';
import 'package:reddit/widgets/Moderator/banned_user_list.dart';

List<Map<String, String>> bannedUsers = [
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Banned",
    "banTime": "1 mo ago",
  },
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Purple-7544",
    "banTime": "1 mo ago"
  },
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Purple-7544",
    "banTime": "1 mo ago"
  },
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Purple-7544",
    "banTime": "1 mo ago"
  },
];

class BannedUsers extends StatefulWidget {
  const BannedUsers({super.key});

  @override
  State<BannedUsers> createState() => _BannedUsersState();
}

class _BannedUsersState extends State<BannedUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Center(child: Text("Banned Users")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddBannedUser(),
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.add)),
          ) //Badrr navigate to ban user page
        ],
      ),
      body: Container(color: Colors.grey[200], child: const BannedUsersList()),
    );
  }
}
