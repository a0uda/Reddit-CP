import 'package:reddit/Models/image_item.dart';
import 'package:reddit/Models/poll_item.dart';
import 'package:reddit/Models/video_item.dart';
import 'package:reddit/Models/comments.dart';
import 'dart:convert';

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
  final bool isReposted;
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
  final int vote;
  final String originalPostID;

  PostItem({
    required this.id,
    required this.userId,
    required this.username,
    required this.title,
    required this.isReposted,
    this.description,
    required this.createdAt,
    this.editedAt,
    required this.originalPostID,
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
    required this.vote,
    this.setSuggestedSort,
    this.moderatorDetails,
    this.userDetails,
  });

  factory PostItem.fromJson(Map<String, dynamic> json) {
    print(json);
    final List<dynamic> jsonlist = json['images']??[];
    final List<ImageItem> imagelist =  jsonlist.map((jsonitem) {
      return ImageItem.fromJson(jsonitem);
    }).toList();
    final List<dynamic> jsonlist2 = json['videos']??[];
    final List<VideoItem> videolist = jsonlist2.map((jsonitem) {
      return VideoItem.fromJson(jsonitem);
    }).toList();
    return PostItem(
      ///todo
      isReposted: json['is_reposted_flag'],
      originalPostID:
          "662bc4861980ada1a43262ac", //(json['reposted']['original_post_id']!=null)?(json['reposted']['original_post_id']):'',
      id: json['_id'],
      userId: json['user_id'],
      description: json['description'],
      username: (json['username'] != null) ? (json['username']) : 'SHIKA',
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      type: json['type'],
      communityId: json['community_id'],
      communityName:
          (json['community_name'] != null) ? (json['community_name']) : '',
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
      setSuggestedSort: json['set_suggeested_sort'],
      vote: (json['vote'] != null) ? (json['vote']) : 0,
      images: (imagelist.isNotEmpty) ? imagelist : null,
      videos: (videolist.isNotEmpty) ? videolist : null,
    );
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
