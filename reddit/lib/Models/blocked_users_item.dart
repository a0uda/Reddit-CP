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
}
