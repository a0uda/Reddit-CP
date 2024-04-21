import 'package:intl/intl.dart';
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
  static UserAbout fromJson(jsonDecode) {
    if (jsonDecode == null) {
      return UserAbout(username: '');
    }
    return UserAbout(
      id: jsonDecode['content']['id'],
      createdAt: DateFormat('d MMMM yyyy')
          .format(DateTime.parse(jsonDecode['content']['created_at']))
          .toString(),
      username: jsonDecode['content']['username'],
      email: jsonDecode['content']['email'],
      verifiedEmailFlag: jsonDecode['content']['verified_email_flag'] == 'true',
      gmail: jsonDecode['content']['gmail'],
      facebookEmail: jsonDecode['content']['facebook_email'],
      displayName: jsonDecode['content']['display_name'],
      about: jsonDecode['content']['about'],
      socialLinks: jsonDecode['content']['social_links'] != null
          ? List<SocialLlinkItem>.from(jsonDecode['content']['social_links']
              .map((x) => SocialLlinkItem.fromJson(x)))
          : null,
      profilePicture: (jsonDecode['content']['profile_picture'] == "")
          ? 'images/Greddit.png'
          : jsonDecode['content']['profile_picture'],
      bannerPicture: jsonDecode['content']['banner_picture'],
      country: jsonDecode['content']['country'],
      gender: jsonDecode['content']['gender'],
      connectedGoogle: jsonDecode['content']['connected_google'],
    );
  }
}
