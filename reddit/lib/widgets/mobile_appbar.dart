import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/widgets/inbox_options.dart';
import 'package:reddit/widgets/search_bar.dart';

class MobileAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback logoTapped;
  final bool isInbox;
  const MobileAppBar(
      {super.key, required this.logoTapped, this.isInbox = false});

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
