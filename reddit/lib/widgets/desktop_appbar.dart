import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Pages/create_post.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/widgets/inbox_options.dart';
import 'package:reddit/widgets/Search/search_bar.dart';
import 'package:reddit/widgets/chat_intro.dart';

class DesktopAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback logoTapped;
  final bool isInbox;
  const DesktopAppBar(
      {super.key, required this.logoTapped, this.isInbox = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<DesktopAppBar> createState() => _DesktopAppBarState();
}

class _DesktopAppBarState extends State<DesktopAppBar> {
  final userController = GetIt.instance.get<UserController>();
  late bool isInbox;

  @override
  Widget build(BuildContext context) {
    final bool userLoggedIn = userController.userAbout != null;
    isInbox = widget.isInbox;
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0), // height of the divider
        child: Divider(
          height: 1.0, // You can set this to control divider's thickness
          thickness: 1.0, // Actual thickness of the line
          color: Colors.grey[300], // Color of the divider
        ),
      ),
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      scrolledUnderElevation: 0,
      title: !isInbox
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 75.0),
                  child: GestureDetector(
                    child: Image.asset(
                      "images/desktop-logo.jpg",
                      fit: BoxFit.contain,
                      height: kToolbarHeight * (3 / 4),
                    ),
                    onTap: () {
                      widget.logoTapped();
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showSearch(context: context, delegate: SearchBarClass());
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey,
                        shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    child: const Row(children: [
                      Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      Text("Search...")
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
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * (1 / 50)),
                child: IconButton(
                  onPressed: () {
                    //Navigate to chattt
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatIntro(),
                    ));
                  },
                  icon: const Icon(CupertinoIcons.chat_bubble_text),
                ),
              )
            : const SizedBox(),
        userLoggedIn
            ? TextButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.white,
                  padding: const EdgeInsets.all(7),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CreatePost(),
                  ));
                },
                child: const Row(
                  children: [Icon(Icons.add), Text("Create")],
                ))
            : const SizedBox(),
        userLoggedIn
            ? IconButton(
                onPressed: () {
                  //Navigate to Inbox
                },
                icon: const Icon(CupertinoIcons.bell),
              )
            : const SizedBox(),
        userLoggedIn
            ? Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 5),
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
            : const SizedBox(),
        !userLoggedIn
            ? Padding(
                padding: const EdgeInsets.all(8.0),
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
            : const SizedBox(
                width: 0,
              )
      ],
    );
  }
}
