class NotificationItem {
  String? id;
  String? createdAt;
  String? postId;
  String? sendingUserUsername;
  String? communityName;
  bool? unreadFlag;
  bool? hiddenFlag;
  String? type;
  String? profilePicture;
  bool? isInCommunity;

  NotificationItem({
    this.id,
    this.createdAt,
    this.postId,
    this.sendingUserUsername,
    this.communityName,
    this.unreadFlag,
    this.hiddenFlag,
    this.type,
    this.profilePicture,
    this.isInCommunity,
  });

  static Future<NotificationItem> fromJson(json) {
    if (json == null) {
      return Future.value(NotificationItem(
        id: null,
        createdAt: '',
        postId: '',
        sendingUserUsername: '',
        communityName: '',
        unreadFlag: false,
        hiddenFlag: false,
        type: '',
        profilePicture: '',
        isInCommunity: false,
      ));
    }
    return Future.value(NotificationItem(
      id: json['id'],
      createdAt: json['created_at'],
      postId: json['post_id'],
      sendingUserUsername: json['sending_user_username'],
      communityName: json['community_name'],
      unreadFlag: json['unread_flag'],
      hiddenFlag: json['hidden_flag'],
      type: json['type'],
      profilePicture: json['profile_picture'],
      isInCommunity: json['is_in_community'],
    ));
  }
}
