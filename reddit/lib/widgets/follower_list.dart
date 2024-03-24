import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../Pages/profile_screen.dart';
import 'package:get_it/get_it.dart';
import '../Services/user_service.dart';
import '../Controllers/user_controller.dart';

class followerList extends StatefulWidget {
  const followerList({Key? key}) : super(key: key);

  @override
  _followerListState createState() => _followerListState();
}

class _followerListState extends State<followerList> {

  final userService = GetIt.instance.get<UserService>();
  final userController = GetIt.instance.get<UserController>();

  @override
  Widget build(BuildContext context) {

    final List<FollowersFollowingItem>? followersList =
        UserService().getFollowers(userController.userAbout!.username.toString());
    final List<FollowersFollowingItem>? followingList =
        UserService().getFollowing(userController.userAbout!.username.toString());

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Followers'),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: userService
              .getFollowersCount(userController.userAbout!.username.toString()),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: CircleAvatar(
                    backgroundImage: AssetImage(
                  (followersList![index].profileSettings!.profile_picture !=
                          null
                      ? followersList[index].profileSettings!.profile_picture!
                      : 'images/Greddit.png'),
                )),
                title: Text(
                    (followersList[index].profileSettings!.display_name != null
                        ? followersList[index].profileSettings!.display_name
                        : followersList[index].username)!),
                subtitle: Text('u/${followersList[index].username}'),
                trailing: TextButton(
                  onPressed: () {
                    setState(() {
                      if (followingList
                          .where((element) =>
                              element.username == followersList[index].username)
                          .isNotEmpty) {
                        userService.unfollowUser(followersList[index].username,
                            userController.userAbout!.username.toString());
                      } else {
                        userService.followUser(followersList[index].username,
                            userController.userAbout!.username.toString());
                      }
                    });
                  },
                  child: Text(
                    (followingList!
                            .where((element) =>
                                element.username ==
                                followersList[index].username)
                            .isNotEmpty)
                        ? 'Following'
                        : 'Follow',
                    style: TextStyle(
                      color: (followingList
                              .where((element) =>
                                  element.username ==
                                  followersList[index].username)
                              .isNotEmpty)
                          ? const Color.fromARGB(255, 110, 110, 110)
                          : Colors.blue,
                    ),
                  ),
                ),
                onTap: () {
                  var username = followersList[index].username.toString();
                  UserAbout otherUserData = userService.getUserAbout(username)!;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(otherUserData, 'other'),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
