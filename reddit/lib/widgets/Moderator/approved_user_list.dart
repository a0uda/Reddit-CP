import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/Moderator/add_approved_user.dart';

class ApprovedUserList extends StatefulWidget {
  const ApprovedUserList({super.key});

  @override
  State<ApprovedUserList> createState() => _ApprovedUserListState();
}

class _ApprovedUserListState extends State<ApprovedUserList> {
  List<Map<String, dynamic>> foundUsers = [];
  final TextEditingController usernameController = TextEditingController();
  bool usersFetched = false;
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  final UserService userService = GetIt.instance.get<UserService>();

  Future<void> fetchApprovedUsers() async {
    if (!usersFetched) {
      await moderatorController
          .getApprovedUser(moderatorController.communityName);
      usernameController.text = "";
      setState(() {
        foundUsers = moderatorController.approvedUsers;
        usersFetched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //foundUsers = List.from(moderatorController.approvedUsers);
  }

  void searchUsers(String search) {
    setState(() {
      usersFetched = true;
      foundUsers = moderatorController.approvedUsers.where((user) {
        final name = user['username'].toString().toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<ApprovedUserProvider>(
        builder: (context, approvedUserProvider, child) {
      return Container(
        color: Colors.grey[200],
        child: RefreshIndicator(
          onRefresh: () async {
            usersFetched = false;
            await fetchApprovedUsers();
          },
          child: Column(
            children: [
              (screenWidth > 700)
                  ? AppBar(
                      leading: const SizedBox(
                        width: 0,
                      ),
                      title: const Text(
                        'Approved Users',
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
                              onPressed: moderatorController.modAccess.manageUsers ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddApprovedUser(),
                                  ),
                                );
                              } : null, // Approve user Badrrr ele hya add
                              child: const Text(
                                "Approve User",
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
                future: fetchApprovedUsers(),
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
                            final approvedAt =
                                DateTime.parse(item["approved_at"]!);
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 1),
                              color: Colors.white,
                              child: ListTile(
                                tileColor: Colors.white,
                                leading: (item["profile_picture"] != null &&
                                        item["profile_picture"] != "")
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            item["profile_picture"]!),
                                        radius: 15,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            AssetImage("images/Greddit.png"),
                                        radius: 15,
                                      ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "u/${item["username"]!}",
                                    ),
                                    Text(
                                      '${approvedAt.day}-${approvedAt.month}-${approvedAt.year}',
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
                                                  title: const Text("Remove"),
                                                  onTap: () async {
                                                    await approvedUserProvider
                                                        .removeApprovedUsers(
                                                            item["username"],
                                                            moderatorController
                                                                .communityName);
                                                    setState(() {
                                                      usersFetched = true;
                                                      foundUsers =
                                                          moderatorController
                                                              .approvedUsers;
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
