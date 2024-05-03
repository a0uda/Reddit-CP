import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Controllers/moderator_controller.dart';

import 'package:reddit/Controllers/post_controller.dart';

import 'package:reddit/Pages/login.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/chat_service.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/Services/community_service.dart';
import 'package:reddit/Services/moderator_service.dart';
import 'package:reddit/Services/search_service.dart';
import 'package:reddit/firebase_options.dart';
import 'package:reddit/Services/notifications_service.dart';
import 'Services/post_service.dart';
import 'Services/user_service.dart';
import '../Controllers/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Registering MockService with GetIt
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GetIt.instance.registerSingleton<CommentsService>(CommentsService());
  GetIt.instance.registerSingleton<PostService>(PostService());
  GetIt.instance.registerSingleton<SearchService>(SearchService());

  GetIt.instance.registerSingleton<UserService>(UserService());
  GetIt.instance.registerSingleton<UserController>(UserController());

  GetIt.instance.registerSingleton<CommunityService>(CommunityService());
  GetIt.instance.registerSingleton<CommunityController>(CommunityController());

  GetIt.instance
      .registerSingleton<ModeratorMockService>(ModeratorMockService());
  GetIt.instance.registerSingleton<ModeratorController>(ModeratorController());

  GetIt.instance.registerSingleton<ChatsService>(ChatsService());

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
      ),
      ChangeNotifierProvider(
        create: (context) => NotificationsService(),
      ),
      ChangeNotifierProvider(
        create: (context) => BlockUnblockUser(),
      ),
      ChangeNotifierProvider(
        create: (context) => MessagesOperations(),
      ),
      ChangeNotifierProvider(
        create: (context) => CreateCommunityProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => UpdateProfilePicture(),
      ),
            ChangeNotifierProvider(
        create: (context) => Edit(),
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
        home: const LoginPage());
  }
}
