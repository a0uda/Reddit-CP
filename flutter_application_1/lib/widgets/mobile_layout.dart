import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/communities_mobile.dart';
import 'package:flutter_application_1/widgets/drawer_reddit.dart';
import 'package:flutter_application_1/Pages/mobile_homepage.dart';


class MobileLayout extends StatefulWidget {
  final int mobilePageMode;
  const MobileLayout({super.key, required this.mobilePageMode});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  var selectedIndexPage = 0;
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
      const DrawerReddit(
        indexOfPage: 0,
        inHome: false,
      ),
      const DrawerReddit(
        indexOfPage: 0,
        inHome: false,
      ),
      const DrawerReddit(
        indexOfPage: 0,
        inHome: false,
      )
    ];
    final screens = [
      MobileHomePage(
        widgetIndex: widget.mobilePageMode,
      ),
      const CommunitiesMobile(),
      MobileHomePage(
        widgetIndex: 0,
      ),
      MobileHomePage(
        widgetIndex: 0,
      ),
      MobileHomePage(
        widgetIndex: 0,
      )
    ];
    var selectedScreen = screens[selectedIndexPage];
    var selectedDrawer = drawers[selectedIndexPage];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        drawer: selectedDrawer,
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          selectedIndex: selectedIndexPage,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.search), label: "Communities"),
            NavigationDestination(icon: Icon(Icons.add), label: "Create"),
            NavigationDestination(icon: Icon(Icons.chat), label: "Chat"),
            NavigationDestination(
                icon: Icon(Icons.notifications), label: "Inbox")
          ],
          onDestinationSelected: (value) => {
            setState(() {
              selectedIndexPage = value;
            })
          },
        ),
        body: selectedScreen);
  }
}
