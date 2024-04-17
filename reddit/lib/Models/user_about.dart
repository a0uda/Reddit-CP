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
    print(jsonDecode['about']['username']);
    print(jsonDecode['about']['profile_picture']);
    return UserAbout(
      id: jsonDecode['about']['id'],
      createdAt: DateFormat('d MMMM yyyy')
          .format(DateTime.parse(jsonDecode['about']['created_at']))
          .toString(),
      username: jsonDecode['about']['username'],
      email: jsonDecode['about']['email'],
      verifiedEmailFlag: jsonDecode['about']['verified_email_flag'] == 'true',
      gmail: jsonDecode['about']['gmail'],
      facebookEmail: jsonDecode['about']['facebook_email'],
      displayName: jsonDecode['about']['display_name'],
      about: jsonDecode['about']['about'],
      socialLinks: jsonDecode['about']['social_links'] != null
          ? List<SocialLlinkItem>.from(jsonDecode['about']['social_links']
              .map((x) => SocialLlinkItem.fromJson(x)))
          : null,
      profilePicture: (jsonDecode['about']['profile_picture'] == "")
          ? 'images/Greddit.png'
          : jsonDecode['about']['profile_picture'],
      bannerPicture: jsonDecode['about']['banner_picture'],
      country: jsonDecode['about']['country'],
      gender: jsonDecode['about']['gender'],
      connectedGoogle: jsonDecode['about']['connected_google'],
    );
  }
}
