import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/widgets/comment.dart';
import 'package:reddit/widgets/post.dart';

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
  final TextEditingController commentController = TextEditingController();

  bool upVote = false;
  bool downVote = false;

  Color? upVoteColor;
  Color? downVoteColor;

  @override
  void initState() {
    super.initState();
    commentsFuture = CommentsService().getCommentByPostId(widget.postId);
  }

  final CommentsService commentService = GetIt.instance.get<CommentsService>();

  @override
  Widget build(BuildContext context) {
    final UserController userController = GetIt.instance.get<UserController>();
    post = postService.getPostById(widget.postId);

    return Scaffold(
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
                    isLocked: post!.lockedFlag,
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
                            return Comment(comment: comment, isSaved: false);
                          },
                        ),
                      );
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 70),
                ),
              ],
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  cursorColor: Colors.grey[800],
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onSubmitted: (String value) {
                    int status = commentService.addComment(
                        widget.postId,
                        value,
                        userController.userAbout!.username,
                        userController.userAbout?.id ?? '');
                    if (status == 200) {
                      setState(() {
                        commentsFuture =
                            commentService.getCommentByPostId(widget.postId);
                      });
                      commentController.clear();
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  int status = commentService.addComment(
                      widget.postId,
                      commentController.text,
                      userController.userAbout!.username,
                      userController.userAbout?.id ?? '');
                  if (status == 200) {
                    setState(() {
                      commentsFuture =
                          commentService.getCommentByPostId(widget.postId);
                    });
                    commentController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
