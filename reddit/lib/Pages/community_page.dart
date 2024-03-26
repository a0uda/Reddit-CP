import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reddit/Pages/description_widget.dart';
import 'package:reddit/widgets/Best_Listing.dart';
import 'package:reddit/widgets/button_widgets.dart';
import 'package:reddit/widgets/community_description.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/listing.dart';
import 'package:reddit/widgets/mobile_appbar.dart';
import 'package:reddit/Pages/create_post.dart';
import 'package:reddit/widgets/post.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage(
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
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String buttonState = 'Join';

  void setButton() {
    setState(() {
      if (buttonState == 'Joined') {
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
          VerticalDivider(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CommunityDescription(
                              communityName: widget.communityName,
                              communityMembersNo: widget.communityMembersNo,
                              communityProfilePicturePath:
                                  widget.communityProfilePicturePath,
                              communityRule: widget.communityRule,
                              communityDescription: widget.communityDescription,
                            ),
                            Row(
                              children: [
                                if (buttonState == 'Join')
                                  ButtonWidgets(buttonState,
                                      backgroundColour: Colors.black,
                                      foregroundColour: Colors.white, () {
                                    setButton();
                                  })
                                else
                                  ButtonWidgets(buttonState, () {
                                    setButton();
                                  }),
                                ButtonWidgets('Create a post',
                                    icon: const Icon(Icons.add), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreatePost(
                                        currentCommunity: widget.communityName,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    height: 1,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Post(
                          profileImageUrl: "assets/images/profile.png",
                          name: "John Doe",
                          title: "Flutter is the best",
                          postContent: "Flutter is the best",
                          date: "2021-09-09",
                          likes: 4,
                          comments: "1",
                          communityName: "r/FlutterDev",
                        ),
                      ),
                      if (MediaQuery.of(context).size.width > 700)
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                margin: const EdgeInsets.only(right: 20),
                                child: DescriptionWidget(
                                  communityDescription:
                                      widget.communityDescription,
                                  communityRules: widget.communityRule,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
