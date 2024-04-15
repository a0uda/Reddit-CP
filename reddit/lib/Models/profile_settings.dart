import 'package:reddit/Models/social_link_item.dart';

class ProfileSettings {
  String displayName;
  String about;
  List<SocialLlinkItem>? socialLinks;
  String? profilePicture;
  String? bannerPicture;
  bool nsfwFlag;
  bool allowFollowers;
  bool contentVisibility;
  bool activeCommunity;

  ProfileSettings({
    required this.displayName,
    required this.about,
    this.socialLinks,
    this.profilePicture,
    this.bannerPicture,
    this.nsfwFlag = true,
    this.allowFollowers = true,
    this.contentVisibility = true,
    this.activeCommunity = true,
  });
  static ProfileSettings fromJson(jsonDecode) {
    return ProfileSettings(
      displayName: jsonDecode['display_name'],
      about: jsonDecode['about'],
      socialLinks: jsonDecode['social_links'] != null
          ? List<SocialLlinkItem>.from(jsonDecode['social_links']
              .map((x) => SocialLlinkItem.fromJson(x)))
          : null,
      profilePicture: jsonDecode['profile_picture'],
      bannerPicture: jsonDecode['banner_picture'],
      nsfwFlag: jsonDecode['nsfw_flag'],
      allowFollowers: jsonDecode['allow_followers'],
      contentVisibility: jsonDecode['content_visibility'],
      activeCommunity: jsonDecode['active_communities_visibility'],
    );
  }
}
