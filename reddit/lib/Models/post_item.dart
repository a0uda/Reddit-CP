import 'package:reddit/Models/image_item.dart';
import 'package:reddit/Models/poll_item.dart';
import 'package:reddit/Models/video_item.dart';
import 'package:reddit/Models/comments.dart';

class PostItem {
  final String id;
  final String userId;
  final String username;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? editedAt;
  final DateTime? deletedAt;
  final String type;
  final String? linkUrl;
  final List<ImageItem>? images;
  final List<VideoItem>? videos;
  PollItem? poll;
  final String? communityId;
  final String communityName;
  int commentsCount;
  final int viewsCount;
  final int sharesCount;
  int upvotesCount;
  int downvotesCount;
  final bool ocFlag;
  final bool spoilerFlag;
  final bool nsfwFlag;
  bool lockedFlag;
  bool allowrepliesFlag;
  final String? setSuggestedSort;
  final ModeratorDetails? moderatorDetails;
  final UserDetails? userDetails;

  PostItem({
    required this.id,
    required this.userId,
    required this.username,
    required this.title,
     this.description,
    required this.createdAt,
    this.editedAt,
    this.deletedAt,
    required this.type,
    this.linkUrl,
    this.images,
    this.videos,
    this.poll,
    this.communityId,
    required this.communityName,
    required this.commentsCount,
    required this.viewsCount,
    required this.sharesCount,
    required this.upvotesCount,
    required this.downvotesCount,
    required this.ocFlag,
    required this.spoilerFlag,
    required this.nsfwFlag,
    required this.lockedFlag,
    required this.allowrepliesFlag,
     this.setSuggestedSort,
    this.moderatorDetails,
    this.userDetails,
  });

  factory PostItem.fromJson(Map<String, dynamic> json) {
    return PostItem(
      ///todo
        id: json['_id'],
        userId: json['user_id'],
        description: json['descrption'],
        username: 'ahmed',
        title: json['title'],
        createdAt: DateTime.parse( json['created_at']),
        type: json['type'],
        communityId: json['community_id'],
        communityName: json['community_name'],
        commentsCount: json['comments_count'],
        viewsCount: json['views_count'],
        sharesCount: json['shares_count'],
        upvotesCount: json['upvotes_count'],
        downvotesCount: json['downvotes_count'],
        ocFlag: json['oc_flag'],
        spoilerFlag: json['spoiler_flag'],
        nsfwFlag: json['nsfw_flag'],
        lockedFlag: json['locked_flag'],
        allowrepliesFlag: json['allowreplies_flag'],
        setSuggestedSort: json['set_suggeested_sort']);
  }
}

class UserDetails {
  final int totalViews;
  final int upvoteRate;
  final int totalShares;

  UserDetails({
    required this.totalViews,
    required this.upvoteRate,
    required this.totalShares,
  });
}
