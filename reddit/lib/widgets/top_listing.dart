import 'package:flutter/material.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/widgets/post.dart';

import '../test_files/test_posts.dart';

// class PostItems {
//   final String name;
//   final String profileImage;
//   final String postContent;
//   final int likes;
//   final String comments;

//   PostItems(this.name, this.profileImage, this.postContent, this.likes,
//       this.comments);
// }

// final List<PostItems> posts = [
//   PostItems(
//       'Jennifer Lopez',
//       'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
//       'kasdmaklsd askdmlaksd skmlamdlkasd asdmklasm sdkamldklasm askdmlalksmd askldmklamsdlka askldmklasmdlk aksdmlkamsdlk klasmdklasmdkla skmdslamsdlkam asklmdklamsda jkasndklamskldamr',
//       2,
//       '3'),
// ];

class TopListing extends StatefulWidget {
  const TopListing({super.key});
  @override
  State<TopListing> createState() => TopListingBuild();
}

class TopListingBuild extends State<TopListing> {
  ScrollController controller = ScrollController();
  final PostController postController = PostController();
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
    postController.getPost();
    List<PostItem> posts = postController.postItems!;
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
