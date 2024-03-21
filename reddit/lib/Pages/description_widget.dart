import 'package:flutter/material.dart';

class Rules {
  const Rules(this.title, this.description);
  final String title;
  final String description;
}

class DescriptionWidget extends StatelessWidget {
  DescriptionWidget({super.key, required this.communityDescription});

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
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 215, 215, 215),
                      height: 10,
                      thickness: 1.0,
                    ),
                    Text(
                      communityDescription,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: const Text(
                            'Rules',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 215, 215, 215),
                          height: 1,
                          thickness: 1.0,
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rules.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          RuleTile(
                            rule: rules[index],
                            index: index + 1,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RuleTile extends StatefulWidget {
  const RuleTile({super.key, required this.rule, required this.index});

  final Rules rule;
  final int index;

  @override
  RuleTileState createState() => RuleTileState();
}

class RuleTileState extends State<RuleTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.index}. ${widget.rule.title}',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 0),
              opacity: isExpanded ? 1.0 : 0.0,
              child: Visibility(
                visible: isExpanded,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.rule.description,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 215, 215, 215),
              height: 1,
              thickness: 1.0,
            ),
          ],
        ),
      );
    
  }
}
