import 'package:flutter/material.dart';

import 'package:reddit/widgets/post.dart';
import 'package:get_it/get_it.dart';
import '../Controllers/user_controller.dart';
import 'package:reddit/widgets/blur_content.dart';

import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Services/post_service.dart';

final userController = GetIt.instance.get<UserController>();

class HotListing extends StatefulWidget {
  final String type;
  const HotListing({super.key, required this.type});
  @override
  State<HotListing> createState() => HotListingBuild();
}

class HotListingBuild extends State<HotListing> {
  ScrollController controller = ScrollController();
  // List of items in our dropdown menu
  @override
List<PostItem> posts = [];

  void initState() {
    super.initState();
    controller = ScrollController()..addListener(HandleScrolling);
    fetchdata();

  }

void fetchdata(){
    String username = userController.userAbout!.username;
    print(username);
    final postService = GetIt.instance.get<PostService>();
    if (widget.type == "home") {
      posts = postService.getPosts(username);
    } else if (widget.type == "popular") {
      posts = postService.getPopularPosts();
    } else if (widget.type == "profile") {
      posts =  postService.getMyPosts(username);
      print(username);
    }

}
  void HandleScrolling() {
    if (controller.position.maxScrollExtent == controller.offset) {
      // Load more data here (e.g., fetch additional items from an API)
      // Add the new items to your existing list
      // Example: myList.addAll(newItems);
   print('load more');

      // load more data here

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
                postContent: posts[index].description!,
                date: posts[index].createdAt.toString(),
                likes: posts[index].upvotesCount - posts[index].downvotesCount,
                commentsCount: posts[index].commentsCount,
                linkUrl: posts[index].linkUrl,
                imageUrl: posts[index].images?[0].path,
                videoUrl: posts[index].videos?[0].path,
                poll: posts[index].poll,
                id: posts[index].id,
                communityName: posts[index].communityName,
              ));
        }
        return Post(
          // profileImageUrl: posts[index].profilePic!,
          name: posts[index].username,
          title: posts[index].title,
          postContent: posts[index].description!,
          date: posts[index].createdAt.toString(),
          likes: posts[index].upvotesCount - posts[index].downvotesCount,
          commentsCount: posts[index].commentsCount,
          linkUrl: posts[index].linkUrl,
          imageUrl: posts[index].images?[0].path,
          videoUrl: posts[index].videos?[0].path,
          poll: posts[index].poll,
          id: posts[index].id,
          communityName: posts[index].communityName,
        );
      },
    );
  }
}
