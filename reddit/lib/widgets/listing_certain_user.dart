import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/widgets/collapse_post.dart';

import 'package:reddit/widgets/post.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/widgets/repost.dart';
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
  int page=1;
  late Future<void> _dataFuture;
  ScrollController controller = ScrollController();
  // List of items in our dropdown menu
    bool isloading=false;
  Future<List<PostItem>> fetchdata() async {
        isloading=true;
    final postService = GetIt.instance.get<PostService>();
    List<PostItem> post = [];
   
      final String username = widget.userData!.username;
      post = await postService.getMyPosts(username);
      print(username);
      // Remove objects from list1 if their IDs match any in list2
    
  isloading=false;
    setState(() {
      posts.addAll(post);
    });
    return post;
  }

  void HandleScrolling() {
    if (controller.position.maxScrollExtent*0.9  < controller.offset) {
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
    return Consumer<Edit>(
        builder: (context,edit, child) {
          print('trigerred provider');
        if (edit.shouldRefresh) {
          posts=[];
          fetchdata();
          edit.resetRefresh(); // Reset the edit flag after fetching data
        }
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
          if (isloading)
          {
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
          }
          else{
      
              return ListView.builder(
                itemCount: posts.length,
                controller: controller,
                itemBuilder: (context, index) {
                      var imageurl=null;
                  if (posts[index].images != null ) {
                    imageurl=  posts[index].images?[0].link;
                  }
                    print(posts[index].isReposted);
                  if (posts[index].isReposted) {
                    return Repost(
                          description: posts[index].description,
                        id: posts[index].id,
                        name: posts[index].username,
                        title: posts[index].title,
                        originalID: posts[index].originalPostID,
                        date: posts[index].createdAt.toString(),
                        likes: posts[index].upvotesCount -
                            posts[index].downvotesCount,
                        commentsCount: posts[index].commentsCount,
                        communityName: posts[index].communityName,
                        isLocked: posts[index].lockedFlag,
                        vote: posts[index].vote);
                  }
                  if ((posts[index].nsfwFlag == true ||
                      posts[index].spoilerFlag == true)) {
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
                  // if( !posts[index].isRemoved)
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
                    imageUrl: imageurl,
                    videoUrl: posts[index].videos?[0].link,
                    poll: posts[index].poll,
                    id: posts[index].id,
                    communityName: posts[index].communityName,
                    isLocked: posts[index].lockedFlag,
                  );
                },
              );
     
          }
        }
      },
    );
    }

    );
  }
}