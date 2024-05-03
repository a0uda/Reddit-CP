import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final TextEditingController followerNameController = TextEditingController();
  List<FollowersFollowingItem>? followers;
  List<FollowersFollowingItem>? following;
  bool _dataFetched = false;

  Widget _buildLoading() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildFollowersList() {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: searchfollowers,
          controller: followerNameController,
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              size: 20,
            ),
            hintText: 'Search',
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: followers!.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: followers![index].profilePicture == null ||
                      followers![index].profilePicture == ''
                  ? const CircleAvatar(
                      backgroundImage: AssetImage('images/Greddit.png'),
                    )
                  : File(followers![index].profilePicture!).existsSync()
                      ? CircleAvatar(
                          backgroundImage: FileImage(
                              File(followers![index].profilePicture!)),
                        )
                      : CircleAvatar(
                          backgroundImage:
                              AssetImage(followers![index].profilePicture!),
                        ),
              title: Text((followers![index].displayName ??
                  followers![index].username)),
              subtitle: Text('u/${followers![index].username}'),
              trailing: Consumer<FollowerFollowingController>(
                builder: (context, followerFollowingController, child) {
                  return TextButton(
                    onPressed: () async {
                      if (following!
                          .where((element) =>
                              element.username == followers![index].username)
                          .isNotEmpty) {
                        print('unfollow fi followers list');
                        print(followers![index].username);
                        await followerFollowingController
                            .unfollowUser(followers![index].username);
                      } else {
                        print('follow fi followers list');
                        print(followers![index].username);
                        await followerFollowingController
                            .followUser(followers![index].username);
                      }
                      setState(() {
                        _dataFetched = false;
                      });
                    },
                    child: Text(
                      (following!.any((element) =>
                                  element.username ==
                                  followers![index].username) ==
                              true)
                          ? 'Following'
                          : 'Follow',
                      style: TextStyle(
                        color: (following!.any((element) =>
                                    element.username ==
                                    followers![index].username) ==
                                true)
                            ? const Color.fromARGB(255, 110, 110, 110)
                            : Colors.blue,
                      ),
                    ),
                  );
                },
              ),
              onTap: () async {
                var username = followers![index].username.toString();
                UserAbout otherUserData =
                    (await (userService.getUserAbout(username)))!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(otherUserData, 'other'),
                  ),
                );
              });
        },
      ),
    );
  }

  void searchfollowers(String text) {
    for (var follower in userController.followers!) {
      print(follower.username);
    }
    setState(() {
      followers = userController.followers!.where((follower) {
        final name = follower.username.toString().toLowerCase();
        return name.contains(followerNameController.text.toLowerCase());
      }).toList();
    });
  }

  void loadingData() async {
    if (userController.followers == null) {
      followers =
          await userService.getFollowers(userController.userAbout!.username);
    } else {
      followers = userController.followers;
    }
    if (userController.following == null) {
      following =
          await userService.getFollowing(userController.userAbout!.username);
    } else {
      following = userController.following;
    }
    setState(() {
      _dataFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_dataFetched) {
      loadingData();
    }
    return _dataFetched ? _buildFollowersList() : _buildLoading();
  }
}
