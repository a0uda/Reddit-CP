import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/Pages/create_post.dart';
import 'package:reddit/Pages/mobile_homepage.dart';
import 'package:reddit/widgets/communities_mobile.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/mobile_appbar.dart';

class MobileLayout extends StatefulWidget {
  final int mobilePageMode;
  const MobileLayout({super.key, required this.mobilePageMode});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  var selectedIndexPage = 0;
  void logoTapped() {
    setState(() {
      selectedIndexPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      const CreatePost(), //TODO: Create Post Page here - not implemented (BADR)
      MobileHomePage(
        widgetIndex: 0, //Chat page here
      ),
      MobileHomePage(
        widgetIndex: 0, //Inbox page here
      )
    ];
    var selectedScreen = screens[selectedIndexPage];
    var selectedDrawer = drawers[selectedIndexPage == 0 ? 0 : 1];

    return Scaffold(
        appBar: MobileAppBar(
          logoTapped: logoTapped,
        ),
        endDrawer: const EndDrawerReddit(),
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
            setState(() {
              selectedIndexPage = value;
            })
          },
        ),
        body: selectedScreen);
  }
}
