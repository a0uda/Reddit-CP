import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/widgets/collapse_post.dart';

import 'package:reddit/widgets/post.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/widgets/repost.dart';
import '../Controllers/user_controller.dart';

import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Models/user_about.dart';

final userController = GetIt.instance.get<UserController>();
typedef OnClearDelete = void Function(String postid);
typedef OnClearEdit = void Function(String postid, String text);
typedef OnLock = void Function(String postid, bool lock);

class ListingCertainUser extends StatefulWidget {
  final UserAbout? userData;
  const ListingCertainUser({super.key, this.userData});
  @override
  State<ListingCertainUser> createState() => ListingCertainUserScreen();
}

class ListingCertainUserScreen extends State<ListingCertainUser> {
  List<PostItem> posts = [];
  int page = 1;
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

  void handledeleteChanged(String postid) {
    setState(() {
      for (var post in posts) {
        if (post.id == postid) {
          post.isRemoved = true;
        }
      }
    });
  }

  // late Future<void> _dataFuture;
  ScrollController controller = ScrollController();
  // List of items in our dropdown menu
  bool isloading = false;
  Future<void> fetchdata() async {
    if (isloading) return;
    setState(() {
      isloading = true;
    });
    final postService = GetIt.instance.get<PostService>();
    List<PostItem> post = [];

    final String username = widget.userData!.username;
    post = await postService.getMyPosts(username, page);
    page++;
    print(username);
    // Remove objects from list1 if their IDs match any in list2
    post.removeWhere((item1) => posts.any((item2) => item1.id == item2.id));
    post.removeWhere((item1) => item1.isRemoved == true);
    print("tracinggggg");
    print(post);
    setState(() {
      posts.addAll(post);
      isloading = false;
    });
  }

  void HandleScrolling() {
    if (controller.position.maxScrollExtent == controller.position.pixels) {
      // Load more data here (e.g., fetch additional items from an API)
      // Add the new items to your existing list
      // Example: myList.addAll(newItems);
      fetchdata();
      print('LOAD MORE');
      // load more data here

      //setState(() {});
    }
  }

  @override
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
                onclearDelete: handledeleteChanged,
                onclearEdit: handleEditChanged,
                onLock: handleLockChange,
                deleted: posts[index].isRemoved,
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
                isSaved: posts[index].isSaved ?? false,
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
              onclearDelete: handledeleteChanged,
              onclearEdit: handleEditChanged,
              onLock: handleLockChange,
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
              isSaved: posts[index].isSaved ?? false,
              
            );
          } else {
            return Container();
          }
        }
      },
    );
  }
}
