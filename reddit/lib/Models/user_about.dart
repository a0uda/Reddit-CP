import 'package:intl/intl.dart';
import 'package:reddit/Models/communtiy_backend.dart';
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
  bool? isPasswordSetFlag;
  List<CommunityBackend>? moderatedCommunities;

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
    this.moderatedCommunities,
    this.isPasswordSetFlag,
  });
  static UserAbout fromJson(jsonDecode) {
    if (jsonDecode == null) {
      return UserAbout(username: '');
    }
    return UserAbout(
      id: jsonDecode['id'],
      createdAt: DateFormat('d MMMM yyyy')
          .format(DateTime.parse(jsonDecode['created_at']))
          .toString(),
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
      profilePicture: (jsonDecode['profile_picture'] == null ||
              jsonDecode['profile_picture'] == "")
          ? 'images/Greddit.png'
          : jsonDecode['profile_picture'],
      bannerPicture: jsonDecode['banner_picture'],
      country: jsonDecode['country'] == ''
          ? 'Choose your location'
          : jsonDecode['country'],
      gender: jsonDecode['gender'],
      isPasswordSetFlag: jsonDecode['is_password_set_flag'] ?? false,
      connectedGoogle: jsonDecode['connected_google'],
      moderatedCommunities: jsonDecode['moderatedCommunities'] != null
          ? List<CommunityBackend>.from(jsonDecode['moderatedCommunities']
                  .map((community) => CommunityBackend.fromJson(community)))
              .toList()
          : null,
    );
  }
}
