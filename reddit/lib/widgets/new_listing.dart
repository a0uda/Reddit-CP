import 'package:flutter/material.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/widgets/collapse_post.dart';
import 'package:reddit/widgets/post.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/widgets/repost.dart';
import '../Controllers/user_controller.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Services/post_service.dart';

final userController = GetIt.instance.get<UserController>();

class NewListing extends StatefulWidget {
  final String type;
  final UserAbout? userData;
  final String commmunityName;
  const NewListing(
      {super.key, required this.type, this.userData, this.commmunityName = ""});
  @override
  State<NewListing> createState() => NewListingBuild();
}

class NewListingBuild extends State<NewListing> {
  ScrollController controller = ScrollController();
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  int page = 1;
  // List of items in our dropdown menu
  bool isloading = false;
  List<PostItem> posts = [];
  late Future<void> _dataFuture;
  Future<void> fetchdata() async {
    final postService = GetIt.instance.get<PostService>();
    if (isloading) return;
    setState(() {
      isloading = true;
    });

    List<PostItem> post = [];
    if (widget.type == "home" || widget.type == "popular") {
      if (userController.userAbout != null) {
        String user = userController.userAbout!.username;

        post = await postService.getPosts(user, "new", page);
        page = page + 1;
      } else {
          post = await postService.getGuestPosts("best", page);
        page = page + 1;
      }
    } else if (widget.type == "profile") {
      final String username = widget.userData!.username;
      posts = await postService.getMyPosts(username, page);
      //print(username);
    } else if (widget.type == "comm") {
      post = await postService.getCommunityPosts(
          widget.commmunityName, "new", page);
      page++;
      // posts = await postService.getMyPosts(username,page);
      //print(username);
    }
    // Remove objects from list1 if their IDs match any in list2
    post.removeWhere((item1) => posts.any((item2) => item1.id == item2.id));
    post.removeWhere((item1) => item1.isRemoved == true);
    setState(() {
      posts.addAll(post);
      isloading = false;
    });
  }

  @override
  void HandleScrolling() {
    if (controller.position.maxScrollExtent == controller.position.pixels &&
        !isloading) {
      // Load more data here (e.g., fetch additional items from an API)
      // Add the new items to your existing list
      // Example: myList.addAll(newItems);
      print('load more');
      fetchdata();
      // load more data here

      // setState(() {});
    }
  }

  void handleEditChanged(String postid, String text) {
    for (var post in posts) {
      if (post.id == postid) {
        post.description = text;
      }
    }
  }

  void handleLockChange(String postid, bool lock) {
    for (var post in posts) {
      if (post.id == postid) {
        post.lockedFlag = lock;
      }
    }
  }

  void handleDeleteListingChanged(String postid) {
    setState(() {
      List<PostItem> postsToRemove = [];

      for (var post in posts) {
        if (post.id == postid) {
          postsToRemove.add(post);
          post.isRemoved = true;
        }
      }

      posts.removeWhere((post) => postsToRemove.contains(post));
    });
  }

  void initState() {
    super.initState();
    fetchdata();
    controller.addListener(HandleScrolling);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length + (isloading ? 1 : 0),
      controller: controller,
      itemBuilder: (context, index) {
        if (index >= posts.length) {
          // Last item - Show rotating icon
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          var imageurl = null;
          if (posts[index].images != null) {
            imageurl = posts[index].images?[0].path;
          }

          print(posts[index].isReposted);
          if (posts[index].isRemoved == false) {
            if (posts[index].isReposted) {
              return Repost(
                description: posts[index].description,
                id: posts[index].id,
                name: posts[index].username,
                title: posts[index].title,
                originalID: posts[index].originalPostID,
                date: posts[index].createdAt.toString(),
                likes: posts[index].upvotesCount - posts[index].downvotesCount,
                commentsCount: posts[index].commentsCount,
                communityName: posts[index].communityName,
                isLocked: posts[index].lockedFlag,
                vote: posts[index].vote,
                isSaved: posts[index].isSaved!,
                deleted: posts[index].isRemoved,
                isPostMod: (widget.commmunityName != "" &&
                    (moderatorController.modAccess.everything ||
                        moderatorController.modAccess.managePostsAndComments)),
                moderatorDetails: posts[index].moderatorDetails,
                onLock: handleLockChange,
                onclearDelete: handleDeleteListingChanged,
                onclearEdit: handleEditChanged,
              );
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

              deleted: posts[index].isRemoved,
              title: posts[index].title,
              postContent: posts[index].description,
              date: posts[index].createdAt.toString(),
              likes: posts[index].upvotesCount - posts[index].downvotesCount,
              commentsCount: posts[index].commentsCount,
              linkUrl: posts[index].linkUrl,
              imageUrl: imageurl,
              videoUrl: posts[index].videos?[0].path,
              poll: posts[index].poll,
              id: posts[index].id,
              communityName: posts[index].communityName,
              isLocked: posts[index].lockedFlag,
              isSaved: posts[index].isSaved!,
              isPostMod: (widget.commmunityName != "" &&
                  (moderatorController.modAccess.everything ||
                      moderatorController.modAccess.managePostsAndComments)),
              moderatorDetails: posts[index].moderatorDetails,
              pollExpired: posts[index].pollExpired!,
              pollVote: posts[index].pollVote!,
              onLock: handleLockChange,
              onclearDelete: handleDeleteListingChanged,
              onclearEdit: handleEditChanged,
            );
          }
        }
      },
    );
  }
}
