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

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => SavedScreen();
}

List<PostItem> posts = [];

class SavedScreen extends State<Saved> {
  String? username2;

  @override
  void initState() {
    super.initState();
    initUser();
  }
 Future<void> SavedPosts() async {
 

   final UserController userController = GetIt.instance.get<UserController>();
    final postService = GetIt.instance.get<PostService>();
    String username = userController.userAbout!.username;
    posts =await postService.getSavePost(username);
  }
  Future<void> initUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

   final UserController userController = GetIt.instance.get<UserController>();
    final postService = GetIt.instance.get<PostService>();
    String username = userController.userAbout!.username;
    username2 = prefs.getString('username');
    posts =await postService.getSavePost(username);
  }

  @override
  Widget build(BuildContext context) {
 final UserController userController = GetIt.instance.get<UserController>();
    final postService = GetIt.instance.get<PostService>();
    String username = userController.userAbout!.username;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Saved'),
          bottom: TabBar(
            indicatorColor: Colors.deepOrange[400],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'Posts'),
              Tab(text: 'Comments'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
             FutureBuilder<void>(
future:SavedPosts() ,
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
                            isLocked:posts[index].lockedFlag,
                          
                          ));
                    }
                    return Post(
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
                      isLocked:posts[index].lockedFlag,
                    );
                  },
             );});}}),
              
  
            Consumer<SaveComment>(
              builder: (context, socialLinksController, child) {
                List<Comments>? comments =
                    userController.getSavedComments(username2!);
                return ListView.builder(
                  itemCount: comments?.length,
                  itemBuilder: (context, index) {
                    return Comment(
                      comment: comments![index],
                      isSaved: true,
                      isComingFromSaved: true,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
