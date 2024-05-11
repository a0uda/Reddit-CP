import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/communtiy_backend.dart';

import 'package:reddit/widgets/add_text_share.dart';

class SearchCommunityList extends StatefulWidget {
  String postId;
  SearchCommunityList({super.key, required this.postId});

  @override
  State<SearchCommunityList> createState() => _SearchCommunityListState();
}

class _SearchCommunityListState extends State<SearchCommunityList> {
  List<CommunityBackend> foundCom = [];

  final TextEditingController usernameController = TextEditingController();
  bool comFetched = false;
  final UserController comController = GetIt.instance.get<UserController>();

  Future<void> fetchUserCom() async {
    if (!comFetched) {
      await comController.getUserCommunities();
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
    double heigth = MediaQuery.of(context).size.height;
    bool ismobile = (screenWidth < 700) ? true : false;
    return Consumer<ApprovedUserProvider>(
        builder: (context, approvedUserProvider, child) {
      return Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: RefreshIndicator(
          onRefresh: () async {
            comFetched = false;
            await fetchUserCom();
          },
          child: Column(
            children: [
              TextField(
                onChanged: searchCom,
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
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
                            return InkWell(
                              onTap: () => {
                                if (ismobile)
                                  {
                                    Navigator.of(context).pop(),
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                          decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24))),
                                            height: heigth * 0.8,
                                            width: screenWidth,
                                            padding: const EdgeInsets.all(16.0),
                                            child: AddtextShare(
                                              comName: foundCom[index].name,
                                              postId: widget.postId,
                                            ),
                                          );
                                        })
                                  }
                                else
                                  {
                                    Navigator.of(context).pop(),
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          scrollable: true,
                                          content: Builder(
                                            builder: ((context) {
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: AddtextShare(
                                                  comName: foundCom[index].name,
                                                  postId: widget.postId,
                                                ),
                                              );
                                            }),
                                          ),
                                        );
                                      },
                                    ),
                                  }
                              },
                              child: Card(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item.name}",
                                      ),
                                    ],
                                  ),
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
