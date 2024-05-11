import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/Moderator/add_modderator.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';

// ignore: must_be_immutable
class ModeratorsList extends StatefulWidget {
  bool isInvite;
  String msgID;
  ModeratorsList({
    this.isInvite = false,
    this.msgID = '',
    super.key,
  });

  @override
  State<ModeratorsList> createState() => _ModeratorsListState();
}

class _ModeratorsListState extends State<ModeratorsList>
    with TickerProviderStateMixin {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();
  List<Map<String, dynamic>> foundUsers = [];
  List<Map<String, dynamic>> foundeditableUsers = [];
  List<Map<String, dynamic>> editableMods = [];
  final TextEditingController usernameController = TextEditingController();
  bool editable = false;
  bool userFetched = false;
  int currentIndex = 0;
  int? startIndex;

  Future<void> fetchModerators() async {
    if (!userFetched) {
      await moderatorController
          .getModerators(moderatorController.communityName);
      startIndex = moderatorController.moderators.indexWhere(
          (mod) => mod["username"] == userController.userAbout?.username);
      editableMods = startIndex! >= 0
          ? moderatorController.moderators.sublist(startIndex!)
          : [];
      usernameController.text = "";
      setState(() {
        foundUsers = moderatorController.moderators;
        foundeditableUsers = editableMods;
        userFetched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userFetched = false;
    foundUsers = moderatorController.moderators;
    foundeditableUsers = editableMods;
    editable = false;
    if (widget.isInvite &&
        foundUsers.any((element) =>
                element["username"] == userController.userAbout!.username) ==
            false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invitation'),
              content: const Text(
                "To accept being a moderator, choose accept",
              ),
              actions: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () async {
                      await moderatorController.addAsMod(
                          userController.userAbout!.username,
                          userController.userAbout!.profilePicture!,
                          moderatorController.communityName,
                          widget.msgID);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text(
                      'ACCEPT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      });
    }
  }

  void searchUsers(String search) {
    setState(() {
      userFetched = true;
      foundUsers = moderatorController.moderators.where((user) {
        final name = user['username'].toString().toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
      foundeditableUsers = editableMods.where((user) {
        final name = user['username'].toString().toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //var moderatorProvider = context.read<ModeratorProvider>();
    return Consumer<ModeratorProvider>(
        builder: (context, moderatorProvider, child) {
      return Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            (screenWidth > 700)
                ? AppBar(
                    leading: const SizedBox(),
                    title: const Text(
                      'Moderators',
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
                                  builder: (context) => const AddModerator(),
                                ),
                              );
                            } else {
                              showError(context);
                            }
                          }, // add mod Badrrr ele hya add
                          child: const Text(
                            "Invite user as mod",
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
            Container(
              color: Colors.white,
              child: TabBar(
                indicatorColor: const Color.fromARGB(255, 24, 82, 189),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Editable'),
                ],
                controller: TabController(
                  length: 2,
                  vsync: this,
                  initialIndex: currentIndex,
                ),
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: TabController(
                    length: 2,
                    vsync: this,
                    initialIndex: currentIndex,
                  ),
                  children: [
                    // Tab 1 content
                    RefreshIndicator(
                      onRefresh: () async {
                        userFetched = false;
                        await fetchModerators();
                      },
                      child: FutureBuilder<void>(
                        future: fetchModerators(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return const Text('none');
                            case ConnectionState.waiting:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              return Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: foundUsers.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final item = foundUsers[index];
                                        final moderatorSince = DateTime.parse(
                                            item["moderator_since"]!);
                                        return Card(
                                          elevation: 0,
                                          margin:
                                              const EdgeInsets.only(bottom: 1),
                                          color: Colors.white,
                                          child: ListTile(
                                            onTap: () async {
                                              UserAbout otherUserData =
                                                  (await (userService
                                                      .getUserAbout(
                                                          item["username"])))!;
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
                                            tileColor: Colors.white,
                                            leading: (item["profile_picture"] !=
                                                        null &&
                                                    item["profile_picture"] !=
                                                        "")
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(item[
                                                            "profile_picture"]!),
                                                    radius: 15,
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        "images/Greddit.png"),
                                                    radius: 15,
                                                  ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "u/${item["username"]!}",
                                                ),
                                                Text(
                                                  '${moderatorSince.day}-${moderatorSince.month}-${moderatorSince.year}',
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            default:
                              return const Text('badr');
                          }
                        },
                      ),
                    ),

                    // Tab 2 content
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: foundeditableUsers.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = foundeditableUsers[index];
                              final moderatorSince =
                                  DateTime.parse(item["moderator_since"]!);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "u/${item["username"]!}",
                                      ),
                                      Text(
                                        '${moderatorSince.day}-${moderatorSince.month}-${moderatorSince.year}',
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
                                                    leading: const Icon(
                                                        Icons.person),
                                                    title: const Text(
                                                        "View Profile"),
                                                    onTap: () async {
                                                      //navigate to profile of this mod Badrr
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
                                                      //remove mod
                                                      if (moderatorController
                                                              .modAccess
                                                              .everything ||
                                                          moderatorController
                                                              .modAccess
                                                              .manageUsers) {
                                                        await moderatorProvider
                                                            .removeAsMod(
                                                                item[
                                                                    "username"],
                                                                moderatorController
                                                                    .communityName);
                                                        setState(() {
                                                          foundUsers =
                                                              moderatorController
                                                                  .moderators;
                                                          editableMods =
                                                              moderatorController
                                                                  .moderators
                                                                  .sublist(
                                                                      startIndex!);
                                                          foundeditableUsers =
                                                              editableMods;
                                                          userFetched = true;
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
                                  onTap: () async {
                                    UserAbout otherUserData =
                                        (await (userService
                                            .getUserAbout(item["username"])))!;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                            otherUserData, 'other'),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ],
        ),
      );
    });
  }
}
