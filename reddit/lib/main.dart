import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/community_page.dart';
import 'package:reddit/Pages/login.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/chat_service.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/Services/community_service.dart';
import 'package:reddit/Services/moderator_service.dart';
import 'package:reddit/firebase_options.dart';
import 'package:reddit/Services/notifications_service.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';
import 'package:reddit/widgets/Moderator/desktop_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mobile_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mod_responsive.dart';
import 'package:reddit/widgets/Moderator/queues.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';
import 'Services/post_service.dart';
import 'Services/user_service.dart';
import '../Controllers/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  // Registering MockService with GetIt
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GetIt.instance.registerSingleton<CommentsService>(CommentsService());
  GetIt.instance.registerSingleton<PostService>(PostService());

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
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileLayout: MobileLayout(
                mobilePageMode: 0,
              ),
              desktopLayout: DesktopHomePage(
                indexOfPage: 0,
              ),
            ),
          ),
        );
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

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
      home: const LoginPage(),
    );
  }
}
