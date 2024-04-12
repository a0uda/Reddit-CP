import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/approved_users.dart';

class ApprovedUserList extends StatefulWidget {
  const ApprovedUserList({super.key});

  @override
  State<ApprovedUserList> createState() => _ApprovedUserListState();
}

class _ApprovedUserListState extends State<ApprovedUserList> {
  List<Map<String, String>> foundUsers = [];
  bool isDesktop = true;

  @override
  void initState() {
    super.initState();
    foundUsers = List.from(approvedUsers);
    // if (MediaQuery.of(context).size.width > 700) {
    //   isDesktop = true;
    // } else {
    //   isDesktop = false;
    // }
  }

  void searchUsers(String search) {
    setState(() {
      foundUsers = approvedUsers.where((user) {
        final name = user['username'].toString().toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (MediaQuery.of(context).size.width > 700) {
    //   isDesktop = true;
    // } else {
    //   isDesktop = false;
    // }
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          isDesktop
              ? Container(
                color: Colors.white,
                child: ListTile(
                    title: const Text(
                      "Approved Users",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(255, 24, 82, 189)),
                      onPressed: () {}, // Approve user Badrrr ele hya add
                      child: const Text(
                        "Approve User",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              )
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
            ),
          ),
        ],
      ),
    );
  }
}
