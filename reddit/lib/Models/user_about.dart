class UserAbout {
  final String? id;
  final String? createdAt;
  final String username;
  final String? email;
  final bool? verifiedEmailFlag;
  final String? gmail;
  final String? facebookEmail;
  final String? displayName;
  final String? about;
  final List<SocialLlinkItem>? socialLinks;
  final String? profilePicture;
  final String? bannerPicture;
  final String? country;
  final String? gender;
  final bool? connectedGoogle;

  UserAbout({
    this.id,
    this.createdAt,
    required this.username,
    this.email,
    this.verifiedEmailFlag,
    this.gmail,
    this.facebookEmail,
    this.displayName,
    this.about,
    this.socialLinks,
    this.profilePicture,
    this.bannerPicture,
    this.country,
    this.gender,
    this.connectedGoogle,
  });
}

class SocialLlinkItem {
  final String? id;
  final String username;
  final String displayText;
  final String type;
  final String customUrl;

  SocialLlinkItem({
    this.id,
    required this.username,
    required this.displayText,
    required this.type,
    required this.customUrl,
  });
}
