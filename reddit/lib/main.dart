import 'package:flutter/material.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Pages/login.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/community_service.dart';
import 'package:reddit/widgets/Moderator/desktop_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mobile_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mod_responsive.dart';
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
  GetIt.instance.registerSingleton<PostService>(PostService());
  GetIt.instance.registerSingleton<UserService>(UserService());
  GetIt.instance.registerSingleton<UserController>(UserController());
  GetIt.instance.registerSingleton<CommunityService>(CommunityService());
  GetIt.instance.registerSingleton<CommunityController>(CommunityController());

  runApp(const MyApp());
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
      home: const ModResponsive(
        mobileLayout: MobileModTools(),
        desktopLayout: DesktopModTools(
          index: 0,
        ),
      ),
    );
  }
}
