import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/rules_item.dart';

final rules = [
  RulesItem(
    id: "0",
    ruleTitle: "This is not a marketplace",
    appliesTo: "posts",
    reportReason: "Spam",
    ruleDescription:
        "Buying, selling, trading, begging or wagering for coins, players, real money, accounts or digital items is not allowed. Posting anything related to coin buying or selling will result in a ban.",
  ),
  RulesItem(
    id: "1",
    ruleTitle: "Don't be an rude",
    appliesTo: "comments",
    ruleDescription:
        "Posts and comments consisting of racist, sexist or homophobic content will be removed, regardless of popularity or relevance. Pictures showing personal information or anything that could lead to doxxing or witch-hunting will not be allowed. Click-baits, shitposts and trolling will not be tolerated and will result in an immediate ban. Treat others how you would like to be treated.",
  ),
  RulesItem(
    id: "2",
    ruleTitle: "Personal Attacks",
    appliesTo: "Post and comments",
  ),
  RulesItem(
    id: "3",
    ruleTitle: "We're not your free advertising or here to pay your bills",
    appliesTo: "Post and comments",
    ruleDescription:
        "Using the subreddit's subscriber base for financial gain is not allowed. Apps, websites, streams, youtube channels or any other external source to Reddit cannot be advertised. Giveaways promoting another medium (retweet to enter, subscribe to win, etc.) are not allowed. If you wish to advertise, you can do so through reddit. Read what Reddit considers to be acceptable self-promotion here.",
  ),
  RulesItem(
    id: "4",
    ruleTitle: "Automatic Removal",
    appliesTo: "commments",
    reportReason: "Commments bad",
    ruleDescription:
        "The following topics will be automatically removed by the moderation team due to user feedback, low effort and repetitiveness.",
  ),
];

final communities = [
  CommunityItem(
    general: generalSettings[0],
    communityMembersNo: 5000,
    communityRules: rules,
    communityProfilePicturePath: 'images/reddit-logo.png',
    communityCoverPicturePath: 'images/reddit-logo.png',
    approvedUsers: approvedUsers,
    bannedUsers: bannedUsers,
    editableModerators: editableModerators,
    moderators: moderators,
    mutedUsers: mutedUsers,
    postTypes: "Text Only", //Mostafa Mohyy khena2a
    allowPolls: true,
    allowVideos: false,
    allowImage: false,
  ),
  CommunityItem(
    general: generalSettings[1],
    communityMembersNo: 8000,
    communityRules: rules,
    communityProfilePicturePath: 'images/Greddit.png',
    communityCoverPicturePath: 'images/Greddit.png',
    approvedUsers: approvedUsers,
    bannedUsers: bannedUsers,
    editableModerators: editableModerators,
    moderators: moderators,
    mutedUsers: mutedUsers,
    postTypes: "Any", //Mostafa Mohyy khena2a
    allowPolls: true,
    allowVideos: true,
    allowImage: true,
  ),
  CommunityItem(
    general: generalSettings[2],
    communityMembersNo: 10000,
    communityRules: rules,
    communityProfilePicturePath: 'images/pp.jpg',
    communityCoverPicturePath: null,
    approvedUsers: approvedUsers,
    bannedUsers: bannedUsers,
    editableModerators: editableModerators,
    moderators: moderators,
    mutedUsers: mutedUsers,
    postTypes: "Links Only", //Mostafa Mohyy khena2a
    allowPolls: true,
    allowVideos: true,
    allowImage: false,
  ),
  CommunityItem(
    general: generalSettings[3],
    communityMembersNo: 12000,
    communityRules: rules,
    communityProfilePicturePath: 'images/reddit-logo.png',
    communityCoverPicturePath: '',
    approvedUsers: approvedUsers,
    bannedUsers: bannedUsers,
    editableModerators: editableModerators,
    moderators: moderators,
    mutedUsers: mutedUsers,
    postTypes: "Links Only", //Mostafa Mohyy khena2a
    allowPolls: true,
    allowVideos: true,
    allowImage: false,
  ),
  CommunityItem(
    general: generalSettings[4],
    communityMembersNo: 15000,
    communityRules: rules,
    communityProfilePicturePath: 'images/reddit-logo.png',
    communityCoverPicturePath: '',
    approvedUsers: approvedUsers,
    bannedUsers: bannedUsers,
    editableModerators: editableModerators,
    moderators: moderators,
    mutedUsers: mutedUsers,
    postTypes: "Links Only", //Mostafa Mohyy khena2a
    allowPolls: true,
    allowVideos: true,
    allowImage: false,
  ),
];

List<Map<String, dynamic>> bannedUsers = [
  {
    "username": "Emanuel.Gusikowski",
    "banned_date": "2024-04-11T03:55:03.127Z",
    "reason_for_ban": "rule",
    "mod_note": "Cursus voluptate verbum comprehendo tam vobis uberrime.",
    "permanent_flag": false,
    "banned_until": "2024-07-30T12:43:29.146Z",
    "note_for_ban_message":
        "Acquiro victoria ocer pauper eaque umerus adsum exercitationem tribuo ars.",
    "profile_picture": "images/Greddit.png",
    "_id": "66186ace721cbd638232618a"
  },
  {
    "username": "Frances_Kunde39",
    "banned_date": "2024-04-11T11:18:30.280Z",
    "reason_for_ban": "spam",
    "mod_note": "Degusto minus templum ambulo.",
    "permanent_flag": false,
    "banned_until": "2025-01-29T15:33:44.391Z",
    "note_for_ban_message": "Capto qui carcer cattus.",
    "profile_picture": "images/Greddit.png",
    "_id": "66186ace721cbd638232618b"
  },
  {
    "username": "Dorothea48",
    "banned_date": "2024-04-11T19:59:07.443Z",
    "reason_for_ban": "spam",
    "mod_note": "Torqueo cunabula audax deripio sortitus coepi virtus tutis.",
    "permanent_flag": false,
    "banned_until": "2025-01-15T11:01:14.293Z",
    "note_for_ban_message":
        "Amplexus uredo circumvenio textus testimonium conitor arto undique utrum.",
    "profile_picture": "images/Greddit.png",
    "_id": "66186ace721cbd638232618c"
  },
];
List<Map<String, dynamic>> mutedUsers = [
  {
    "username": "Rick.Rempel-Hermiston",
    "muted_by_username": "Arely_Lockman20",
    "mute_date": "2024-04-11T19:40:34.973Z",
    "mute_reason": "Claro neque tabesco tutis argumentum.",
    "profile_picture": "images/Greddit.png",
    "_id": "66186ace721cbd6382326184"
  },
  {
    "username": "Jamarcus.Hoeger66",
    "muted_by_username": "Anthony61",
    "mute_date": "2024-04-11T04:00:52.134Z",
    "mute_reason": "Depereo delibero molestiae fugit.",
    "profile_picture": "images/Greddit.png",
    "_id": "66186ace721cbd6382326185"
  },
  {
    "username": "Alejandra_Lowe95",
    "muted_by_username": "Dustin39",
    "mute_date": "2024-04-11T18:32:17.712Z",
    "mute_reason": "Ante agnosco velociter complectus.",
    "profile_picture": "images/Greddit.png",
    "_id": "66186ace721cbd6382326186"
  },
];

List<Map<String, dynamic>> approvedUsers = [
  {
    "username": "badr",
    "approved_at": "2024-04-11T07:51:09.795Z",
    "profile_picture": "images/Greddit.png",
    "_id": "6618844ad57c873637b5cf44"
  },
  {
    "username": "mohy",
    "approved_at": "2024-04-11T07:17:28.324Z",
    "profile_picture": "images/Greddit.png",
    "_id": "6618844ad57c873637b5cf45"
  },
  {
    "username": "fouda",
    "approved_at": "2024-04-11T08:18:25.843Z",
    "profile_picture": "images/Greddit.png",
    "_id": "6618844ad57c873637b5cf46"
  },
];

List<Map<String, dynamic>> moderators = [
  {
    "everything": true,
    "manage_users": true,
    "manage_settings": true,
    "manage_posts_and_comments": true,
    "username": "Billie_Purdy",
    "profile_picture": "images/Greddit.png",
    "moderator_since": "2024-04-11T09:26:55.614Z"
  },
  {
    "everything": true,
    "manage_users": true,
    "manage_settings": true,
    "manage_posts_and_comments": true,
    "username": "Sadie20",
    "profile_picture": "images/Greddit.png",
    "moderator_since": "2024-04-11T22:00:20.425Z"
  },
  {
    "everything": true,
    "manage_users": true,
    "manage_settings": true,
    "manage_posts_and_comments": true,
    "username": "malak12345",
    "profile_picture": "images/Greddit.png",
    "moderator_since": "2024-04-12T00:10:12.643Z"
  },
];

List<Map<String, dynamic>> editableModerators = [
  {
    "username": "Sadie20",
    "profile_picture": "images/Greddit.png",
    "moderator_since": "2024-04-11T22:00:20.425Z"
  },
  {
    "username": "malak12345",
    "profile_picture": "images/Greddit.png",
    "moderator_since": "2024-04-12T00:10:12.643Z"
  }
];

List<GeneralSettings> generalSettings = [
  GeneralSettings(
    communityID: "1",
    communityName: 'Hyatt___Tillman',
    communityDescription: 'A community for Flutter enthusiasts.',
    communityType: "Public",
    nsfwFlag: false,
  ),
  GeneralSettings(
    communityID: "2",
    communityName: 'Cooking Masters',
    communityDescription: 'Join us to explore the art and science of cooking!',
    communityType: "Private",
    nsfwFlag: false,
  ),
  GeneralSettings(
    communityID: "3",
    communityName: 'Fitness Warriors',
    communityDescription:
        'Get fit and stay healthy with the support of our community!',
    communityType: "Restricted",
    nsfwFlag: false,
  ),
  GeneralSettings(
    communityID: "4",
    communityName: 'Photography Passion',
    communityDescription: 'Capture the beauty of the world through your lens!',
    communityType: "Restricted",
    nsfwFlag: false,
  ),
  GeneralSettings(
    communityID: "5",
    communityName: 'Gaming Universe',
    communityDescription: 'Welcome to the ultimate gaming community!',
    communityType: "Restricted",
    nsfwFlag: false,
  ),
];
