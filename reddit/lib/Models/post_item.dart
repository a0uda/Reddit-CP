import 'package:reddit/Models/image_item.dart';
import 'package:reddit/Models/poll_item.dart';
import 'package:reddit/Models/video_item.dart';

class PostItem {
  final int id;
  final String username;
  final String? profilePic;
  final String title;
  final String? description;
  final String type;
  final String? linkUrl;
  final List<ImageItem>? images;
  final List<VideoItem>? videos;
  PollItem? poll;
  final int communityId;
  final String communityName;
  final bool ocFlag;
  final bool spoilerFlag;
  final bool nsfwFlag;
  final DateTime date;
  int likes;
  final int comments;
  final List<String> commentsList;
  PostItem({
    required this.id,
    required this.username,
    this.profilePic,
    required this.title,
    this.description,
    required this.type,
    this.linkUrl,
    this.images,
    this.videos,
    this.poll,
    required this.communityId,
    required this.communityName,
    required this.ocFlag,
    required this.spoilerFlag,
    required this.nsfwFlag,
    required this.date,
    required this.likes,
    required this.comments,
    required this.commentsList,
  });
}

//final List<PostItem> posts = [];
