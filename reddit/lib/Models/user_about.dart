class UserAbout {
  final String? id;
  final String? created_at;
  final String username;
  final String? email;
  final bool? verified_email_flag;
  final String? gmail;
  final String? facebook_email;
  final String? display_name;
  final String? about;
  final List<SocialLlinkItem>? social_links;
  final String? profile_picture;
  final String? banner_picture;
  final String? country;
  final String? gender;
  final bool? connected_google;

  UserAbout({
    this.id,
    this.created_at,
    required this.username,
    this.email,
    this.verified_email_flag,
    this.gmail,
    this.facebook_email,
    this.display_name,
    this.about,
    this.social_links,
    this.profile_picture,
    this.banner_picture,
    this.country,
    this.gender,
    this.connected_google,
  });
}

class SocialLlinkItem {
  final String? id;
  final String username;
  final String display_text;
  final String type;
  final String custom_url;

  SocialLlinkItem({
    this.id,
    required this.username,
    required this.display_text,
    required this.type,
    required this.custom_url,
  });
}