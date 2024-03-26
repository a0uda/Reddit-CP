
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/rules_item.dart';

final rules = [
  const RulesItem(
    ruleTitle: "This is not a marketplace",
    ruleDescription: "Buying, selling, trading, begging or wagering for coins, players, real money, accounts or digital items is not allowed. Posting anything related to coin buying or selling will result in a ban.",
  ),
  const RulesItem(
    ruleTitle: "Don't be an rude",
    ruleDescription: "Posts and comments consisting of racist, sexist or homophobic content will be removed, regardless of popularity or relevance. Pictures showing personal information or anything that could lead to doxxing or witch-hunting will not be allowed. Click-baits, shitposts and trolling will not be tolerated and will result in an immediate ban. Treat others how you would like to be treated.",
  ),
  const RulesItem(
    ruleTitle: "Personal Attacks",
    ruleDescription: "We are 100% in favor of critical and constructive posts and comments as long as they are not aimed towards a specific person. Any direct or indirect attack to members of the FIFA community are strictly prohibited.",
  ),
  const RulesItem(
    ruleTitle: "We're not your free advertising or here to pay your bills",
    ruleDescription: "Using the subreddit's subscriber base for financial gain is not allowed. Apps, websites, streams, youtube channels or any other external source to Reddit cannot be advertised. Giveaways promoting another medium (retweet to enter, subscribe to win, etc.) are not allowed. If you wish to advertise, you can do so through reddit. Read what Reddit considers to be acceptable self-promotion here.",
  ),
  const RulesItem(
    ruleTitle: "Automatic Removal",
    ruleDescription: "The following topics will be automatically removed by the moderation team due to user feedback, low effort and repetitiveness.",
  ),
];

final communities = [
    CommunityItem(
      communityID: 1,
      communityName: 'Flutter Enthusiasts',
      communityMembersNo: 5000,
      communityRules: rules,
      communityProfilePicturePath: 'images/reddit-logo.png',
      communityDescription:
          'A community for Flutter enthusiasts to share knowledge, tips, and projects.',
    ),
    CommunityItem(
      communityID: 2,
      communityName: 'Cooking Masters',
      communityMembersNo: 8000,
      communityRules: rules,
      communityProfilePicturePath: 'images/Greddit.png',
      communityDescription:
          'Join us to explore the art and science of cooking! Share your recipes, techniques, and culinary experiences.',
    ),
    CommunityItem(
      communityID: 3,
      communityName: 'Fitness Warriors',
      communityMembersNo: 10000,
      communityRules: rules,
      communityProfilePicturePath: 'images/pp.jpg',
      communityDescription:
          'Get fit and stay healthy with the support of our community! Share workouts, nutrition tips, and progress updates.',
    ),
    CommunityItem(
      communityID: 4,
      communityName: 'Photography Passion',
      communityMembersNo: 12000,
      communityRules: rules,
      communityProfilePicturePath: 'images/reddit-logo.png',
      communityDescription:
          'Capture the beauty of the world through your lens! Share your photos, techniques, and equipment recommendations.',
    ),
    CommunityItem(
      communityID: 5,
      communityName: 'Gaming Universe',
      communityMembersNo: 15000,
      communityRules: rules,
      communityProfilePicturePath: 'images/reddit-logo.png',
      communityDescription:
          'Welcome to the ultimate gaming community! Discuss your favorite games, strategies, and upcoming releases.',
    ),
  ];
