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

  @override
  Widget build(BuildContext context) {
    var followerfollowingcontroller =
        context.read<FollowerFollowingController>();
    return Consumer<BlockUnblockUser>(
      builder: (context, BlockUnblockUser, child) {
        return FutureBuilder<List<List<FollowersFollowingItem>>>(
          future: Future.wait([
            followerfollowingcontroller
                .getFollowers(userController.userAbout!.username),
            followerfollowingcontroller
                .getFollowing(userController.userAbout!.username),
          ]),
          builder: (BuildContext context,
              AsyncSnapshot<List<List<FollowersFollowingItem>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 102, 102, 102),
                  ),
                ),
              ); // Display a loading spinner while waiting
            } else if (snapshot.hasError) {
              return Text(
                  'Error: ${snapshot.error}'); // Display error message if any
            } else {
              List<FollowersFollowingItem>? followers = snapshot.data![0];
              List<FollowersFollowingItem>? following = snapshot.data![1];
              return Consumer<FollowerFollowingController>(
                  builder: (context, followerFollowingController, child) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Followers'),
                    backgroundColor: Colors.white,
                  ),
                  body: ListView.builder(
                    itemCount: followers?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          leading: CircleAvatar(
                              backgroundImage: AssetImage(
                            (followers?[index].profilePicture != null
                                ? followers![index].profilePicture!
                                : 'images/Greddit.png'),
                          )),
                          title: Text((followers![index].displayName ??
                              followers![index].username)),
                          subtitle: Text('u/${followers![index].username}'),
                          trailing: TextButton(
                            onPressed: () async {
                              if (following!
                                  .where((element) =>
                                      element.username ==
                                      followers![index].username)
                                  .isNotEmpty) {
                                await followerFollowingController
                                    .unfollowUser(followers![index].username);
                              } else {
                                await followerFollowingController
                                    .followUser(followers![index].username);
                              }
                              following = followerFollowingController.following;
                              followers = followerFollowingController.followers;
                            },
                            child: Text(
                              (following!
                                      .where((element) =>
                                          element.username ==
                                          followers![index].username)
                                      .isNotEmpty)
                                  ? 'Following'
                                  : 'Follow',
                              style: TextStyle(
                                color: (following!
                                        .where((element) =>
                                            element.username ==
                                            followers![index].username)
                                        .isNotEmpty)
                                    ? const Color.fromARGB(255, 110, 110, 110)
                                    : Colors.blue,
                              ),
                            ),
                          ),
                          onTap: () async {
                            var username =
                                followers![index].username.toString();
                            UserAbout otherUserData =
                                (await (userService.getUserAbout(username)))!;
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
                );
              });
            }
          },
        );
      },
    );
  }
}
