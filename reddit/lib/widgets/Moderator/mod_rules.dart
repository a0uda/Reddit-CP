import 'package:flutter/material.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/widgets/Moderator/create_rule_page.dart';
import 'package:reddit/widgets/Moderator/mod_rules_list.dart';

final rules = [
  const RulesItem(
    ruleTitle: "This is not a marketplace",
    ruleDescription:
        "Buying, selling, trading, begging or wagering for coins, players, real money, accounts or digital items is not allowed. Posting anything related to coin buying or selling will result in a ban.",
  ),
  const RulesItem(
    ruleTitle: "Don't be an rude",
    ruleDescription:
        "Posts and comments consisting of racist, sexist or homophobic content will be removed, regardless of popularity or relevance. Pictures showing personal information or anything that could lead to doxxing or witch-hunting will not be allowed. Click-baits, shitposts and trolling will not be tolerated and will result in an immediate ban. Treat others how you would like to be treated.",
  ),
  const RulesItem(
    ruleTitle: "Personal Attacks",
    ruleDescription:
        "We are 100% in favor of critical and constructive posts and comments as long as they are not aimed towards a specific person. Any direct or indirect attack to members of the FIFA community are strictly prohibited.",
  ),
  const RulesItem(
    ruleTitle: "We're not your free advertising or here to pay your bills",
    ruleDescription:
        "Using the subreddit's subscriber base for financial gain is not allowed. Apps, websites, streams, youtube channels or any other external source to Reddit cannot be advertised. Giveaways promoting another medium (retweet to enter, subscribe to win, etc.) are not allowed. If you wish to advertise, you can do so through reddit. Read what Reddit considers to be acceptable self-promotion here.",
  ),
  const RulesItem(
    ruleTitle: "Automatic Removal",
    ruleDescription:
        "The following topics will be automatically removed by the moderation team due to user feedback, low effort and repetitiveness.",
  ),
];

class ModRules extends StatefulWidget {
  const ModRules({super.key});

  @override
  State<ModRules> createState() => _ModRulesState();
}

class _ModRulesState extends State<ModRules> {
  int rulesCount = rules.length;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    isEditMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey,
        leading: isEditMode ? const SizedBox() : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? "EditRules" : "Rules",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            isEditMode
                ? const SizedBox()
                : Text(
                    "$rulesCount/15 rules",
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  )
          ],
        ),
        actions: [
          !isEditMode
              ? IconButton(onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateRulePage(),
                    ),
                  );
              }, icon: const Icon(Icons.add))
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: !isEditMode
                ? IconButton(
                    onPressed: () {
                      //change to edit mode badrr
                      setState(() {
                        isEditMode = true;
                      });
                    },
                    icon: const Icon(Icons.edit))
                : TextButton(
                    onPressed: () {
                      //out of edit mode
                      setState(() {
                        isEditMode = false;
                      });
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
          )
        ],
      ),
      body: ModRulesList(
        isEditMode: isEditMode,
      ),
    );
  }
}
