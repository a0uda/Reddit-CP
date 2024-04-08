import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/approved_users.dart';

class ApprovedUserList extends StatelessWidget {
  const ApprovedUserList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            itemCount: approvedUsers.length,
            itemBuilder: (BuildContext context, int index) {
              final item = approvedUsers[index];
              return Card(
                elevation: 0,
                color: Colors.white,
                child: ListTile(
                  tileColor: Colors.white,
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(item["pictureUrl"]!),
                    radius: 15,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["username"]!,
                      ),
                      Text(
                        item["jointime"]!,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10),
                      )
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.person),
                                    title: const Text("View Profile"),
                                    onTap: () {
                                      //navigate to profile of this user Badrr
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.do_disturb_alt),
                                    title: const Text("Remove"),
                                    onTap: () {
                                      //remove user
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_horiz)),
                ),
              );
            },
          );
  }
}