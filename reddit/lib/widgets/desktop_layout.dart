import 'package:flutter/material.dart';
import 'package:reddit/Pages/create_post.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/listing.dart';

final widgetsHomePage = [
  // const Center(
  //     child: Listing(
  //   type: "home",
  // )),
  // const Center(
  //     child: Listing(
  //   type: "popular",
  // )),
  CreatePost(),
  CreatePost(),
  const Center(child: Text("All")),
  const Center(child: Text("Lates"))
];

class DesktopHomePage extends StatefulWidget {
  final int indexOfPage;
  const DesktopHomePage({super.key, required this.indexOfPage});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  void logoTapped() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const DesktopHomePage(indexOfPage: 0)));
  }

  bool isInbox = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DesktopAppBar(
          logoTapped: logoTapped,
          isInbox: isInbox,
        ),
        endDrawer: EndDrawerReddit(),
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: DrawerReddit(
                indexOfPage: widget.indexOfPage,
                inHome: true,
              ),
            ),
            VerticalDivider(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
            Expanded(
              flex: 4,
              child: widgetsHomePage[widget.indexOfPage],
            ),

            // rest of the desktop home page
          ],
        ));
  }
}
