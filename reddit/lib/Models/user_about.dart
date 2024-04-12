import 'dart:convert';

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

  static UserAbout? fromJson(jsonDecode) {
    if (jsonDecode == null) {
      return null;
    }
    return UserAbout(
      id: jsonDecode['id'],
      createdAt: jsonDecode['created_at'],
      username: jsonDecode['username'],
      email: jsonDecode['email'],
      verifiedEmailFlag: jsonDecode['verified_email_flag'] == 'true',
      gmail: jsonDecode['gmail'],
      facebookEmail: jsonDecode['facebook_email'],
      displayName: jsonDecode['display_name'],
      about: jsonDecode['about'],
      socialLinks: jsonDecode['social_links'] != null
          ? List<SocialLlinkItem>.from(jsonDecode['social_links']
              .map((x) => SocialLlinkItem.fromJson(x)))
          : null,
      profilePicture: jsonDecode['profile_picture'],
      bannerPicture: jsonDecode['banner_picture'],
      country: jsonDecode['country'],
      gender: jsonDecode['gender'],
      connectedGoogle: jsonDecode['connected_google'],
    );
  }
}
