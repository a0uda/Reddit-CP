import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Pages/create_post.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/Pages/mobile_homepage.dart';
import 'package:reddit/Services/notifications_service.dart';
import 'package:reddit/widgets/messages_list.dart';
import 'package:reddit/widgets/chat_intro.dart';
import 'package:reddit/widgets/communities_mobile.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/mobile_appbar.dart';
import 'package:reddit/widgets/listing_notifications.dart';

import 'package:get_it/get_it.dart';
import '../Controllers/user_controller.dart';

class MobileLayout extends StatefulWidget {
  final int mobilePageMode;
  const MobileLayout({super.key, required this.mobilePageMode});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  final userController = GetIt.instance.get<UserController>();

  var selectedIndexPage = 0;
  void logoTapped() {
    setState(() {
      selectedIndexPage = 0;
    });
  }

  bool isInbox = false;

  @override
  Widget build(BuildContext context) {
    final bool userLoggedIn = userController.userAbout != null;
    final drawers = [
      DrawerReddit(
        indexOfPage: widget.mobilePageMode,
        inHome: true,
      ),
      const DrawerReddit(
        indexOfPage: 0,
        inHome: false,
      ),
    ];
    final screens = [
      MobileHomePage(
        widgetIndex: widget.mobilePageMode,
      ),
      const CommunitiesMobile(), //Communities Page here
      const CreatePost(),
      ChatIntro(),

      //Inbox
      DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
              color: Colors.white,
              child: TabBar(
                indicatorColor: const Color.fromARGB(255, 24, 82, 189),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Notifications'),
                        const SizedBox(width: 5),
                        Consumer<NotificationsService>(
                            builder: (context, notificationsService, child) {
                          if (userController.unreadNotificationsCount > 0) {
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
                                userController.unreadNotificationsCount
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Messages'),
                        const SizedBox(width: 5),
                        Consumer<GetMessagesController>(
                          builder: (context, getMessagesController, child) {
                            if (userController.unreadMessagesCount > 0) {
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
                                  userController.unreadMessagesCount.toString(),
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
      )
    ];
    var selectedScreen = screens[selectedIndexPage];
    var selectedDrawer = drawers[selectedIndexPage == 0 ? 0 : 1];
    return Scaffold(
        appBar: MobileAppBar(logoTapped: logoTapped, isInbox: isInbox),
        endDrawer: userLoggedIn ? EndDrawerReddit() : Container(),
        drawer: selectedDrawer,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          currentIndex: selectedIndexPage,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
                icon: selectedIndexPage == 0
                    ? const Icon(
                        Icons.home,
                        size: kToolbarHeight * (3 / 7),
                      )
                    : const Icon(
                        Icons.home_outlined,
                        size: kToolbarHeight * (3 / 7),
                      ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: selectedIndexPage == 1
                    ? const Icon(
                        CupertinoIcons.group_solid,
                        size: kToolbarHeight * (3 / 7),
                      )
                    : const Icon(
                        CupertinoIcons.group,
                        size: kToolbarHeight * (3 / 7),
                      ),
                label: "Communities"),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  size: kToolbarHeight * (3 / 7),
                ),
                label: "Create"),
            BottomNavigationBarItem(
                icon: selectedIndexPage == 3
                    ? const Icon(
                        CupertinoIcons.chat_bubble_text_fill,
                        size: kToolbarHeight * (3 / 7),
                      )
                    : const Icon(
                        CupertinoIcons.chat_bubble_text,
                        size: kToolbarHeight * (3 / 7),
                      ),
                label: "Chat"),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  // The icon
                  Icon(
                    selectedIndexPage == 4
                        ? Icons.notifications
                        : Icons.notifications_outlined,
                    size: kToolbarHeight * (3 / 7),
                  ),
                  // The notification+messages count
                  Consumer<NotificationsService>(
                      builder: (context, notificationsService, child) {
                    return Consumer<GetMessagesController>(
                        builder: (context, getMessagesController, child) {
                      if (userController.unreadNotificationsCount +
                              userController.unreadMessagesCount >
                          0) {
                        return Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              '${userController.unreadNotificationsCount + userController.unreadMessagesCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(
                          height: 0,
                          width: 0,
                        );
                      }
                    });
                  }),
                ],
              ),
              label: "Inbox",
            )
          ],
          onTap: (value) => {
            if (value != 2)
              {
                setState(() {
                  selectedIndexPage = value;
                })
              }
            else
              {
                if (userLoggedIn)
                  {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CreatePost(),
                    ))
                  }
                else
                  {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ))
                  }
              },
            if (value == 4)
              {
                setState(() {
                  isInbox = true;
                })
              }
            else
              {
                setState(() {
                  isInbox = false;
                })
              }
          },
        ),
        body: selectedScreen);
  }
}
