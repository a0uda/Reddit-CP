import 'package:flutter/material.dart';
import '../Services/user_service.dart';
import 'package:get_it/get_it.dart';
import '../Models/user_about.dart';

class TabBarAbout extends StatelessWidget {
  final UserService userService = GetIt.instance.get<UserService>();
  final UserAbout? userData;

  TabBarAbout(this.userData);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double widgetSize =
        screenWidth < screenHeight ? screenWidth : screenHeight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(
                (1 / 50) * widgetSize), // Adjust the padding as needed
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(220, 215, 213, 213),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: (1 / 25) * widgetSize,
                          top: (1 / 25) * widgetSize,
                          left: (1 / 25) *
                              widgetSize), // Adjust the padding as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${userService.getFollowersCount(userData!.username)}',
                            style: TextStyle(
                              fontSize: (1 / 33) * widgetSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Followers',
                            style: TextStyle(
                              fontSize: 0.022 * widgetSize,
                              color: const Color.fromARGB(255, 142, 141, 141),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: (1 / 25) * widgetSize,
                          top: (1 / 25) * widgetSize,
                          left: (1 / 8) *
                              widgetSize), // Adjust the padding as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${userService.getFollowingCount(userData!.username)}',
                            style: TextStyle(
                              fontSize: (1 / 33) * widgetSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Following',
                            style: TextStyle(
                              fontSize: 0.022 * widgetSize,
                              color: const Color.fromARGB(255, 142, 141, 141),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: (1 / 25) * widgetSize, // Add empty space
        ),
        userData!.about!.isEmpty
            ? Container()
            : Container(
                padding: EdgeInsets.all((1 / 25) * widgetSize),
                width: screenWidth,
                color: Colors.white,
                child: Text(
                  userData!.about!,
                  style: TextStyle(
                    fontSize: (1 / 33) * widgetSize,
                    color: Colors.black,
                  ),
                ),
              ),
      ],
    );
  }
}
