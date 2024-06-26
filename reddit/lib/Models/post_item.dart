import 'package:reddit/Models/image_item.dart';
import 'package:reddit/Models/poll_item.dart';
import 'package:reddit/Models/video_item.dart';
import 'package:reddit/Models/comments.dart';

class PostItem {
  final String id;
  final String userId;
  final String username;
  final String title;
  String? description;
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
  bool? inCommunityFlag;
  Map<String, dynamic>? scheduleDetails;
  String? profilePicture;
  final String? setSuggestedSort;
  final ModeratorDetails? moderatorDetails;
  final UserDetails? userDetails;
  final int vote;
  final String originalPostID;
  final bool? pollExpired;
  bool? isSaved;
  bool isRemoved;
  String? pollVote;
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
    this.scheduleDetails,
    this.inCommunityFlag,
    this.profilePicture,
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
    required this.isRemoved,
    this.setSuggestedSort,
    this.moderatorDetails,
    this.userDetails,
    this.pollExpired,
    this.isSaved,
    this.pollVote,
  });

  factory PostItem.fromJson(Map<String, dynamic> json) {
    print("BADRRRRRRR IN FROM JSON");
    print(json["post_in_community_flag"]);
    print(json["title"]);
    print(json["community_name"]);
    Map<String, dynamic> data =
        json['reposted'] != null ? json['reposted'] : {};
    final List<dynamic> jsonlist = json['images'] ?? [];
    final List<ImageItem> imagelist = jsonlist.map((jsonitem) {
      return ImageItem.fromJson(jsonitem);
    }).toList();
    final List<dynamic> jsonlist2 = json['videos'] ?? [];
    final List<VideoItem> videolist = jsonlist2.map((jsonitem) {
      return VideoItem.fromJson(jsonitem);
    }).toList();
    PollItem? poll;
    if (json['polls'] != null) {
      if (json['polls'].isNotEmpty) poll = PollItem.fromJson(json);
    }
    return PostItem(
      ///todo
      isReposted: json['is_reposted_flag'],
      originalPostID: (data['original_post_id'] != null)
          ? (data['original_post_id']!)
          : '', //(json['reposted']['original_post_id']!=null)?(json['reposted']['original_post_id']):'',
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
      linkUrl: json['link_url'] != null ? json['link_url'] : '',
      inCommunityFlag: json["post_in_community_flag"],
      isRemoved: json['deleted'],
      poll: poll,
      pollExpired: json['polls_voting_is_expired_flag'],
      isSaved: json['saved'] ?? false,
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
              approvedFlag: json['moderator_details']['approved_flag'],
            )
          : null,
      pollVote: json['poll_vote'] ?? "",
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
