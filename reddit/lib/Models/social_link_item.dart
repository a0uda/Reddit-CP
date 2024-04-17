class SocialLlinkItem {
  String id;
  String username;
  String displayText;
  String type;
  String customUrl;

  SocialLlinkItem({
    required this.id,
    required this.username,
    required this.displayText,
    required this.type,
    required this.customUrl,
  });

  static fromJson(x) {
    return SocialLlinkItem(
      id: x['_id'],
      username: x['username'],
      displayText: x['display_text'],
      type: x['type'],
      customUrl: x['custom_url'],
    );
  }
}
