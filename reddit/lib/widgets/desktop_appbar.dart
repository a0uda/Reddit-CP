import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Pages/create_post.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/widgets/Search/search_in_community.dart';
import 'package:reddit/Services/notifications_service.dart';
import 'package:reddit/widgets/inbox_options.dart';
import 'package:reddit/widgets/Search/search_bar.dart';
import 'package:reddit/widgets/chat_intro.dart';
import 'package:reddit/widgets/listing_notifications.dart';
import 'package:reddit/widgets/messages_list.dart';

class DesktopAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback logoTapped;
  final bool isInbox;
  final bool isInCommunity;
  final String communityName;
  const DesktopAppBar({
    super.key,
    required this.logoTapped,
    this.isInbox = false,
    this.isInCommunity = false,
    this.communityName = "",
  });

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
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 50.0),
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
                        elevation: 0,
                        backgroundColor: Colors.grey[200],
                        surfaceTintColor: Colors.grey[200],
                        foregroundColor: Colors.grey,
                        shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    child: Row(children: [
                      const Icon(
                        CupertinoIcons.search,
                        color: Colors.black,
                      ),
                      widget.isInCommunity
                          ? Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 8, 15, 8 ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  "r/${widget.communityName}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const Text("Search..."),
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
              padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width * 1/50),
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                          title: DesktopAppBar(
                        logoTapped: () {},
                        isInbox: true,
                      )),
                      body: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 40,
                              color: Colors.white,
                              child: TabBar(
                                indicatorColor:
                                    const Color.fromARGB(255, 24, 82, 189),
                                labelColor: Colors.black,
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Notifications'),
                                        const SizedBox(width: 5),
                                        Consumer<NotificationsService>(builder:
                                            (context, notificationsService,
                                                child) {
                                          if (userController
                                                  .unreadNotificationsCount >
                                              0) {
                                            return Container(
                                              padding: const EdgeInsets.all(1),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 15,
                                                minHeight: 15,
                                              ),
                                              child: Text(
                                                userController
                                                    .unreadNotificationsCount
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Messages'),
                                        const SizedBox(width: 5),
                                        Consumer<GetMessagesController>(
                                          builder: (context,
                                              getMessagesController, child) {
                                            if (userController
                                                    .unreadMessagesCount >
                                                0) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(1),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 15,
                                                  minHeight: 15,
                                                ),
                                                child: Text(
                                                  userController
                                                      .unreadMessagesCount
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: TabBarView(
                                children: [
                                  ListingNotifications(),
                                  MessagesPage(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
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
                        : CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
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
