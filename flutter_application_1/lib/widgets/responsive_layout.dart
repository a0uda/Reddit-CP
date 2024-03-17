import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileHomePage;
  final Widget desktopHomePage;

  const ResponsiveLayout(
      {super.key, required this.mobileHomePage, required this.desktopHomePage});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 700) {
        return mobileHomePage;
      } else {
        return desktopHomePage;
      }
    });
  }
}
