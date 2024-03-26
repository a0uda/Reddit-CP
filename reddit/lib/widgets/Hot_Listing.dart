import 'package:flutter/material.dart';
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
  final postService = GetIt.instance.get<PostService>();
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
    return ListView.builder(
      itemCount: posts.length,
      controller: controller,
      itemBuilder: (context, index) {
        if (posts[index].nsfwFlag == true) {
          // TODO : NSFW , Spoiler
          return buildBlur(
              context: context,
              child: Post(
                profileImageUrl: posts[index].profilePic!,
                name: posts[index].username,
                title: posts[index].title,
                postContent: posts[index].description!,
                date: posts[index].date.toString(),
                likes: posts[index].likes,
                comments: posts[index].comments.toString(),
                linkUrl: posts[index].linkUrl,
                imageUrl: posts[index].images?[0].path,
                videoUrl: posts[index].videos?[0].path,
                poll: posts[index].poll,
                id: posts[index].id,
                communityName: posts[index].communityName,
              ));
        }
        return Post(
          profileImageUrl: posts[index].profilePic!,
          name: posts[index].username,
          title: posts[index].title,
          postContent: posts[index].description!,
          date: posts[index].date.toString(),
          likes: posts[index].likes,
          comments: posts[index].comments.toString(),
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
