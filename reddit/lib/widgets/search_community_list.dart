import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/widgets/Moderator/add_approved_user.dart';


class SearchCommunityList extends StatefulWidget {
  const SearchCommunityList({super.key});

  @override
  State<SearchCommunityList> createState() => _SearchCommunityListState();
}

class _SearchCommunityListState extends State<SearchCommunityList> {
  List<CommunityBackend> foundCom = [];
  final TextEditingController usernameController = TextEditingController();
  bool comFetched = false;
  final UserController comController =
      GetIt.instance.get<UserController>();

  Future<void> fetchUserCom() async {
    if (!comFetched) {
      await comController
          .getUserCommunities();
      usernameController.text = "";
      setState(() {
        foundCom = comController.userCommunities!;
        comFetched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

  }

  void searchCom(String search) {
    setState(() {
      comFetched = true;
      foundCom = comController.userCommunities!.where((com) {
        final name = com.name.toLowerCase();
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
            comFetched = false;
            await fetchUserCom();
          },
          child: Column(
            children: [
              (screenWidth > 700)
                  ? AppBar(
                      leading: const SizedBox(
                        width: 0,
                      ),
                      title: const Text(
                        'Communities',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(),
              TextField(
                onChanged: searchCom,
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
                future: fetchUserCom(),
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
                          itemCount: foundCom.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = foundCom[index];  
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 1),
                              color: Colors.white,
                              child: ListTile(
                                tileColor: Colors.white,
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(item.profilePictureURL),
                                  radius: 15,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item.name}",
                                    ),
                          
                                  ],
                                ),
                             
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
