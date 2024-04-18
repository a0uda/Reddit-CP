import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/add_banned_user.dart';

class BannedUsersList extends StatefulWidget {
  const BannedUsersList({super.key});

  @override
  State<BannedUsersList> createState() => _BannedUsersListState();
}

class _BannedUsersListState extends State<BannedUsersList> {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  List<Map<String, dynamic>> foundUsers = [];

  @override
  void initState() {
    super.initState();
    foundUsers = moderatorController.bannedUsers;
  }

  void searchUsers(String search) {
    setState(() {
      foundUsers = moderatorController.bannedUsers.where((user) {
        final name = user['username'].toString().toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
    });
  }

  // {
  //   "username": "Emanuel.Gusikowski",
  //   "banned_date": "2024-04-11T03:55:03.127Z",
  //   "reason_for_ban": "rule",
  //   "mod_note": "Cursus voluptate verbum comprehendo tam vobis uberrime.",
  //   "permanent_flag": false,
  //   "banned_until": "2024-07-30T12:43:29.146Z",
  //   "note_for_ban_message":
  //       "Acquiro victoria ocer pauper eaque umerus adsum exercitationem tribuo ars.",
  //   "profile_picture": "images/Greddit.png",
  //   "_id": "66186ace721cbd638232618a"
  // }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //var bannedUserProvider = context.read<BannedUserProvider>();
    return Consumer<BannedUserProvider>(
        builder: (context, bannedUserProvider, child) {
      return Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            (screenWidth > 700)
                ? AppBar(
                    leading: const SizedBox(
                      width: 0,
                    ),
                    title: const Text(
                      'Banned Users',
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
                                  builder: (context) => const AddBannedUser(),
                                ),
                              );
                            }, // Ban user Badrrr ele hya add
                            child: const Text(
                              "Ban User",
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
                        backgroundImage: AssetImage(item["profile_picture"]!),
                        radius: 15,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "u/${item["username"]!}",
                          ),
                          Text(
                            item["banned_date"]!,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 10),
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
                                          //navigate to banned details of this user Badrr
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
                                        leading:
                                            const Icon(Icons.do_disturb_alt),
                                        title: const Text("Unban"),
                                        onTap: () {
                                          //unban badrrr
                                          bannedUserProvider.unBanUsers(
                                              item["username"],
                                              moderatorController
                                                  .communityName);
                                          setState(() {
                                            foundUsers =
                                                moderatorController.bannedUsers;
                                          });
                                          Navigator.of(context).pop();
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
    });
  }
}
