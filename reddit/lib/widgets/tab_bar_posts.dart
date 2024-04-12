import 'package:flutter/material.dart';
import 'package:reddit/widgets/listing.dart';

class TabBarPosts extends StatelessWidget {
  const TabBarPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Listing(type:"profile");
  }
}
