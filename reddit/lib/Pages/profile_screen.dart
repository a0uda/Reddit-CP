import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/tab_bar_views.dart';

class ProfileScreen extends StatelessWidget {
  var userData;
  String userType;
  ProfileScreen(this.userData, this.userType);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 228, 228),
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            ProfileHeader(userData, userType),
            Container(
              color: Colors.white,
              child: TabBar(
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
              child: Container(
                child: TabBarViews(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
