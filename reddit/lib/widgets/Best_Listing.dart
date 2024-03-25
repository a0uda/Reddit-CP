import 'package:flutter/material.dart';
import 'package:reddit/widgets/post.dart';

class PostItems {
  final String name;
  final String profileImage;
  final String postContent;
  final String likes;
  final String comments;

  PostItems(this.name, this.profileImage, this.postContent, this.likes,
      this.comments);
}

final List<PostItems> posts = [
  PostItems(
      'Jennifer Lopez',
      'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
      'kasdmaklsd askdmlaksd skmlamdlkasd asdmklasm sdkamldklasm askdmlalksmd askldmklamsdlka askldmklasmdlk aksdmlkamsdlk klasmdklasmdkla skmdslamsdlkam asklmdklamsda jkasndklamskldamr',
      '2',
      '3'),
];

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
        //       const Post({
        //   super.key,
        //   required this.profileImageUrl,
        //   required this.name,
        //   required this.title,
        //   required this.postContent,
        //   required this.postView,
        //   required this.date,
        //   required this.likes,
        //   required this.comments,
        //   this.imageUrl,
        //   this.linkUrl,
        //   this.videoUrl,
        // });
        return Post(
          profileImageUrl: posts[index].profileImage,
          name: posts[index].name,
          title: posts[index].postContent,
          postContent: posts[index].postContent,
          date: "2021-09-09",
          likes: posts[index].likes,
          comments: posts[index].comments,
          communityName: "r/FlutterDev",
        );
      },
    );
  }
}
