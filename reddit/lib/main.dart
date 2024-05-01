import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Controllers/moderator_controller.dart';

import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/community_page.dart';
import 'package:reddit/Pages/description_widget.dart';

import 'package:reddit/Pages/login.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/Services/community_service.dart';
import 'package:reddit/Services/moderator_service.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';
import 'package:reddit/widgets/Create%20Community/create_community_page.dart';
import 'package:reddit/widgets/Moderator/desktop_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mobile_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mod_responsive.dart';
import 'package:reddit/widgets/Moderator/queues.dart';
import 'package:reddit/widgets/Moderator/scheduled.dart';
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

  GetIt.instance
      .registerSingleton<ModeratorMockService>(ModeratorMockService());
  GetIt.instance.registerSingleton<ModeratorController>(ModeratorController());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => RulesProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ModeratorProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ApprovedUserProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => MutedUserProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => BannedUserProvider(),
      ),
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
      ),
      ChangeNotifierProvider(
        create: (context) => ChangeEmail(),
      ),
      ChangeNotifierProvider(
        create: (context) => ChangeGeneralSettingsProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => PostSettingsProvider(),
      )
    ],
    child: const MyApp(),
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
              primary: const Color.fromARGB(255, 224, 223, 223),
              secondary: const Color.fromARGB(255, 0, 0, 0),
              background: const Color.fromARGB(255, 255, 255, 255)),
          fontFamily: 'Arial',
        ),
        home: const DescriptionWidget(communityName: 'ayhaga'));
  }
}
