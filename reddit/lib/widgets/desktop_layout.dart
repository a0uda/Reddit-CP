import 'package:flutter/material.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/Listing.dart';

class DesktopHomePage extends StatefulWidget {
  final int indexOfPage;
  const DesktopHomePage({super.key, required this.indexOfPage});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  void logoTapped() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DesktopAppBar(
          logoTapped: logoTapped,
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
              color:Theme.of(context).colorScheme.primary,
              width: 1,
            ),
           const  Expanded(
              flex: 4,
              child: Listing(),
            ),    
       
            
           // rest of the desktop home page
          ],
        ));
  }
}
