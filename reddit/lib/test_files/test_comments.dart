import 'package:reddit/Models/comments.dart';

final List<Comments> comments = [
  Comments(
    id: '1',
    postId: 'post1',
    userId: 'user1',
    username: 'username1',
    parentId: 'parent1',
    subredditId: 'subreddit1',
    subredditName: 'subredditName1',
    repliesCommentsIds: ['reply1', 'reply2'],
    createdAt: '2022-01-01',
    editedAt: '2022-01-02',
    deletedAt: '2022-01-03',
    description: 'This is a comment',
    upvotesCount: 10,
    downvotesCount: 2,
    allowrepliesFlag: true,
    spamFlag: false,
    lockedFlag: false,
    showCommentFlag: true,
    moderatorDetails: ModeratorDetails(
      approvedBy: 'approvedBy1',
      approvedDate: '2022-01-04',
      removedBy: 'removedBy1',
      removedDate: '2022-01-05',
      spammedBy: 'spammedBy1',
      spammedType: 'spammedType1',
    ),
  ),
];
