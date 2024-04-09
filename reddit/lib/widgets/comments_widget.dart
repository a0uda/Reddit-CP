import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/services/comments_service.dart';
import 'package:reddit/widgets/post.dart'; // import your CommentsService

class CommentsWidget extends StatefulWidget {
  final String postId;

  const CommentsWidget({super.key, required this.postId});

  @override
  State<CommentsWidget> createState() => CommentsWidgetState();
}

class CommentsWidgetState extends State<CommentsWidget> {
  PostService postService = GetIt.instance.get<PostService>();
  late Future<List<Comments>> commentsFuture;
  PostItem? post;

  @override
  void initState() {
    super.initState();
    commentsFuture = CommentsService().getCommentByPostId(widget.postId);
    post = postService.getPostById(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = GetIt.instance.get<UserController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: post == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Post(
                    name: post!.username,
                    title: post!.title,
                    postContent: post!.description!,
                    date: post!.createdAt.toString(),
                    likes: post!.upvotesCount - post!.downvotesCount,
                    commentsCount: post!.commentsCount,
                    linkUrl: post!.linkUrl,
                    imageUrl: post!.images?[0].path,
                    videoUrl: post!.videos?[0].path,
                    poll: post!.poll,
                    id: post!.id,
                    communityName: post!.communityName,
                  ),
                ),
                FutureBuilder<List<Comments>>(
                  future: commentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final comments = snapshot.data;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: comments?.length,
                          itemBuilder: (context, index) {
                            final comment = comments![index];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundImage: AssetImage(
                                            userController.userAbout!
                                                    .profilePicture ??
                                                'images/Greddit.png'),
                                      ),
                                      const SizedBox(
                                          width:
                                              10), // Add some space between the picture and the username
                                      Text(
                                        comment.username!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      comment.description!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Arial',
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        iconSize: 20,
                                        highlightColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        icon: const Icon(
                                            Icons.open_in_new_outlined),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        iconSize: 20,
                                        highlightColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        icon: const Icon(Icons.reply_outlined),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        iconSize: 20,
                                        //color: upVoteColor,
                                        highlightColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        icon: const Icon(
                                            Icons.arrow_upward_sharp),
                                        onPressed: () {
                                          // incrementCounter();
                                        },
                                      ),
                                      Text(
                                        comment.upvotesCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                      IconButton(
                                        iconSize: 20,
                                        // color: downVoteColor,
                                        icon: const Icon(
                                            Icons.arrow_downward_outlined),
                                        onPressed: () {
                                          // decrementCounter();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              // Your comment widget code
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
    );
  }
}
