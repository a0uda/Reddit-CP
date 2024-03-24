import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/tab_bar_views.dart';
import '../Services/user_service.dart';

class ProfileScreen extends StatelessWidget {
  UserAbout? userData;
  String userType;
  Function? onUpdate;
  ProfileScreen(this.userData, this.userType, this.onUpdate, {super.key});
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double widgetSize =
        screenWidth < screenHeight ? screenWidth : screenHeight;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 229, 228, 228),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 83, 165),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            ProfileHeader(userData, userType, onUpdate),
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              color: Colors.white,
              child: TabBar(
                indicatorColor: Color.fromARGB(255, 24, 82, 189),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    child: Text(
                      'Posts',
                      style: TextStyle(
                          fontSize: 0.025 *
                              widgetSize), // Adjust the font size as needed
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Comments',
                      style: TextStyle(
                          fontSize: 0.025 *
                              widgetSize), // Adjust the font size as needed
                    ),
                  ),
                  Tab(
                    child: Text(
                      'About',
                      style: TextStyle(
                          fontSize: 0.025 *
                              widgetSize), // Adjust the font size as needed
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarViews(),
            ),
          ],
        ),
      ),
    );
  }
}
