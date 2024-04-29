class BlockedUsersItem {
  final String? id;
  final String username;
  final String profilePicture;
  final String blockedDate;

  BlockedUsersItem({
    this.id,
    required this.username,
    required this.profilePicture,
    required this.blockedDate,
  });

  static Future<BlockedUsersItem> fromJson(json) {
    if(json == null) {
      return Future.value(BlockedUsersItem(
        id: null,
        username: '',
        profilePicture: '',
        blockedDate: '',
      ));
    }
    return Future.value(BlockedUsersItem(
      id: json['id'],
      username: json['username'],
      profilePicture: json['profile_picture'],
      blockedDate: json['blocked_date'],
    ));
  }
}
