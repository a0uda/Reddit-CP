import 'package:reddit/Models/social_link_item.dart';

class UserAbout {
  String? id;
  String? createdAt;
  String username;
  String? email;
  bool? verifiedEmailFlag;
  String? gmail;
  String? facebookEmail;
  String? displayName;
  String? about;
  List<SocialLlinkItem>? socialLinks;
  String? profilePicture;
  String? bannerPicture;
  String? country;
  String? gender;
  bool? connectedGoogle;

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


