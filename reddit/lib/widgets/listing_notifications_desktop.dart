import 'package:flutter/material.dart';
import 'package:reddit/widgets/comments_widget.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/listing.dart';
import 'package:reddit/widgets/listing_notifications.dart';

final widgetsHomePage = [
  const Center(
      child: Listing(
    type: "home",
  )),
  const Center(
      child: Listing(
    type: "popular",
  )),
  const Center(child: Text("All")),
  const Center(child: Text("Lates"))
];

class NotificationsDesktop extends StatefulWidget {
  const NotificationsDesktop({super.key});

  @override
  State<NotificationsDesktop> createState() => _NotificationsDesktopState();
}

class _NotificationsDesktopState extends State<NotificationsDesktop> {
  void logoTapped() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const DesktopHomePage(indexOfPage: 0)));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool mobile = width < 800 ? true : false;
    if (mobile) {
      return DefaultTabController(
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
                  ListingNotifications(),

                  Center(child: Text("stay tuned")), //todo: messages
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: DesktopAppBar(
          logoTapped: logoTapped,
        ),
        endDrawer: EndDrawerReddit(),
        body: Row(
          children: [
            const Expanded(
              flex: 1,
              child: DrawerReddit(
                indexOfPage: 0,
                inHome: true,
              ),
            ),
            VerticalDivider(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
            Expanded(
              flex: 4,
              child: DefaultTabController(
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
                          ListingNotifications(),

                          Center(child: Text("stay tuned")), //todo: messages
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // rest of the desktop home page
          ],
        ));
  }
}
