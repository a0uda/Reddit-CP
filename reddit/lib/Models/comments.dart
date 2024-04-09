class Comments {
  String? id;
  String? postId;
  String? userId;
  String? username;
  String? parentId;
  String? subredditId;
  String? subredditName;
  List<String>? repliesCommentsIds;
  String? createdAt;
  String? editedAt;
  String? deletedAt;
  String? description;
  int? upvotesCount;
  int? downvotesCount;
  bool? allowrepliesFlag;
  bool? spamFlag;
  bool? lockedFlag;
  bool? showCommentFlag;
  ModeratorDetails? moderatorDetails;

  Comments({
    this.id,
    this.postId,
    this.userId,
    this.username,
    this.parentId,
    this.subredditId,
    this.subredditName,
    this.repliesCommentsIds,
    this.createdAt,
    this.editedAt,
    this.deletedAt,
    this.description,
    this.upvotesCount,
    this.downvotesCount,
    this.allowrepliesFlag,
    this.spamFlag,
    this.lockedFlag,
    this.showCommentFlag,
    this.moderatorDetails,
  });
}

class ModeratorDetails {
  String? approvedBy;
  String? approvedDate;
  String? removedBy;
  String? removedDate;
  String? spammedBy;
  String? spammedType;

  ModeratorDetails({
    this.approvedBy,
    this.approvedDate,
    this.removedBy,
    this.removedDate,
    this.spammedBy,
    this.spammedType,
  });
}

List<Comments> comments1 = [
  Comments(
    id: '1',
    postId: '1',
    userId: '1',
    username: 'John',
    parentId: '0',
    subredditId: '1',
    subredditName: 'FPGA',
    repliesCommentsIds: ['2', '3'],
    createdAt: '2024-03-10 12:00:00',
    editedAt: '',
    deletedAt: '',
    description: 'This is comment 1',
    upvotesCount: 1,
    downvotesCount: 0,
    allowrepliesFlag: true,
    spamFlag: false,
    lockedFlag: false,
    showCommentFlag: true,
    moderatorDetails: ModeratorDetails(
      approvedBy: 'moderator1',
      approvedDate: '2021-09-01 12:00:00',
      removedBy: 'moderator1',
      removedDate: '2021-09-01 12:00:00',
      spammedBy: 'moderator1',
      spammedType: 'spam',
    ),
  ),
  Comments(
    id: '2',
    postId: '1',
    userId: '2',
    username: 'Jane',
    parentId: '1',
    subredditId: '1',
    subredditName: 'subreddit1',
    repliesCommentsIds: [],
    createdAt: '2023-06-16 12:00:00',
    editedAt: '',
    deletedAt: '',
    description: 'This is comment 2',
    upvotesCount: 0,
    downvotesCount: 4,
    allowrepliesFlag: true,
    spamFlag: false,
    lockedFlag: false,
    showCommentFlag: true,
    moderatorDetails: ModeratorDetails(
      approvedBy: 'moderator1',
      approvedDate: '2021-09-01 12:00:00',
      removedBy: 'moderator1',
      removedDate: '2021-09-01 12:00:00',
      spammedBy: 'moderator1',
      spammedType: 'spam',
    ),
  ),
  Comments(
    id: '3',
    postId: '1',
    userId: '3',
    username: 'Sue',
    parentId: '1',
    subredditId: '1',
    subredditName: 'flutter',
    repliesCommentsIds: [],
    createdAt: '2024-03-15 16:34:00',
    editedAt: '2021-09-01 12:00:00',
    deletedAt: '2021-09-01 12:00:00',
    description: 'comment3',
    upvotesCount: 1,
    downvotesCount: 0,
    allowrepliesFlag: true,
    spamFlag: false,
    lockedFlag: false,
    showCommentFlag: true,
    moderatorDetails: ModeratorDetails(
      approvedBy: 'moderator1',
      approvedDate: '2021-09-01 12:00:00',
      removedBy: 'moderator1',
      removedDate: '2021-09-01 12:00:00',
      spammedBy: 'moderator1',
      spammedType: 'spam',
    ),
  ),
];

List<Comments> comments2 = [
  Comments(
    id: '4',
    postId: '2',
    userId: '4',
    username: 'Tom',
    parentId: '0',
    subredditId: '2',
    subredditName: 'chatgp',
    repliesCommentsIds: ['5', '6'],
    createdAt: '2024-03-15 16:34:00',
    editedAt: '',
    deletedAt: '',
    description: 'This is comment 4',
    upvotesCount: 1,
    downvotesCount: 0,
    allowrepliesFlag: true,
    spamFlag: false,
    lockedFlag: false,
    showCommentFlag: true,
    moderatorDetails: ModeratorDetails(
      approvedBy: 'moderator1',
      approvedDate: '2021-09-01 12:00:00',
      removedBy: 'moderator1',
      removedDate: '2021-09-01 12:00:00',
      spammedBy: 'moderator1',
      spammedType: 'spam',
    ),
  ),
  Comments(
    id: '5',
    postId: '2',
    userId: '5',
    username: 'Sally',
    parentId: '4',
    subredditId: '2',
    subredditName: 'chatgp',
    repliesCommentsIds: [],
    createdAt: '2024-02-16 12:00:00',
    editedAt: '',
    deletedAt: '',
    description: 'This is comment 5',
    upvotesCount: 0,
    downvotesCount: 4,
    allowrepliesFlag: true,
    spamFlag: false,
    lockedFlag: false,
    showCommentFlag: true,
    moderatorDetails: ModeratorDetails(
      approvedBy: 'moderator1',
      approvedDate: '2021-09-01 12:00:00',
      removedBy: 'moderator1',
      removedDate: '2021-09-01 12:00:00',
      spammedBy: 'moderator1',
      spammedType: 'spam',
    ),
  ),
];

List<Comments> comments3 = [
  Comments(
    id: '7',
    postId: '3',
    userId: '7',
    username: 'Bill',
    parentId: '0',
    subredditId: '3',
    subredditName: 'flutter',
    repliesCommentsIds: ['8', '9'],
    createdAt: '2024-03-15 16:34:00',
    editedAt: '',
    deletedAt: '',
    description: 'This is comment 7',
    upvotesCount: 1,
    downvotesCount: 0,
    allowrepliesFlag: true,
    spamFlag: false,
    lockedFlag: false,
    showCommentFlag: true,
    moderatorDetails: ModeratorDetails(
      approvedBy: 'moderator1',
      approvedDate: '2021-09-01 12:00:00',
      removedBy: 'moderator1',
      removedDate: '2021-09-01 12:00:00',
      spammedBy: 'moderator1',
      spammedType: 'spam',
    ),
  ),
  Comments(
    id: '8',
    postId: '3',
    userId: '8',
    username: 'Jill',
    parentId: '7',
    subredditId: '3',
    subredditName: 'dart',
    repliesCommentsIds: [],
    createdAt: '2024-03-15 16:34:00',
    editedAt: '',
    deletedAt: '',
    description: 'This is comment 8',
    upvotesCount: 1,
    downvotesCount: 0,
    allowrepliesFlag: true,
    spamFlag: false,
    lockedFlag: false,
    showCommentFlag: true,
    moderatorDetails: ModeratorDetails(
      approvedBy: 'moderator1',
      approvedDate: '2021-09-01 12:00:00',
      removedBy: 'moderator1',
      removedDate: '2021-09-01 12:00:00',
      spammedBy: 'moderator1',
      spammedType: 'spam',
    ),
  ),
];
