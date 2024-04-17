import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/widgets/collapse_post.dart';

import 'package:reddit/widgets/post.dart';
import 'package:get_it/get_it.dart';
import '../Controllers/user_controller.dart';

import 'package:reddit/Services/post_service.dart';

final userController = GetIt.instance.get<UserController>();

class RisingListing extends StatefulWidget {
  final String type;
  const RisingListing({super.key, required this.type});
  @override
  State<RisingListing> createState() => RisingListingBuild();
}

class RisingListingBuild extends State<RisingListing> {
  ScrollController controller = ScrollController();
  List<PostItem> posts = [];

  // List of items in our dropdown menu
  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(HandleScrolling);
// fetchdata();
  }

  Future<void> fetchdata() async {
    String username = userController.userAbout!.username;
    final postService = GetIt.instance.get<PostService>();
    if (widget.type == "home") {
      posts = await postService.getPosts(username, "random");
    } else if (widget.type == "popular") {
      posts = await postService.getPopularPosts();
    } else if (widget.type == "profile") {
      posts = await postService.getMyPosts(username);
      print(username);
    }
  }

  void HandleScrolling() {
    if (controller.position.maxScrollExtent == controller.offset) {
      // Load more data here (e.g., fetch additional items from an API)
      // Add the new items to your existing list
      // Example: myList.addAll(newItems);
      print('LOAD MORE');
      // load more data here

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchdata(),
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
              return ListView.builder(
                itemCount: posts.length,
                controller: controller,
                itemBuilder: (context, index) {
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
