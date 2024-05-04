import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/widgets/Search/search_in_community.dart';
import 'package:reddit/widgets/inbox_options.dart';
import 'package:reddit/widgets/Search/search_bar.dart';

class MobileAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback logoTapped;
  final bool isInbox;
  final bool isInCommunity;
  final String communityName;
  const MobileAppBar({
    super.key,
    required this.logoTapped,
    this.isInbox = false,
    this.isInCommunity = false,
    this.communityName = "",
  });

  @override
  State<MobileAppBar> createState() => _MobileAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MobileAppBarState extends State<MobileAppBar> {
  final userController = GetIt.instance.get<UserController>();
  late bool isInbox;

  @override
  Widget build(BuildContext context) {
    isInbox = widget.isInbox;
    final bool userLoggedIn = userController.userAbout != null;
    return AppBar(
      title: !isInbox
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: GestureDetector(
                    child: const CircleAvatar(
                      backgroundImage: AssetImage(
                        "images/logo-mobile.png",
                      ),
                      radius: 18,
                    ),
                    onTap: () {
                      widget.logoTapped();
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.isInCommunity) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SearchInCommunity(
                              communityName: widget.communityName,
                            ),
                          ),
                        );
                      } else {
                        showSearch(
                            context: context, delegate: SearchBarClass());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(left: 8),
                        elevation: 0,
                        backgroundColor: Colors.grey[200],
                        surfaceTintColor: Colors.grey[200],
                        foregroundColor: Colors.grey,
                        shadowColor: Colors.white,
                        enableFeedback: false,
                        disabledMouseCursor: SystemMouseCursors.click,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          widget.isInCommunity
                              ? Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(7, 4, 7, 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Text(
                                      "r/${widget.communityName}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const Text("Search...")
                        ]),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * (1 / 4)),
                const Text(
                  "Inbox",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                const InboxOptions()
              ],
            ),
      actions: [
        userLoggedIn
            ? Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Consumer<ProfilePictureController>(
                    builder: (context, profilepicturecontroller, child) {
                  return GestureDetector(
                    child: userController.userAbout!.profilePicture == null ||
                            userController.userAbout!.profilePicture!.isEmpty
                        ? const CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage('images/Greddit.png'),
                          )
                        : File(userController.userAbout!.profilePicture!)
                                .existsSync()
                            ? CircleAvatar(
                                radius: 18,
                                backgroundImage: FileImage(File(
                                    userController.userAbout!.profilePicture!)),
                              )
                            : CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(
                                    userController.userAbout!.profilePicture!),
                              ),
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  );
                }))
            : Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginPage()));
                  },
                  style: TextButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.orange[900],
                    shadowColor: Colors.white,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Log In"),
                ),
              )
      ],
    );
  }
}
