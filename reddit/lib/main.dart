import 'package:flutter/material.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';
import 'package:reddit/Pages/sign-up.dart';
import 'package:reddit/Pages/forgot-password.dart';
import 'package:reddit/Pages/forgot-username.dart';
import 'package:reddit/Pages/login.dart';


// import 'package:reddit/widgets/Listing.dart';
// import 'package:get/get.dart';
// import 'package:reddit/Pages/Home_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Appbar and Sidebar",
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
            primary: Color.fromARGB(255, 211, 208, 208),
            secondary: Color.fromARGB(255, 0, 0, 0),
            background:const  Color.fromARGB(255, 255, 255, 255)),
        fontFamily: 'Arial',

      ),
      home: LoginPage()
    );
  }
}
