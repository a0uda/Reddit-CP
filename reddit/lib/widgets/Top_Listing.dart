import 'package:flutter/material.dart';
import 'package:reddit/widgets/post.dart';

class PostItems {
  final String name;
  final String profileImage;
  final String postContent;
  final int likes;
  final String comments;

  PostItems(this.name, this.profileImage, this.postContent, this.likes,
      this.comments);
}

final List<PostItems> posts = [
  PostItems(
      'Jennifer Lopez',
      'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
      'kasdmaklsd askdmlaksd skmlamdlkasd asdmklasm sdkamldklasm askdmlalksmd askldmklamsdlka askldmklasmdlk aksdmlkamsdlk klasmdklasmdkla skmdslamsdlkam asklmdklamsda jkasndklamskldamr',
      2,
      '3'),
];

class TopListing extends StatefulWidget {
  const TopListing({super.key});
  @override
  State<TopListing> createState() => TopListingBuild();
}

class TopListingBuild extends State<TopListing> {
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
          profileImageUrl: posts[index].profileImage,
          name: posts[index].name,
          title: posts[index].postContent,
          postContent: posts[index].postContent,
          date: posts[index].name,
          likes: posts[index].likes,
          comments: posts[index].comments,
          communityName: "r/FlutterDev",
        );
      },
    );
  }
}
