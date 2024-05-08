import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/widgets/comment.dart';
import 'package:reddit/widgets/post.dart';
import 'package:reddit/widgets/blur_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => HistoryScreen();
}

List<PostItem> posts = [];

class HistoryScreen extends State<History> {
  String? username2;

  @override
  void initState() {
    super.initState();
    
  }

  Future<void> HistoryPosts() async {
    final UserController userController = GetIt.instance.get<UserController>();
    final postService = GetIt.instance.get<PostService>();
    String username = userController.userAbout!.username;
    posts = await postService.getHistoryPost(username);
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = GetIt.instance.get<UserController>();
    final postService = GetIt.instance.get<PostService>();
    String username = userController.userAbout!.username;

    return Scaffold( appBar: AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text("History"),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 244, 87, 3),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ), leading: GestureDetector(
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: Color.fromARGB(255, 244, 87, 3),
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),  ),
    ),
    backgroundColor: Colors.white,
      body:FutureBuilder<void>(
        future: HistoryPosts(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Consumer<SavePost>(
                builder: (context, socialLinksController, child) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  if (posts[index].nsfwFlag == true) {
                    // TODO : NSFW , Spoiler
                    return buildBlur(
                        context: context,
                        child: Post(
                          vote: posts[index].vote,
                          name: posts[index].username,
                          title: posts[index].title,
                          postContent: posts[index].description!,
                          date: posts[index].createdAt.toString(),
                          likes: posts[index].upvotesCount -
                              posts[index].downvotesCount,
                          commentsCount: posts[index].commentsCount,
                          linkUrl: posts[index].linkUrl,
                          imageUrl: posts[index].images?[0].path,
                          videoUrl: posts[index].videos?[0].path,
                          poll: posts[index].poll,
                          id: posts[index].id,
                          communityName: posts[index].communityName,
                          isLocked: posts[index].lockedFlag,
                          isSaved: posts[index].isSaved!,
                        ));
                  }
                  return Post(
                    vote: posts[index].vote,
                    name: posts[index].username,
                    title: posts[index].title,
                    postContent: posts[index].description!,
                    date: posts[index].createdAt.toString(),
                    likes:
                        posts[index].upvotesCount - posts[index].downvotesCount,
                    commentsCount: posts[index].commentsCount,
                    linkUrl: posts[index].linkUrl,
                    imageUrl: posts[index].images?[0].path,
                    videoUrl: posts[index].videos?[0].path,
                    poll: posts[index].poll,
                    id: posts[index].id,
                    communityName: posts[index].communityName,
                    isLocked: posts[index].lockedFlag,
                    isSaved: posts[index].isSaved!,
                  );
                },
              );
            });
          }
        }),);
  }
}
