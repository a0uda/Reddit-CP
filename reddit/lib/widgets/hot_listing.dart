import 'package:flutter/material.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/test_files/test_posts.dart';
import 'package:reddit/widgets/blur_content.dart';
import 'package:reddit/widgets/post.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:get_it/get_it.dart';

class HotListing extends StatefulWidget {
  const HotListing({super.key});
  @override
  State<HotListing> createState() => HotListingBuild();
}

class HotListingBuild extends State<HotListing> {
  ScrollController controller = ScrollController();
  // List of items in our dropdown menu
  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(handleScrolling);
  }

  void handleScrolling() {
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
    final PostController postController = PostController();

    postController.getPost();
    List<PostItem> posts = postController.postItems!;
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
