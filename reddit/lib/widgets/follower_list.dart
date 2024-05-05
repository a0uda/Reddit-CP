import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import '../Pages/profile_screen.dart';
import 'package:get_it/get_it.dart';
import '../Services/user_service.dart';
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
  bool _firstTime = true;

  void initState() {
    super.initState();
    final blockUnblockUser =
        Provider.of<BlockUnblockUser>(context, listen: false);
    blockUnblockUser.addListener(() {
      setState(() {
        _dataFetched = false;
      });
    });
  }

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
                  : CircleAvatar(
                      backgroundImage:
                          NetworkImage(followers![index].profilePicture!),
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
                        await followerFollowingController
                            .unfollowUser(followers![index].username);
                      } else {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder<UserAbout?>(
                      future: userService.getUserAbout(username),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            color: Colors.white,
                            child: const SizedBox(
                                height: 30,
                                width: 30,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                )),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return ProfileScreen(
                            snapshot.data,
                            'other',
                          );
                        }
                      },
                    ),
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
    if (_firstTime) {
      followers =
          await userService.getFollowers(userController.userAbout!.username);
      following =
          await userService.getFollowing(userController.userAbout!.username);
      _firstTime = false;
    } else {
      followers = userController.followers;
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
