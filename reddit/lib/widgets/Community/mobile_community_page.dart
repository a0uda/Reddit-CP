import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/community_controller.dart';

import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/listing.dart';

import 'package:reddit/widgets/mobile_appbar.dart';

class MobileCommunityPage extends StatefulWidget {
  const MobileCommunityPage(
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
  State<MobileCommunityPage> createState() => _MobileCommunityPageState();
}

class _MobileCommunityPageState extends State<MobileCommunityPage> {
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
      body: Row(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: MobileCommunityPageBar(
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
    );
  }
}

//Community name, members count and description widget

class MobileCommunityPageBar extends StatefulWidget {
  const MobileCommunityPageBar({
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
  State<MobileCommunityPageBar> createState() => _MobileCommunityPageBarState();
}

class _MobileCommunityPageBarState extends State<MobileCommunityPageBar> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage(widget.communityProfilePicturePath),
                    backgroundColor: Colors.white,
                    radius: 20,
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "r/${widget.communityName}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${widget.communityMembersNo} members",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 98, 98, 98),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlineButtonWidget(
                    widget.buttonState,
                    () {
                      widget.setButtonFunction();
                    },
                    backgroundColour: widget.isJoined
                        ? Colors.white
                        : const Color.fromARGB(255, 37, 79, 165),
                    foregroundColour:
                        widget.isJoined ? Colors.black : Colors.white,
                    borderColor: widget.isJoined
                        ? Colors.black
                        : const Color.fromARGB(255, 1, 69, 173),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 0),
            child: Text(
              widget.communityDescription,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                shape: const ContinuousRectangleBorder(),
                padding: const EdgeInsets.all(0)),
            child: const Text(
              'See more',
              style: TextStyle(
                  color: Color.fromARGB(255, 37, 79, 165),
                  fontSize: 12,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: backgroundColour ?? Colors.white,
        foregroundColor: foregroundColour ?? const Color.fromARGB(255, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        side: BorderSide(color: borderColor ?? Colors.transparent),
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
