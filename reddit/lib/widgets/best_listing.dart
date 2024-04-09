import 'package:flutter/material.dart';
import 'package:reddit/widgets/post.dart';

import '../test_files/test_posts.dart';

class BestListing extends StatefulWidget {
  const BestListing({super.key});
  @override
  State<BestListing> createState() => BestListingBuild();
}

class BestListingBuild extends State<BestListing> {
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
