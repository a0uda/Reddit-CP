import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/add_modderator.dart';
import 'package:reddit/widgets/Moderator/moderators.dart';

class ModeratorsList extends StatefulWidget {
  const ModeratorsList({
    super.key,
  });

  @override
  State<ModeratorsList> createState() => _ModeratorsListState();
}

class _ModeratorsListState extends State<ModeratorsList>
    with TickerProviderStateMixin {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  List<Map<String, dynamic>> foundUsers = [];
  bool editable = false;
  int currentIndex = 0;

  Future<void> fetchModerators() async {
    await moderatorController.getModerators(moderatorController.communityName);
    foundUsers = moderatorController.moderators;
    print("Badrrrrrrrr");
    print(moderatorController.moderators);
  }

  @override
  void initState() {
    super.initState();
    foundUsers = moderatorController.moderators;
    editable = false;
  }

  void searchUsers(String search) {
    setState(() {
      foundUsers = moderatorController.moderators.where((user) {
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AddModerator(),
                                ),
                              );
                            }, // add mod Badrrr ele hya add
                            child: const Text(
                              "Invite user as mod",
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
                  FutureBuilder<void>(
                    future: fetchModerators(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return const Text('none');
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator(),);
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
                                    return Card(
                                      elevation: 0,
                                      margin: const EdgeInsets.only(bottom: 1),
                                      color: Colors.white,
                                      child: ListTile(
                                        tileColor: Colors.white,
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              item["profile_picture"]!),
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
                                              item["moderator_since"]!,
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

                  // Tab 2 content
                  Column(
                    children: [
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
                                      item["moderator_since"]!,
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
                                                  onTap: () {
                                                    //navigate to profile of this mod Badrr
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.do_disturb_alt),
                                                  title: const Text("Remove"),
                                                  onTap: () {
                                                    //remove mod
                                                    moderatorProvider
                                                        .removeAsMod(
                                                            item["username"],
                                                            moderatorController
                                                                .communityName);
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
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
