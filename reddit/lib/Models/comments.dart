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
  int upvotesCount;
  int downvotesCount;
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
    required this.upvotesCount,
    required this.downvotesCount,
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
