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
  final TextEditingController usernameController = TextEditingController();
  List<Map<String, dynamic>> foundUsers = [];
  bool usersFetched = false;

  Future<void> fetchBannedUsers() async {
    if (!usersFetched) {
      await moderatorController
          .getBannedUsers(moderatorController.communityName);
      usernameController.text = "";
      setState(() {
        foundUsers = moderatorController.bannedUsers;
        usersFetched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // foundUsers = moderatorController.bannedUsers;
  }

  void searchUsers(String search) {
    setState(() {
      usersFetched = true;
      foundUsers = moderatorController.bannedUsers.where((user) {
        final name = user['username'].toString().toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<BannedUserProvider>(
        builder: (context, bannedUserProvider, child) {
      return Container(
        color: Colors.grey[200],
        child: RefreshIndicator(
          onRefresh: () async {
            usersFetched = false;
            await fetchBannedUsers();
          },
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
                                    builder: (context) => AddBannedUser(
                                      seeDetails: false,
                                    ),
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
                controller: usernameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                  ),
                  hintText: 'Search',
                ),
              ),
              FutureBuilder<void>(
                future: fetchBannedUsers(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text('none');
                    case ConnectionState.waiting:
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: foundUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = foundUsers[index];
                            final bannedAt =
                                DateTime.parse(item["banned_date"]!);
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 1),
                              color: Colors.white,
                              child: ListTile(
                                tileColor: Colors.white,
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(item["profile_picture"]!),
                                  radius: 15,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "u/${item["username"]!}",
                                    ),
                                    Text(
                                      '${bannedAt.day}-${bannedAt.month}-${bannedAt.year}',
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
                                            padding: const EdgeInsets.only(
                                                bottom: 20.0),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.edit),
                                                  title:
                                                      const Text("See details"),
                                                  onTap: () {
                                                    //navigate to banned details of this user Badrr
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddBannedUser(
                                                          seeDetails: true,
                                                          username:
                                                              item["username"],
                                                          banReason: item[
                                                              "reason_for_ban"],
                                                          modNote:
                                                              item["mod_note"],
                                                          permanentFlag: item[
                                                              "permanent_flag"],
                                                          banNote: item[
                                                              "note_for_ban_message"],
                                                          banPeriod: item[
                                                              "banned_until"],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.person),
                                                  title: const Text(
                                                      "View Profile"),
                                                  onTap: () {
                                                    //navigate to profile of this user Badrr
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.do_disturb_alt),
                                                  title: const Text("Unban"),
                                                  onTap: () async {
                                                    //unban badrrr
                                                    await bannedUserProvider
                                                        .unBanUsers(
                                                            item["username"],
                                                            moderatorController
                                                                .communityName);
                                                    setState(() {
                                                    usersFetched = true;
                                                      foundUsers =
                                                          moderatorController
                                                              .bannedUsers;
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
                      );
                    default:
                      return const Text('badr');
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
