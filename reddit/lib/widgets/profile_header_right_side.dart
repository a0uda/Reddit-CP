import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/widgets/edit_profile.dart';
import 'package:share_plus/share_plus.dart';
import '../Services/user_service.dart';
import '../Controllers/user_controller.dart';
import 'package:get_it/get_it.dart';
import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';

class ProfileHeaderRightSide extends StatefulWidget {
  final String userType;
  final UserAbout userData;

  const ProfileHeaderRightSide(
      {super.key, required this.userData, required this.userType});

  @override
  _ProfileHeaderRightSideState createState() =>
      _ProfileHeaderRightSideState(userData: userData, userType: userType);
}

class _ProfileHeaderRightSideState extends State<ProfileHeaderRightSide> {
  String
      userType; //if user type is 'me' then show edit button, else show message and follow button
  UserAbout userData;
  _ProfileHeaderRightSideState(
      {required this.userData, required this.userType});

  final UserController userController = GetIt.I.get<UserController>();
  final userService = GetIt.I.get<UserService>();

  List<FollowersFollowingItem>? followingList;
  bool _dataFetched = false;
  bool _firstTime = true;

  void loadFollowingList() async {
    if (userType != 'me') {
      if (_firstTime) {
        followingList =
            await userService.getFollowing(userController.userAbout!.username);
        _firstTime = false;
      } else {
        followingList = userController.following;
      }
    }
    setState(() {
      _dataFetched = true;
    });
  }

  Widget _buildLoading() {
    return Container(
      color: Colors.transparent,
    );
  }

  Widget _buildProfileHeaderRightSide() {
    var followerFollowingController =
        context.read<FollowerFollowingController>();
    return SizedBox(
      width: (1 / 3) * MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.white, size: 40),
                onPressed: () async {
                  var link =
                      'https://redditech.me/user/${userData.username}/saved';
                  await Share.share('Check out this profile on Reddit: $link');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: TextButton(
                onPressed: () async {
                  if (userType == 'me') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen()),
                    );
                  } else {
                    if (followingList!
                        .where(
                            (element) => element.username == userData.username)
                        .isEmpty) {
                      await followerFollowingController
                          .followUser(userData.username);
                    } else {
                      await followerFollowingController
                          .unfollowUser(userData.username);
                    }
                    setState(() {
                      _dataFetched = false;
                    });
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      0, 68, 70, 71), // example background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
                child: userType == 'me'
                    ? const Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: (followingList!
                                .where((element) =>
                                    element.username == userData.username)
                                .isNotEmpty)
                            ? [
                                const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                const Flexible(
                                  child: Text(
                                    'Following',
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ]
                            : [
                                const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                const Flexible(
                                  child: Text(
                                    'Follow',
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                      ),
              ),
            ),
            userType != 'me'
                ? Padding(
                    padding: const EdgeInsets.only(top: 20, left: 5),
                    child: IconButton(
                      icon: const Icon(Icons.message,
                          color: Colors.white, size: 30),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(0, 68, 70, 71),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_dataFetched) {
      loadFollowingList();
    }
    return _dataFetched ? _buildProfileHeaderRightSide() : _buildLoading();
  }
}
