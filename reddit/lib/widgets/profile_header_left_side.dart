import 'package:flutter/material.dart';
import 'follower_list.dart';
import 'package:get_it/get_it.dart';
import '../Services/user_service.dart';
import '../Models/user_about.dart';

class ProfileHeaderLeftSide extends StatelessWidget {
  final userService = GetIt.instance.get<UserService>();
  final UserAbout userData;
  final String userType;

  ProfileHeaderLeftSide(this.userData, this.userType, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double widgetSize =
        screenWidth < screenHeight ? screenWidth : screenHeight;

    return SizedBox(
      width: (2 / 3) * screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: (1 / 25) * widgetSize, left: (1 / 25) * widgetSize),
            child: ClipOval(
              child: Image(
                image: AssetImage(
                    userData.profile_picture ?? 'images/Greddit.png'),
                width: widgetSize * 0.2, // Adjust according to your need
                height: widgetSize * 0.2, // Adjust according to your need
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: (1 / 25) * widgetSize, bottom: (1 / 50) * widgetSize),
            child: Text(
              userData.display_name ?? userData.username,
              style: TextStyle(
                color: Colors.white,
                fontSize: 0.05 * widgetSize, // Adjust according to your need
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
                left: (1 / 25) * widgetSize, bottom: (1 / 25) * widgetSize),
            title: userType == 'me'
                ? Row(
                    children: <Widget>[
                      Text(
                        '${userService.getFollowersCount(userData.username)} followers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 0.025 * widgetSize,
                          fontWeight:
                              FontWeight.bold, // Adjust according to your need
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const followerList(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        color: Colors.white,
                        iconSize:
                            0.025 * widgetSize, // Adjust according to your need
                      )
                    ],
                  )
                : null,
            subtitle: Text(
              'u/${userData.username} - ${userData.created_at}\n${userData.about}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 0.025 * widgetSize, // Adjust according to your need
              ),
            ),
          ),
        ],
      ),
    );
  }
}
