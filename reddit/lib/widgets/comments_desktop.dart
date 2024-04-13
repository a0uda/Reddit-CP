import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/comments_widget.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/listing.dart';

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

class CommentsDesktop extends StatefulWidget {
  final String postId;
  const CommentsDesktop({super.key, required this.postId});

  @override
  State<CommentsDesktop> createState() => _CommentsDesktopState();
}

class _CommentsDesktopState extends State<CommentsDesktop> {
  void logoTapped() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const DesktopHomePage(indexOfPage: 0)));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool mobile = width < 800 ? true : false;
    if (mobile) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Comments"),
        ),
        body: CommentsWidget(postId: widget.postId),
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
              child: CommentsWidget(postId: widget.postId),
            ),

            // rest of the desktop home page
          ],
        ));
  }
}
