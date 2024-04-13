import 'package:flutter/material.dart';
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
  List<Map<String, String>> foundUsers = [];
  bool editable = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    foundUsers = moderatorsList;
    editable = false;
  }

  void searchUsers(String search) {
    setState(() {
      foundUsers = moderatorsList.where((user) {
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
        children: <Widget>[
          (screenWidth > 700)
              ? AppBar(
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
                                    AssetImage(item["pictureUrl"]!),
                                radius: 15,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "u/${item["username"]!}",
                                  ),
                                  Text(
                                    item["modTime"]!,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
                                    AssetImage(item["pictureUrl"]!),
                                radius: 15,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "u/${item["username"]!}",
                                  ),
                                  Text(
                                    item["modTime"]!,
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
                                                title:
                                                    const Text("View Profile"),
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
  }
}
