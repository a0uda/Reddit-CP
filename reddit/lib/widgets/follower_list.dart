import 'package:flutter/material.dart';
import '../Pages/profile_screen.dart';
import 'package:get_it/get_it.dart';
import '../Services/user_service.dart';
import '../Controllers/user_controller.dart';
import '../Models/followers_following_item.dart';
import '../Models/user_about.dart';

class FollowerList extends StatefulWidget {
  const FollowerList({super.key});

  @override
  FollowerListState createState() => FollowerListState();
}

class FollowerListState extends State<FollowerList> {
  final userService = GetIt.instance.get<UserService>();
  final userController = GetIt.instance.get<UserController>();
  late List<FollowersFollowingItem>? followingList;
  late List<FollowersFollowingItem>? followersList;

  void updateFollowerList() {
    setState(() {
      final String userName = userController.userAbout!.username.toString();
      followingList = userService.getFollowing(userName);
      followersList = userService.getFollowers(userName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userName = userController.userAbout!.username.toString();
    followersList = UserService().getFollowers(userName);
    followingList = UserService().getFollowing(userName);

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Followers'),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: userService.getFollowersCount(userName),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: CircleAvatar(
                    backgroundImage: AssetImage(
                  (followersList![index].profileSettings!.profilePicture != null
                      ? followersList![index].profileSettings!.profilePicture!
                      : 'images/Greddit.png'),
                )),
                title: Text(
                    (followersList![index].profileSettings!.displayName ??
                        followersList![index].username)),
                subtitle: Text('u/${followersList![index].username}'),
                trailing: TextButton(
                  onPressed: () {
                    setState(() {
                      if (followingList!
                          .where((element) =>
                              element.username ==
                              followersList![index].username)
                          .isNotEmpty) {
                        userService.unfollowUser(
                            followersList![index].username, userName);
                      } else {
                        userService.followUser(
                            followersList![index].username, userName);
                      }
                      followingList = userService.getFollowing(
                          userController.userAbout!.username.toString());
                      followersList = userService.getFollowers(
                          userController.userAbout!.username.toString());
                    });
                  },
                  child: Text(
                    (followingList!
                            .where((element) =>
                                element.username ==
                                followersList![index].username)
                            .isNotEmpty)
                        ? 'Following'
                        : 'Follow',
                    style: TextStyle(
                      color: (followingList!
                              .where((element) =>
                                  element.username ==
                                  followersList![index].username)
                              .isNotEmpty)
                          ? const Color.fromARGB(255, 110, 110, 110)
                          : Colors.blue,
                    ),
                  ),
                ),
                onTap: () async {
                  var username = followersList![index].username.toString();
                  UserAbout? otherUserData =
                      await userService.getUserAbout(username);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        otherUserData,
                        'other',
                        updateFollowerList,
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
