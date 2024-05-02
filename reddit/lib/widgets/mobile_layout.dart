import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/Pages/create_post.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/Pages/mobile_homepage.dart';
import 'package:reddit/widgets/messages_list.dart';
import 'package:reddit/widgets/chat_intro.dart';
import 'package:reddit/widgets/communities_mobile.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/mobile_appbar.dart';

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
    // print('mobile layout: ${userController.userAbout?.username}');
    print(isInbox);
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
              child: const TabBar(
                indicatorColor: Color.fromARGB(255, 24, 82, 189),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Notifications'),
                  Tab(text: 'Messages'),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text("stay tuned")), //todo: notifications
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
                        size: kToolbarHeight * (3 / 5),
                      )
                    : const Icon(
                        Icons.home_outlined,
                        size: kToolbarHeight * (3 / 5),
                      ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: selectedIndexPage == 1
                    ? const Icon(
                        CupertinoIcons.group_solid,
                        size: kToolbarHeight * (3 / 5),
                      )
                    : const Icon(
                        CupertinoIcons.group,
                        size: kToolbarHeight * (3 / 5),
                      ),
                label: "Communities"),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  size: kToolbarHeight * (3 / 5),
                ),
                label: "Create"),
            BottomNavigationBarItem(
                icon: selectedIndexPage == 3
                    ? const Icon(
                        CupertinoIcons.chat_bubble_text_fill,
                        size: kToolbarHeight * (3 / 5),
                      )
                    : const Icon(
                        CupertinoIcons.chat_bubble_text,
                        size: kToolbarHeight * (3 / 5),
                      ),
                label: "Chat"),
            BottomNavigationBarItem(
                icon: selectedIndexPage == 4
                    ? const Icon(
                        Icons.notifications,
                        size: kToolbarHeight * (3 / 5),
                      )
                    : const Icon(Icons.notifications_outlined,
                        size: kToolbarHeight * (3 / 5)),
                label: "Inbox")
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
