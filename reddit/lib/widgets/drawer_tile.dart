import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/Pages/community_page.dart';

void navigateToCommunity(Widget communityPage, BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => (communityPage)));
}

class DrawerTile extends StatefulWidget {
  final List<CommunityBackend> lists;
  final String tileTitle;
  final bool isMod;
  const DrawerTile(
      {super.key,
      required this.tileTitle,
      required this.lists,
      required this.isMod});

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  bool isExpanded = false;
  bool communitiesFetched = false;
  final UserController userController = GetIt.instance.get<UserController>();
  List<CommunityBackend> lists = [];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
          ),
          title: Text(
            widget.tileTitle,
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        Visibility(
          visible: isExpanded,
          child: Column(
            children: [
              !widget.isMod
                  ? ListTile(
                      leading: const Icon(Icons.add, color: Colors.black),
                      title: const Text("Create Community"),
                      onTap: () {
                        //navigate to Create Community Page
                      },
                    )
                  : const SizedBox(),
              AnimatedOpacity(
                opacity: isExpanded ? 1.0 : 0.0,
                duration: const Duration(seconds: 0),
                curve: Curves.bounceInOut,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.lists.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = widget.lists[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(item.profilePictureURL),
                        radius: 10,
                      ),
                      title: Text(item.name),
                      onTap: () {
                        // Call the function to navigate to the community page
                        // navigateToCommunity(
                        //     item['communityPage'], context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => (CommunityPage(
                                  communityMembersNo: item.membersCount,
                                  communityName: item.name,
                                  communityProfilePicturePath:
                                      item.profilePictureURL,
                                ))));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
