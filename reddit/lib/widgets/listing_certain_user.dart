import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/widgets/collapse_post.dart';

import 'package:reddit/widgets/post.dart';
import 'package:get_it/get_it.dart';
import '../Controllers/user_controller.dart';

import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Models/user_about.dart';

final userController = GetIt.instance.get<UserController>();

class ListingCertainUser extends StatefulWidget {
  final UserAbout? userData;
  const ListingCertainUser({super.key, this.userData});
  @override
  State<ListingCertainUser> createState() =>ListingCertainUserScreen();
}

class ListingCertainUserScreen extends State<ListingCertainUser> {
  List<PostItem> posts = [];
  int page=0;
  late Future<void> _dataFuture;
  ScrollController controller = ScrollController();
  // List of items in our dropdown menu
  Future<void> fetchdata() async {
    final postService = GetIt.instance.get<PostService>();
    List<PostItem> post = [];
    
      final String username = widget.userData!.username;
      post = await postService.getMyPosts(username);
      print(username);
      // Remove objects from list1 if their IDs match any in list2
    

    setState(() {
      posts.addAll(post);
    });
  }

  void HandleScrolling() {
    if (controller.position.maxScrollExtent == controller.offset) {
      // Load more data here (e.g., fetch additional items from an API)
      // Add the new items to your existing list
      // Example: myList.addAll(newItems);
      
      print('LOAD MORE');
      // load more data here

      //setState(() {});
    }
  }
  @override
 void initState() {
    super.initState();
    _dataFuture = fetchdata(); 
    controller.addListener(HandleScrolling);
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _dataFuture,
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
          return Consumer<LockPost>(
            builder: (context, lockPost, child) {
            
              return ListView.builder(
                itemCount: posts.length,
                controller: controller,
                itemBuilder: (context, index) {
                  if (posts[index].nsfwFlag == true ||
                      posts[index].spoilerFlag == true) {
                    return CollapsePost(
                      id: posts[index].id,
                      // profileImageUrl: posts[index].profilePic!,
                      name: posts[index].username,
                      title: posts[index].title,
                      date: posts[index].createdAt.toString(),
                      communityName: posts[index].communityName,
                      isLocked: posts[index].lockedFlag,
                      isNSFW: posts[index].nsfwFlag,
                      isSpoiler: posts[index].spoilerFlag,
                    );
                  }
                  return Post(
                    // profileImageUrl: posts[index].profilePic!,
                    name: posts[index].username,
                    vote: posts[index].vote,

                    title: posts[index].title,
                    postContent: posts[index].description,
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
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}