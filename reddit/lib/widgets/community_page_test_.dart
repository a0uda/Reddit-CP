import 'package:flutter/material.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/mobile_appbar.dart';

class CommunityPageTest extends StatefulWidget {
  const CommunityPageTest(
      {super.key,
      required this.communityName,
      required this.communityMembersNo,
      required this.communityRule,
      required this.communityProfilePicturePath,
      required this.communityDescription});

  final String communityName;
  final int communityMembersNo;
  final communityRule;
  final String communityProfilePicturePath;
  final String communityDescription;
  @override
  State<CommunityPageTest> createState() => _CommunityPageTestState();
}

class _CommunityPageTestState extends State<CommunityPageTest> {
  void logoTapped() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DesktopHomePage(indexOfPage: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width > 700
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: DesktopAppBar(logoTapped: logoTapped),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: MobileAppBar(logoTapped: logoTapped),
            ),
      drawer: MediaQuery.of(context).size.width < 700
          ? const DrawerReddit(indexOfPage: 0, inHome: true)
          : null,
      endDrawer: EndDrawerReddit(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            MediaQuery.of(context).size.width > 700
                ? const DrawerReddit(
                    indexOfPage: 0,
                    inHome: true,
                  )
                : const SizedBox(
                    width: 0,
                  ),
            MediaQuery.of(context).size.width > 700
                ? VerticalDivider(
                    color: Theme.of(context).colorScheme.primary, width: 1)
                : const SizedBox(
                    width: 0,
                  ),
            const Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: /*CommunityPageTestBar(),*/ SizedBox()
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Community name, members count and description widget

class CommunityPageTestBar extends StatefulWidget {
  const CommunityPageTestBar(
      {super.key,
      required this.communityName,
      required this.communityMembersNo,
      required this.communityRule,
      required this.communityProfilePicturePath,
      required this.communityDescription});

  final String communityName;
  final int communityMembersNo;
  final communityRule;
  final String communityProfilePicturePath;
  final String communityDescription;

  @override
  State<CommunityPageTestBar> createState() => _CommunityPageTestBarState();
}

class _CommunityPageTestBarState extends State<CommunityPageTestBar> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 200,
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              "r/${widget.communityName}",
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            subtitle: Text( 
              widget.communityMembersNo as String,
              style: const TextStyle(
                  color: Color.fromARGB(255, 98, 98, 98), fontSize: 13),
            ),
            leading: const CircleAvatar(
              backgroundImage: AssetImage('images/pp.jpg'),
              backgroundColor: Colors.white,
              radius: 50,
            ),
            trailing: OutlineButtonWidget('Join', () {}),
          ),
          const Text(
            'ay kalam',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'See More',
              style: TextStyle(
                  color: Color.fromARGB(255, 37, 79, 165),
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
//Outlined Buttons Widget

class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget(this.buttonWidgetsText, this.onTap,
      {this.icon, this.backgroundColour, this.foregroundColour, super.key});

  final String buttonWidgetsText;
  final Icon? icon;
  final Color? backgroundColour;
  final Color? foregroundColour;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, left: 10),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor:
              backgroundColour == null ? Colors.white : backgroundColour,
          foregroundColor: foregroundColour == null
              ? const Color.fromARGB(255, 0, 0, 0)
              : foregroundColour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: const BorderSide(color: Colors.black),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!],
            const SizedBox(
              width: 2,
            ),
            Text(
              buttonWidgetsText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: foregroundColour == null
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : foregroundColour,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
