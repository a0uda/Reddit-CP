class NotificationsSettingsItem {
  bool mentions;
  bool comments;
  bool upvotesPosts;
  bool upvotesComments;
  bool replies;
  bool newFollowers;
  bool invitations;
  bool posts;
  bool privateMessages;
  bool chatMessages;
  bool chatRequests;

  NotificationsSettingsItem({
    required this.mentions,
    required this.comments,
    required this.upvotesPosts,
    required this.upvotesComments,
    required this.replies,
    required this.newFollowers,
    required this.invitations,
    required this.posts,
    required this.privateMessages,
    required this.chatMessages,
    required this.chatRequests,
  });

  static Future<NotificationsSettingsItem> fromJson(jsonD) {
    var json = jsonD['notifications_settings'];
    return Future.value(
      NotificationsSettingsItem(
        mentions: json['mentions'],
        comments: json['comments'],
        upvotesPosts: json['upvotes_posts'],
        upvotesComments: json['upvotes_comments'],
        replies: json['replies'],
        newFollowers: json['new_followers'],
        invitations: json['invitations'],
        posts: json['posts'],
        privateMessages: json['private_messages'],
        chatMessages: json['chat_messages'],
        chatRequests: json['chat_requests'],
      ),
    );
  }
}
