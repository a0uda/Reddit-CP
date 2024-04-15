class FollowersFollowingItem {
  final String? id;
  final String? createdAt;
  final String username;
  final String? email;
  final String? about;
  final String? gender;
  final String? profilePicture;
  final String? bannerPicture;
  final String? displayName;

  FollowersFollowingItem({
    this.id,
    this.createdAt,
    required this.username,
    this.email,
    this.about,
    this.bannerPicture,
    this.displayName,
    this.gender,
    this.profilePicture,
  });

  factory FollowersFollowingItem.fromJson(Map<String, dynamic> json) {
    return FollowersFollowingItem(
        id: json['_id'],
        createdAt: json['created_at'],
        email: json['email'],
        username: json['username'],
        displayName: json['display_name'],
        about: json['about'],
        profilePicture: json['profile_picture'],
        bannerPicture: json['banner_picture'],
        gender: json['gender']);
  }
}
