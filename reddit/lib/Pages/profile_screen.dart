import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/tab_bar_views.dart';
import '../Models/user_about.dart';

class ProfileScreen extends StatelessWidget {
  final UserAbout? userData;
  final String userType;
  const ProfileScreen(this.userData, this.userType, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 228, 228),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 83, 165),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            ProfileHeader(userData!, userType),
            Container(
              height: 50,
              color: Colors.white,
              child: const TabBar(
                indicatorColor: Color.fromARGB(255, 24, 82, 189),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Posts'),
                  Tab(text: 'Comments'),
                  Tab(text: 'About'),
                ],
              ),
            ),
            Expanded(
              child: TabBarViews(userData),
            ),
          ],
        ),
      ),
    );
  }
}
