class FollowersFollowingItem {
  final String? id;
  final String? created_at;
  final String username;
  final String? email;
  final bool? verified_email_flag;
  final FollowersProfileSettings? profileSettings;
  final String? country;
  final String? gender;

  FollowersFollowingItem({
    this.id,
    this.created_at,
    required this.username,
    this.email,
    this.verified_email_flag,
    this.profileSettings,
    this.country,
    this.gender,
  });
}

class FollowersProfileSettings {
  final String? display_name;
  final String? about;
  final String? profile_picture;
  final String? banner_picture;

  FollowersProfileSettings({
    this.display_name,
    this.about,
    this.profile_picture,
    this.banner_picture,
  });
}