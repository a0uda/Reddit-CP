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
}
