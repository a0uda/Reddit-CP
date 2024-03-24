import 'package:flutter/material.dart';
import 'package:reddit/Pages/login.dart';
import 'package:get_it/get_it.dart';
import 'Services/post_service.dart';

// import 'package:reddit/widgets/Listing.dart';
// import 'package:get/get.dart';
// import 'package:reddit/Pages/Home_Page.dart';

void main() {
  // Registering MockService with GetIt
  GetIt.instance.registerSingleton<PostService>(PostService());
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
              primary: Color.fromARGB(255, 224, 223, 223),
              secondary: const Color.fromARGB(255, 0, 0, 0),
              background: const Color.fromARGB(255, 255, 255, 255)),
          fontFamily: 'Arial',
        ),
        home: const LoginPage());
  }
}
