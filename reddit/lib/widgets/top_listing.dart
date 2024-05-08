import 'package:flutter/material.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/widgets/collapse_post.dart';
import 'package:reddit/Models/user_about.dart';

import 'package:reddit/widgets/post.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/widgets/repost.dart';
import '../Controllers/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Models/user_about.dart';

final userController = GetIt.instance.get<UserController>();

class TopListing extends StatefulWidget {
  final String type;
  final UserAbout? userData;
  const TopListing({super.key, required this.type, this.userData});
  @override
  State<TopListing> createState() => TopListingBuild();
}

class TopListingBuild extends State<TopListing> {
  ScrollController controller = ScrollController();
  int page = 1;
  List<PostItem> posts = [];
  late Future<void> _dataFuture;
  bool isloading = false;
  // List of items in our dropdown menu
  Future<void> fetchdata({bool isRefresh = false}) async {
    final postService = GetIt.instance.get<PostService>();
    isloading = true;
    List<PostItem> post = [];
    if (isRefresh) {
      page = 1; // Reset the page to 1 if it's a refresh
    }
    if (widget.type == "home" || widget.type == "popular") {
      if (userController.userAbout != null) {
        String user = userController.userAbout!.username;

        post = await postService.getPosts(user, "top", page);
        if (!isRefresh) {
          page = page + 1; // Increment the page only if it's not a refresh
        }
      } else {
        post = postService.fetchPosts();
      }
    } else if (widget.type == "profile") {
      final String username = widget.userData!.username;
      post = await postService.getMyPosts(username);
    }
    // Remove objects from list1 if their IDs match any in list2
    isloading = false;
    post.removeWhere((item1) => posts.any((item2) => item1.id == item2.id));
    post.removeWhere((item1) => item1.isRemoved == true);

    setState(() {
      if (isRefresh) {
        posts.clear(); // Clear the old posts if it's a refresh
      }
      posts.addAll(post); // Add the new posts
    });
  }

  void HandleScrolling() {
    if (controller.position.maxScrollExtent * 0.9 < controller.offset) {
      // Load more data here (e.g., fetch additional items from an API)
      // Add the new items to your existing list
      // Example: myList.addAll(newItems);
      print('LOAD MORE');
      fetchdata();
      // load more data here

      // setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchdata();
    controller.addListener(HandleScrolling);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RefreshHome>(builder: (context, refresh, child) {
      if (refresh.shouldRefresh) {
        posts = [];
        fetchdata();
        refresh.resetRefresh(); // Reset the edit flag after fetching data
      }
      return FutureBuilder<void>(
        future: _dataFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: const SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (isloading) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            } else {
              return Consumer<LockPost>(builder: (context, lockPost, child) {
                return RefreshIndicator(
                  onRefresh: () async {
                    print('asjdkjasdn');
                    setState(() {
                      _dataFuture = fetchdata(isRefresh: true);
                    });
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: posts.length,
                    controller: controller,
                    itemBuilder: (context, index) {
                      var imageurl = null;
                      if (posts[index].images != null) {
                        imageurl = posts[index].images?[0].path;
                      }

                      print(posts[index].isReposted);
                      {
                        if (posts[index].isReposted) {
                          return Repost(
                              description: posts[index].description,
                              id: posts[index].id,
                              name: posts[index].username,
                              title: posts[index].title,
                              originalID: posts[index].originalPostID,
                              date: posts[index].createdAt.toString(),
                              likes: posts[index].upvotesCount -
                                  posts[index].downvotesCount,
                              commentsCount: posts[index].commentsCount,
                              communityName: posts[index].communityName,
                              isLocked: posts[index].lockedFlag,
                              vote: posts[index].vote);
                        }
                        if (posts[index].nsfwFlag == true ||
                            posts[index].spoilerFlag == true) {
                          return CollapsePost(
                            id: posts[index].id,
                            // profileImageUrl: posts[index].profilePic!,
                            name: posts[index].username,
                            title: posts[index].title,
                            date: posts[index].createdAt.toString(),
                            communityName: posts[index].communityName,
                            isLocked: posts[index].lockedFlag,
                            isNSFW: posts[index].nsfwFlag,
                            isSpoiler: posts[index].spoilerFlag,
                          );
                        }

                        return Post(
                          // profileImageUrl: posts[index].profilePic!,
                          name: posts[index].username,
                          vote: posts[index].vote,
                          title: posts[index].title,
                          postContent: posts[index].description,
                          date: posts[index].createdAt.toString(),
                          likes: posts[index].upvotesCount -
                              posts[index].downvotesCount,
                          commentsCount: posts[index].commentsCount,
                          linkUrl: posts[index].linkUrl,
                          imageUrl: imageurl,
                          videoUrl: posts[index].videos?[0].path,
                          poll: posts[index].poll,
                          id: posts[index].id,
                          communityName: posts[index].communityName,
                          isLocked: posts[index].lockedFlag,
                        );
                      }
                    },
                  ),
                );
              });
            }
          }
        },
      );
    });
  }
}
