import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/comments.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/widgets/comment.dart';
import 'package:reddit/widgets/post.dart';
import 'package:reddit/widgets/repost.dart';

class CommentsWidget extends StatefulWidget {
  final String postId;
  final bool isModInComment;
  final communityName;

  const CommentsWidget(
      {Key? key,
      required this.postId,
      this.isModInComment = false,
      this.communityName = ""})
      : super(key: key);

  @override
  State<CommentsWidget> createState() => CommentsWidgetState();
}

class CommentsWidgetState extends State<CommentsWidget> {
  PostService postService = GetIt.instance.get<PostService>();
  List<Comments>? comments;
  PostItem? post;
  final TextEditingController commentController = TextEditingController();

  bool upVote = false;
  bool downVote = false;

  Color? upVoteColor;
  Color? downVoteColor;

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  final CommentsService commentService = GetIt.instance.get<CommentsService>();

  Future<void> loadComments() async {
    comments = await CommentsService().getCommentByPostId(widget.postId);
    post = await postService.getPostById(widget.postId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = GetIt.instance.get<UserController>();
    final ModeratorController moderatorController =
        GetIt.instance.get<ModeratorController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: post == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: post!.isReposted
                        ? Repost(
                            description: post!.description,
                            id: post!.id,
                            name: post!.username,
                            title: post!.title,
                            originalID: post!.originalPostID,
                            date: post!.createdAt.toString(),
                            likes: post!.upvotesCount - post!.downvotesCount,
                            commentsCount: post!.commentsCount,
                            communityName: post!.communityName,
                            isLocked: post!.lockedFlag,
                            isSaved: post!.isSaved!,
                            vote: post!.vote,
                            deleted: post!.isRemoved ?? false,
                            isPostMod: (widget.isModInComment &&
                                (moderatorController.modAccess.everything ||
                                    moderatorController
                                        .modAccess.managePostsAndComments)),
                            moderatorDetails: post!.moderatorDetails,
                          )
                        : Post(
                            vote: post!.vote,
                            name: post!.username,
                            title: post!.title,
                            postContent: post!.description ?? '',
                            date: post!.createdAt.toString(),
                            likes: post!.upvotesCount - post!.downvotesCount,
                            commentsCount: post!.commentsCount,
                            linkUrl: post!.linkUrl,
                            imageUrl: post!.images?[0].link,
                            videoUrl: post!.videos?[0].link,
                            poll: post!.poll,
                            id: post!.id,
                            communityName: post!.communityName,
                            isLocked: post!.lockedFlag,
                            isSaved: post!.isSaved!,
                            deleted: post!.isRemoved ?? false,
                            isPostMod: (widget.isModInComment &&
                                (moderatorController.modAccess.everything ||
                                    moderatorController
                                        .modAccess.managePostsAndComments)),
                            moderatorDetails: post!.moderatorDetails,
                            pollExpired: post!.pollExpired!,
                            pollVote: post!.pollVote!,
                          ),
                  ),
                  if (comments != null && comments!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments?.length,
                      itemBuilder: (context, index) {
                        final comment = comments![index];
                        return Comment(
                          comment: comment,
                          isSaved: comment.saved ?? false,
                          likes: comment.upvotesCount - comment.downvotesCount,
                          isModInComment: widget.isModInComment,
                        );
                      },
                    ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 70),
                  ),
                ],
              ),
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
                  onSubmitted: (String value) async {
                    int status = await commentService.addComment(
                        widget.postId,
                        value,
                        userController.userAbout!.username,
                        userController.userAbout?.id ?? '');
                    if (status == 200) {
                      loadComments();
                      commentController.clear();
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  int status = await commentService.addComment(
                      widget.postId,
                      commentController.text,
                      userController.userAbout!.username,
                      userController.userAbout?.id ?? '');
                  print(status);
                  if (status == 200) {
                    loadComments();
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
