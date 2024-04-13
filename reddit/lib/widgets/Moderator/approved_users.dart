import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/add_approved_user.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';

List<Map<String, String>> approvedUsers = [
  {
    "pictureUrl": "images/Greddit.png",
    "username": "approved",
    "jointime": "1 mo ago",
  },
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Purple-7544",
    "jointime": "1 mo ago"
  },
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Purple-7544",
    "jointime": "1 mo ago"
  },
  {
    "pictureUrl": "images/Greddit.png",
    "username": "Purple-7544",
    "jointime": "1 mo ago"
  },
];

class ApprovedUsers extends StatefulWidget {
  const ApprovedUsers({super.key});

  @override
  State<ApprovedUsers> createState() => _ApprovedUsersState();
}

class _ApprovedUsersState extends State<ApprovedUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Center(child: Text("Approved Users")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddApprovedUser(),
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.add)),
          ) //implement add in mock badrrrr
        ],
      ),
      body: Container(color: Colors.grey[200], child: const ApprovedUserList()),
    );
  }
}
