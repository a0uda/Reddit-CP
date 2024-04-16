import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/community_controller.dart';

import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/community_page.dart';

import 'package:reddit/Pages/login.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/Services/community_service.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';
import 'package:reddit/widgets/Moderator/queues.dart';
import 'Services/post_service.dart';
import 'Services/user_service.dart';
import '../Controllers/user_controller.dart';
//TODO : FIREBASE
// import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Registering MockService with GetIt
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); //TODO : FIREBASE
  GetIt.instance.registerSingleton<CommentsService>(CommentsService());
  GetIt.instance.registerSingleton<PostService>(PostService());
  GetIt.instance.registerSingleton<UserService>(UserService());
  GetIt.instance.registerSingleton<UserController>(UserController());
  GetIt.instance.registerSingleton<CommunityService>(CommunityService());
  GetIt.instance.registerSingleton<CommunityController>(CommunityController());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => SocialLinksController(),
      ),
      ChangeNotifierProvider(
        create: (context) => SavePost(),
      ),
      ChangeNotifierProvider(
        create: (context) => SaveComment(),
      ),
      ChangeNotifierProvider(
        create: (context) => ProfilePictureController(),
      ),
      ChangeNotifierProvider(
        create: (context) => BannerPictureController(),
      ),
      ChangeNotifierProvider(
        create: (context) => FollowerFollowingController(),
      ),
      ChangeNotifierProvider(
        create: (context) => EditProfileController(),
      ),
      ChangeNotifierProvider(
        create: (context) => LockPost(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        iconTheme: const IconThemeData(color: Colors.black),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
        canvasColor: Colors.white,
        brightness: Brightness.light,
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 82, 78, 78),
            primary: Color.fromARGB(255, 224, 223, 223),
            secondary: const Color.fromARGB(255, 0, 0, 0),
            background: const Color.fromARGB(255, 255, 255, 255)),
        fontFamily: 'Arial',
      ),
      home: DesktopCommunityPage(
          communityName: 'Baheb Mohy',
          communityMembersNo: '3',
          communityRule: rules,
          communityProfilePicturePath: "images/Greddit.png",
          communityDescription: 'Nas betheb mohy'),
    );
  }
}

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
