import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';

List<Map<String, String>> approvedUsers = [
  {
    "pictureUrl": "images/reddit_orange.jpg",
    "username": "u/Purple-7544",
    "jointime": "1 mo ago",
  },
  {
    "pictureUrl": "images/reddit_orange.jpg",
    "username": "u/Purple-7544",
    "jointime": "1 mo ago"
  },
  {
    "pictureUrl": "images/reddit_orange.jpg",
    "username": "u/Purple-7544",
    "jointime": "1 mo ago"
  },
  {
    "pictureUrl": "images/reddit_orange.jpg",
    "username": "u/Purple-7544",
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
    if (MediaQuery.of(context).size.width < 700) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Center(child: Text("Approved Users")),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons
                    .search)), //Badrr mesh 3aref ehh nezam el search hena
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {}, icon: const Icon(CupertinoIcons.add)),
            ) //implement add in mock
          ],
        ),
        body: Container(
          color: Colors.grey[200],
          child: const ApprovedUserList()
        ),
      );
    }
    return const ApprovedUserList();
  }
}
