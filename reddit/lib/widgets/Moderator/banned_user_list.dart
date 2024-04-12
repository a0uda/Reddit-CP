import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/banned_user.dart';

class BannedUsersList extends StatefulWidget {
  const BannedUsersList({super.key});

  @override
  State<BannedUsersList> createState() => _BannedUsersListState();
}

class _BannedUsersListState extends State<BannedUsersList> {
  List<Map<String, String>> foundUsers = [];

  @override
  void initState() {
    super.initState();
    foundUsers = List.from(bannedUsers);
  }

  void searchUsers(String search) {
    setState(() {
      foundUsers = bannedUsers.where((user) {
        final name = user['username'].toString().toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          TextField(
                onChanged: searchUsers,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search , size: 20,),
                  hintText: 'Search',
                ),
              ),
          Expanded(
            child: ListView.builder(
              itemCount: foundUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final item = foundUsers[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 1),
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
                          "u/${item["username"]!}",
                        ),
                        Text(
                          item["banTime"]!,
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
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
                                      leading: const Icon(Icons.edit),
                                      title: const Text("See details"),
                                      onTap: () {
                                        //navigate to profile of this user Badrr
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.person),
                                      title: const Text("View Profile"),
                                      onTap: () {
                                        //navigate to profile of this user Badrr
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.do_disturb_alt),
                                      title: const Text("Unban"),
                                      onTap: () {
                                        //unban badrrr
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
            ),
          ),
        ],
      ),
    );
  }
}
