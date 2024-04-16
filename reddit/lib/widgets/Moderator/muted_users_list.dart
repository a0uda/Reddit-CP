import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/add_muted_user.dart';
import 'package:reddit/widgets/Moderator/muted_users.dart';

class MutedUsersList extends StatefulWidget {
  const MutedUsersList({super.key});

  @override
  State<MutedUsersList> createState() => _MutedUsersListState();
}

class _MutedUsersListState extends State<MutedUsersList> {
  List<Map<String, String>> foundUsers = [];

  @override
  void initState() {
    super.initState();
    foundUsers = List.from(mutedUsers);
  }

  void searchUsers(String search) {
    setState(() {
      foundUsers = mutedUsers.where((user) {
        final name = user['username'].toString().toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          (screenWidth > 700)
              ? AppBar(
                  title: const Text(
                    'Muted Users',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color.fromARGB(255, 42, 101, 210)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AddMutedUser(),
                              ),
                            );
                          }, // Ban user Badrrr ele hya add
                          child: const Text(
                            "Mute User",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ])
              : const SizedBox(),
          TextField(
            onChanged: searchUsers,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: 20,
              ),
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
                          item["muteTime"]!,
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
                                      title: const Text("Unmute"),
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
