import 'package:flutter/material.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';

class DesktopHomePage extends StatefulWidget {
  final int indexOfPage;
  const DesktopHomePage({super.key, required this.indexOfPage});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  void logoTapped() {
      
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DesktopAppBar(logoTapped: logoTapped,),
        endDrawer: const EndDrawerReddit(),
        body: Row(
          children: [
            DrawerReddit(
              indexOfPage: widget.indexOfPage,
              inHome: true,
            ),
            const VerticalDivider(
              color: Colors.grey,
              width: 0,
            ),
            const Text("YARAABBBBB") // rest of the desktop home page
          ],
        ));
  }
}

