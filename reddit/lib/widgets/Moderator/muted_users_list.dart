import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/Moderator/add_muted_user.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';

class MutedUsersList extends StatefulWidget {
  const MutedUsersList({super.key});

  @override
  State<MutedUsersList> createState() => _MutedUsersListState();
}

class _MutedUsersListState extends State<MutedUsersList> {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  final UserService userService = GetIt.instance.get<UserService>();
  final TextEditingController usernameController = TextEditingController();
  List<Map<String, dynamic>> foundUsers = [];
  bool usersFetched = false;

  Future<void> fetchMutedUsers() async {
    if (!usersFetched) {
      await moderatorController
          .getMutedUsers(moderatorController.communityName);
      usernameController.text = "";
      setState(() {
        foundUsers = moderatorController.mutedUsers;
        usersFetched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    foundUsers = List.from(moderatorController.mutedUsers);
  }

  void searchUsers(String search) {
    setState(() {
      usersFetched = true;
      foundUsers = moderatorController.mutedUsers.where((user) {
        final name = user['username'].toString().toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //var mutedUserProvider = context.read<MutedUserProvider>();
    return Consumer<MutedUserProvider>(
        builder: (context, mutedUserProvider, child) {
      return Container(
        color: Colors.grey[200],
        child: RefreshIndicator(
          onRefresh: () async {
            usersFetched = false;
            await fetchMutedUsers();
          },
          child: Column(
            children: [
              (screenWidth > 700)
                  ? AppBar(
                      leading: const SizedBox(
                        width: 0,
                      ),
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
                              if (moderatorController.modAccess.everything ||
                                  moderatorController.modAccess.manageUsers) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const AddMutedUser(),
                                  ),
                                );
                              } else {
                                showError(context);
                              }
                            }, // Ban user Badrrr ele hya add
                            child: const Text(
                              "Mute User",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )
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
                future: fetchMutedUsers(),
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
                            final mutedAt = DateTime.parse(item["mute_date"]!);
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
                                      '${mutedAt.day}-${mutedAt.month}-${mutedAt.year}',
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
                                                      const Icon(Icons.person),
                                                  title: const Text(
                                                      "View Profile"),
                                                  onTap: () async {
                                                    //navigate to profile of this user Badrr
                                                    UserAbout otherUserData =
                                                        (await (userService
                                                            .getUserAbout(item[
                                                                "username"])))!;
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileScreen(
                                                                otherUserData,
                                                                'other'),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.do_disturb_alt),
                                                  title: const Text("Unmute"),
                                                  onTap: () async {
                                                    //unmute badrrr
                                                    if (moderatorController
                                                            .modAccess
                                                            .everything ||
                                                        moderatorController
                                                            .modAccess
                                                            .manageUsers) {
                                                      await mutedUserProvider
                                                          .unMuteUser(
                                                              item["username"],
                                                              moderatorController
                                                                  .communityName);
                                                      setState(() {
                                                        usersFetched = true;
                                                        foundUsers =
                                                            moderatorController
                                                                .mutedUsers;
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    } else {
                                                      showError(context);
                                                    }
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
