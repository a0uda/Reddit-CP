import 'package:flutter/material.dart';
import 'package:reddit/Pages/description_widget.dart';
import 'package:reddit/widgets/button_widgets.dart';
import 'package:reddit/widgets/community_description.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/mobile_appbar.dart';

class Rules {
  const Rules(this.title, this.description);
  final String title;
  final String description;
}

class CommunityPage extends StatefulWidget {
  CommunityPage({super.key, required this.communityDescription});

  final String communityDescription;
  final rules = [
    const Rules(
      "This is not a marketplace",
      "Buying, selling, trading, begging or wagering for coins, players, real money, accounts or digital items is not allowed. Posting anything related to coin buying or selling will result in a ban.",
    ),
    const Rules(
      "Don't be an asshole",
      "Posts and comments consisting of racist, sexist or homophobic content will be removed, regardless of popularity or relevance. Pictures showing personal information or anything that could lead to doxxing or witch-hunting will not be allowed. Click-baits, shitposts and trolling will not be tolerated and will result in an immediate ban. Treat others how you would like to be treated.",
    ),
    const Rules(
      "Personal Attacks",
      "We are 100% in favor of critical and constructive posts and comments as long as they are not aimed towards a specific person. Any direct or indirect attack to members of the FIFA community are strictly prohibited.",
    ),
    const Rules(
      "We're not your free advertising or here to pay your bills",
      "Using the subreddit's subscriber base for financial gain is not allowed. Apps, websites, streams, youtube channels or any other external source to Reddit cannot be advertised. Giveaways promoting another medium (retweet to enter, subscribe to win, etc.) are not allowed. If you wish to advertise, you can do so through reddit. Read what Reddit considers to be acceptable self-promotion here.",
    ),
    const Rules(
      "Automatic Removal",
      "The following topics will be automatically removed by the moderation team due to user feedback, low effort and repetitiveness.",
    ),
  ];

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
              content: const Text(
                'Are you sure you want to leave the community?',
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
      endDrawer: const EndDrawerReddit(),
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
                            Container(
                              child: CommunityDescription('reddittest', 7),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  ButtonWidgets(buttonState, () {
                                    setButton();
                                  }),
                                  ButtonWidgets(
                                      'Create a post',
                                      icon: const Icon(Icons.add),
                                      () {}),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (MediaQuery.of(context).size.width > 700)
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                margin: const EdgeInsets.only(right: 20),
                                child: DescriptionWidget(
                                  communityDescription:
                                      widget.communityDescription,
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
