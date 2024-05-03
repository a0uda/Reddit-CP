import 'package:reddit/Models/post_item.dart';

class VideoItem {
  final String path;
  final String? caption;
  final String link;

  VideoItem({
    required this.path,
    this.caption,
    required this.link,
  });

  static VideoItem fromJson(jsonitem) {
    return VideoItem(
      path: jsonitem['path'],
      caption: jsonitem['caption'],
      link: jsonitem['link'],
    );
  }
}
