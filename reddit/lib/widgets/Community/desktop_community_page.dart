import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/mobile_appbar.dart';

class DesktopCommunityPage extends StatefulWidget {
  const DesktopCommunityPage(
      {super.key,
      required this.communityName,
      required this.communityMembersNo,
      required this.communityRule,
      required this.communityProfilePicturePath,
      required this.communityDescription});

  final String communityName;
  final String communityMembersNo;
  final communityRule;
  final String communityProfilePicturePath;
  final String communityDescription;

  @override
  State<DesktopCommunityPage> createState() => _DesktopCommunityPageState();
}

class _DesktopCommunityPageState extends State<DesktopCommunityPage> {
  bool isJoined = false;
  String? buttonState;
  final CommunityController communityController =
      GetIt.instance.get<CommunityController>();

  @override
  void initState() {
    if (isJoined) {
      buttonState = 'Joined';
    } else {
      buttonState = 'Join';
    }
    super.initState();
  }

  void setButton() {
    setState(() {
      if (isJoined) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: const Text(
                'Are you sure you want to leave this community?',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor: const Color.fromARGB(255, 242, 243, 245),
                    foregroundColor: const Color.fromARGB(255, 109, 109, 110),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: const BorderSide(
                          color: Color.fromARGB(0, 238, 12, 0)),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isJoined = false;
                      buttonState = 'Join';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor: const Color.fromARGB(255, 240, 6, 6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: const BorderSide(
                        color: Color.fromARGB(0, 240, 6, 6),
                      ),
                    ),
                  ),
                  child: const Text('Leave'),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          isJoined = true;
          buttonState = 'Joined';
        });
      }
    });
  }

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
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
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
      body: SizedBox(
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
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: DesktopCommunityPageBar(
                        communityName: widget.communityName,
                        communityDescription: widget.communityDescription,
                        communityMembersNo: widget.communityMembersNo,
                        communityProfilePicturePath:
                            widget.communityProfilePicturePath,
                        setButtonFunction: setButton,
                        buttonState: buttonState!,
                        isJoined: isJoined,
                      ),
                    ),
                  ),
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DesktopCommunityPageBar extends StatefulWidget {
  const DesktopCommunityPageBar({
    super.key,
    required this.communityName,
    required this.communityMembersNo,
    required this.communityProfilePicturePath,
    required this.communityDescription,
    required this.buttonState,
    required this.isJoined,
    required this.setButtonFunction,
  });

  final String communityName;
  final String communityMembersNo;
  final String communityProfilePicturePath;
  final String communityDescription;
  final String buttonState;
  final bool isJoined;

  final Function() setButtonFunction;
  @override
  State<DesktopCommunityPageBar> createState() =>
      _DesktopCommunityPageBarState();
}

class _DesktopCommunityPageBarState extends State<DesktopCommunityPageBar> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 170,
            child: Stack(
              children: [
                Container(
                  height: 128,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("images/reddit-banner-image.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: screenWidth * 0.01,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        "images/pp.jpg",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric( horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: screenWidth >= 576 && screenWidth < 768
                          ? 85 // Adjust margin for medium devices
                          : screenWidth >= 768 && screenWidth < 992
                              ? 90 // Adjust margin for large devices
                              : screenWidth >= 992 && screenWidth < 1200
                                  ? 100 // Adjust margin for extra large devices
                                  : screenWidth > 1200
                                      ? 100
                                      : 80), // Default margin size),
                  child: Text(
                    "r/${widget.communityName}",
                    style: TextStyle(
                      fontSize: screenWidth >= 576 && screenWidth < 768
                          ? 20 // Adjust font size for medium devices
                          : screenWidth >= 768 && screenWidth < 992
                              ? 25 // Adjust font size for large devices
                              : screenWidth >= 992 && screenWidth < 1200
                                  ? 30 // Adjust font size for extra large devices
                                  : screenWidth > 1200
                                      ? 32
                                      : 20, // Default font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                OutlineButtonWidget(
                  'Create a post',
                  () {},
                  icon: const Icon(CupertinoIcons.add),
                  borderColor: Colors.black,
                ),
                SizedBox(width: screenWidth * 0.01),
                OutlineButtonWidget(
                  widget.buttonState,
                  () {
                    widget.setButtonFunction();
                  },
                  backgroundColour: widget.isJoined
                      ? Colors.white
                      : const Color.fromARGB(255, 69, 72, 78),
                  borderColor:
                      widget.isJoined ? Colors.black : Colors.transparent,
                  foregroundColour:
                      widget.isJoined ? Colors.black : Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

//outlined button class
class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget(this.buttonWidgetsText, this.onTap,
      {this.icon,
      this.backgroundColour,
      this.foregroundColour,
      this.borderColor,
      super.key});

  final String buttonWidgetsText;
  final Icon? icon;
  final Color? backgroundColour;
  final Color? foregroundColour;
  final Color? borderColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8, right: 14),
        backgroundColor: backgroundColour ?? Colors.white,
        foregroundColor: foregroundColour ?? const Color.fromARGB(255, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        side: BorderSide(color: borderColor ?? Colors.transparent, width: 0.4),
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
                color: foregroundColour ?? const Color.fromARGB(255, 0, 0, 0),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}