import 'package:flutter/material.dart';
import 'package:reddit/widgets/listing.dart';
//import 'package:proj/components/drawer_reddit.dart';

class MobileHomePage extends StatelessWidget {
  final int widgetIndex;
  final widgetsHomePage = [
    const Center(child: Listing(type: "home",)),
    const Center(child: Listing(type: "popular",)),
    const Center(child: Text("All")),
    const Center(child: Text("Lates"))
  ];

  MobileHomePage({super.key, required this.widgetIndex});

  @override
  Widget build(BuildContext context) {
    return widgetsHomePage[widgetIndex];
  }
}
