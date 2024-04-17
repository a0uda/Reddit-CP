import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/post_item.dart';

import 'package:reddit/widgets/post.dart';
import 'package:get_it/get_it.dart';
import '../Controllers/user_controller.dart';
import 'package:reddit/widgets/blur_content.dart';

import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Models/user_about.dart';

final userController = GetIt.instance.get<UserController>();

class NewListing extends StatefulWidget {
  final String type;
  final UserAbout? userData;
  const NewListing({super.key, required this.type, this.userData});
  @override
  State<NewListing> createState() => NewListingBuild();
}

class NewListingBuild extends State<NewListing> {
  List<PostItem> posts = [];
 late Future<void> _dataFuture;
  ScrollController controller = ScrollController();
  // List of items in our dropdown menu
  Future<void> fetchdata() async {
    final postService = GetIt.instance.get<PostService>();
    List<PostItem> post = [];
    if (widget.type == "home") {
      if (userController.userAbout != null) {
        String user = userController.userAbout!.username;

        post = await postService.getPosts(user, "hot");
      } else {
        posts = postService.fetchPosts();
      }
    } else if (widget.type == "popular") {
      posts = await postService.getPopularPosts();
    } else if (widget.type == "profile") {
      final String username = widget.userData!.username;
      posts = await postService.getMyPosts(username);
      print(username);
    }
  // Remove objects from list1 if their IDs match any in list2
  post.removeWhere((item1) => posts.any((item2) => item1.id == item2.id));
   
   
    setState(() {
      posts.addAll(post);
    });
   
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchdata(); // Replace with your actual data fetching logic
  }
  void HandleScrolling() {
    if (controller.position.maxScrollExtent == controller.offset) {
      // Load more data here (e.g., fetch additional items from an API)
      // Add the new items to your existing list
      // Example: myList.addAll(newItems);
      print('LOAD MORE');
      // load more data here

      //setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
          return Consumer<LockPost>(
            builder: (context, lockPost, child) {
              fetchdata();
              return ListView.builder(
                itemCount: posts.length,
                controller: controller,
                itemBuilder: (context, index) {
                  if (posts[index].nsfwFlag == true) {
                    // TODO : NSFW , Spoiler
                    return buildBlur(
                        context: context,
                        child: Post(
                          // profileImageUrl: posts[index].profilePic!,
                          name: posts[index].username,
                          title: posts[index].title,
                          postContent: posts[index].description,
                          date: posts[index].createdAt.toString(),
                          likes: posts[index].upvotesCount -
                              posts[index].downvotesCount,
                          commentsCount: posts[index].commentsCount,
                          linkUrl: posts[index].linkUrl,
                          imageUrl: posts[index].images?[0].path,
                          videoUrl: posts[index].videos?[0].path,
                          poll: posts[index].poll,
                          id: posts[index].id,
                          communityName: posts[index].communityName,
                          isLocked: posts[index].lockedFlag,
                        ));
                  }
                  return Post(
                    // profileImageUrl: posts[index].profilePic!,
                    name: posts[index].username,
                    title: posts[index].title,
                    postContent: posts[index].description,
                    date: posts[index].createdAt.toString(),
                    likes:
                        posts[index].upvotesCount - posts[index].downvotesCount,
                    commentsCount: posts[index].commentsCount,
                    linkUrl: posts[index].linkUrl,
                    imageUrl: posts[index].images?[0].path,
                    videoUrl: posts[index].videos?[0].path,
                    poll: posts[index].poll,
                    id: posts[index].id,
                    communityName: posts[index].communityName,
                    isLocked: posts[index].lockedFlag,
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
