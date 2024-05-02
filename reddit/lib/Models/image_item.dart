class ImageItem {
  final String path;
  final String? caption;
  final String link;

  ImageItem({
    required this.path,
    this.caption,
    required this.link,
  });
  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      path: json['path'],
      caption: json['caption'],
      link: json['link'],
    );

    ///todo
  }
}
