import 'package:flutter/material.dart';
import 'follower_list.dart';
import 'package:get_it/get_it.dart';
import '../Services/user_service.dart';
import '../Models/user_about.dart';

class ProfileHeaderLeftSide extends StatelessWidget {
  final userService = GetIt.instance.get<UserService>();
  final UserAbout userData;
  final String userType;

  ProfileHeaderLeftSide(this.userData, this.userType, {super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: (2 / 3) * screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20),
            child: ClipOval(
              child: Image(
                image:
                    AssetImage(userData.profilePicture ?? 'images/Greddit.png'),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5),
            child: Text(
              userData.displayName ?? userData.username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, bottom: 15),
            title: userType == 'me'
                ? Row(
                    children: <Widget>[
                      Text(
                        '${userService.getFollowersCount(userData.username)} followers',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FollowerList(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        color: Colors.white,
                        iconSize: 15,
                      )
                    ],
                  )
                : null,
            subtitle: Text(
              'u/${userData.username} - ${userData.createdAt}\n${userData.about}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
