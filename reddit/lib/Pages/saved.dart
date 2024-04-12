import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/widgets/post.dart';

import 'package:reddit/widgets/blur_content.dart';


class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => SavedScreen();
}

List<PostItem> posts = [];

class SavedScreen extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = GetIt.instance.get<UserController>();
    final postService = GetIt.instance.get<PostService>();
    String username = userController.userAbout!.username;
    posts = postService.getSavePost(username);
print(posts);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Saved'),
      ),
      body:Consumer<SavePost>(
      builder: (context, socialLinksController, child) {
        return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        if (posts[index].nsfwFlag == true) {
          // TODO : NSFW , Spoiler
          return buildBlur(
              context: context,
              child: Post(
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
    );}),
    );
  }
}
