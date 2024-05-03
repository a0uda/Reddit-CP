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
  bool? spoilerFlag;
  bool? commentInCommunityFlag;
  bool? saved;

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
    this.spoilerFlag,
    this.commentInCommunityFlag,
    this.saved,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['_id'],
      postId: json['post_id'],
      saved: json['saved'],
      userId: json['user_id'],
      username: json['username'],
      parentId: json['parent_id'],
      repliesCommentsIds: (json['replies_comments_ids'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
      createdAt: json['created_at'].substring(0, 10),
      editedAt: json['edited_at'],
      deletedAt: json['deleted_at'],
      description: json['description'],
      upvotesCount: json['upvotes_count'],
      downvotesCount: json['downvotes_count'],
      allowrepliesFlag: json['allowreplies_flag'],
      spamFlag: json['spam_flag'],
      lockedFlag: json['locked_flag'],
      showCommentFlag: json['show_comment_flag'],
      spoilerFlag: json['spoiler_flag'],
      commentInCommunityFlag: json['comment_in_community_flag'],
      subredditName: json['community_name'],
      moderatorDetails: json['moderator_details'] != null
          ? ModeratorDetails(
              approvedBy: json['moderator_details']['approved_by'],
              approvedDate: json['moderator_details']['approved_date'],
              removedBy: json['moderator_details']['removed_by'],
              removedDate: json['moderator_details']['removed_date'],
              spammedBy: json['moderator_details']['spammed_by'],
              spammedType: json['moderator_details']['spammed_type'],
              removedFlag: json['moderator_details']['removed_flag'],
              spammedFlag: json['moderator_details']['spammed_flag'],
            )
          : null,
    );
  }
}

class ModeratorDetails {
  String? approvedBy;
  String? approvedDate;
  String? removedBy;
  String? removedDate;
  String? spammedBy;
  String? spammedType;
  bool? removedFlag;
  bool? spammedFlag;
  bool? approvedFlag;

  ModeratorDetails({
    this.approvedBy,
    this.approvedDate,
    this.removedBy,
    this.removedDate,
    this.spammedBy,
    this.spammedType,
    this.removedFlag,
    this.spammedFlag,
    this.approvedFlag,
  });
}
