class ModeratorItem {
  final String username;
  final bool everything;
  final bool managePostsAndComments;
  final bool manageUsers;
  final bool manageSettings;

  ModeratorItem({
    required this.everything,
    required this.managePostsAndComments,
    required this.manageSettings,
    required this.manageUsers,
    required this.username,
  });
  static ModeratorItem fromJson(jsonDecode) {
    return ModeratorItem(
      username: jsonDecode['username'],
      managePostsAndComments: jsonDecode['has_access']
          ["manage_posts_and_comments"],
      manageSettings: jsonDecode['has_access']["manage_settings"],
      manageUsers: jsonDecode['has_access']["manage_users"],
      everything: jsonDecode['has_access']["everything"],
    );
  }
}
