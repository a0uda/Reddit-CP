import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/desktop_layout.dart';
import 'package:flutter_application_1/widgets/mobile_layout.dart';
import 'package:flutter_application_1/widgets/responsive_layout.dart';

import 'package:flutter_application_1/widgets/Listing.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/Pages/Home_Page.dart';

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
            seedColor: Colors.black,
            background: Color.fromARGB(255, 255, 255, 255)),
        fontFamily: 'Georgia',
      ),
      home: const ResponsiveLayout(
        mobileHomePage: MobileLayout(
          mobilePageMode: 0,
        ),
        desktopHomePage: DesktopHomePage(
          indexOfPage: 0,
        ),
      ),
    );
  }
}
