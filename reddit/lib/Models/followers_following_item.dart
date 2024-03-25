class FollowersFollowingItem {
  final String? id;
  final String? createdAt;
  final String username;
  final String? email;
  final bool? verifiedEmailFlag;
  final FollowersProfileSettings? profileSettings;
  final String? country;
  final String? gender;

  FollowersFollowingItem({
    this.id,
    this.createdAt,
    required this.username,
    this.email,
    this.verifiedEmailFlag,
    this.profileSettings,
    this.country,
    this.gender,
  });
}

class FollowersProfileSettings {
  final String? displayName;
  final String? about;
  final String? profilePicture;
  final String? bannerPicture;

  FollowersProfileSettings({
    this.displayName,
    this.about,
    this.profilePicture,
    this.bannerPicture,
  });
}
