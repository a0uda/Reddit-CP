import 'package:flutter/material.dart';
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

class NewListing extends StatefulWidget {
  const NewListing({super.key});
  @override
  State<NewListing> createState() => NewListingBuild();
}

class NewListingBuild extends State<NewListing> {
  ScrollController controller = ScrollController();
  // List of items in our dropdown menu
  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(HandleScrolling);
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
    return ListView.builder(
      itemCount: posts.length,
      controller: controller,
      itemBuilder: (context, index) {
        return Post(
          id: posts[index].id,
          profileImageUrl: posts[index].profilePic,
          name: posts[index].username,
          title: posts[index].title,
          postContent: posts[index].description,
          date: "2021-09-09",
          likes: posts[index].likes,
          comments: posts[index].comments.toString(),
          communityName: posts[index].communityName,
        );
      },
    );
  }
}
