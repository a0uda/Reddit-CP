import 'package:flutter/material.dart';
import 'package:reddit/widgets/post.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:get_it/get_it.dart';

class HotListing extends StatefulWidget {
  const HotListing({Key? key}) : super(key: key);
  @override
  State<HotListing> createState() => HotListingBuild();
}

class HotListingBuild extends State<HotListing> {
  final postService = GetIt.instance.get<PostService>();
  ScrollController controller = ScrollController();
  // List of items in our dropdown menu
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
          profileImageUrl: "",
          name: "fouda",
          postContent: posts[index].title,
          postView: "",
          date: posts[index].date.toString(),
<<<<<<< Updated upstream
          likes: "45",
          comments: "20",
=======
          likes: posts[index].likes.toString(),
          comments: posts[index].comments.toString(),
          linkUrl: posts[index].linkUrl,
          imageUrl: posts[index].images?[0].path,
          videoUrl: posts[index].videos?[0].path,
          poll: posts[index].poll,
>>>>>>> Stashed changes
        );
      },
    );
  }
}
