import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import '../Services/user_service.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_social_link_button.dart';
import '../Models/user_about.dart';
import 'add_social_link_form.dart';

class ProfileHeaderAddSocialLink extends StatefulWidget {
  final UserAbout userData;
  final String userType;
  final bool notEditProfile;
  const ProfileHeaderAddSocialLink(
      this.userData, this.userType, this.notEditProfile,
      {super.key});
  @override
  ProfileHeaderAddSocialLinkState createState() =>
      ProfileHeaderAddSocialLinkState();
}

class ProfileHeaderAddSocialLinkState
    extends State<ProfileHeaderAddSocialLink> {
  late bool showAddSocialLinkButton = true;
  late bool notEditProfile;
  UserAbout? userData;
  String? userType;

  final userService = GetIt.instance.get<UserService>();

  @override
  @override
  void initState() {
    super.initState();
    userData = widget.userData;
    userType = widget.userType;
    notEditProfile = widget.notEditProfile;
    showAddSocialLinkButton = true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SocialLinksController>(
      builder: (context, socialLinksController, child) {
        socialLinksController.getSocialLinks(userData!.username);
        return Container(
          padding: notEditProfile
              ? const EdgeInsets.only(left: 20, right: 20, bottom: 10)
              : EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ...(socialLinksController.socialLinks?.map((linkData) {
                        String websiteName = linkData.type.toLowerCase();
                        return TextButton(
                          onPressed: () {
                            if (notEditProfile) {
                              launchUrl(Uri.parse(linkData.customUrl));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddSocialLinkForm(
                                    socialMediaIcon:
                                        getSocialMediaIcon(websiteName)!,
                                    socialLink: websiteName,
                                    isEdit: true,
                                    socialLinkItem: linkData,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    const EdgeInsets.only(right: 8, left: 10)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                notEditProfile
                                    ? const Color.fromARGB(99, 105, 105, 105)
                                    : const Color.fromARGB(220, 234, 234, 234)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: getSocialMediaIcon(websiteName),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                linkData.displayText,
                                style: TextStyle(
                                  color: notEditProfile
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 5),
                              notEditProfile
                                  ? const SizedBox.shrink()
                                  : Container(
                                      width: 23,
                                      height: 23,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.black, size: 12),
                                        onPressed: () {
                                          socialLinksController
                                              .removeSocialLink(
                                                  userData!.username, linkData);
                                        },
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                            ],
                          ),
                        );
                      }).toList() ??
                      []),
                  if (userType == 'me' &&
                      socialLinksController.socialLinks != null &&
                      socialLinksController.socialLinks!.length < 5)
                    AddSocialLinkButton(notEditProfile: notEditProfile),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

Brand? getSocialMediaIcon(String websiteName) {
  switch (websiteName.toLowerCase()) {
    case 'instagram':
      return Brand(Brands.instagram);
    case 'facebook':
      return Brand(Brands.facebook);
    case 'twitter':
      return Brand(Brands.twitter);
    case 'linkedin':
      return Brand(Brands.linkedin);
    case 'youtube':
      return Brand(Brands.youtube);
    case 'reddit':
      return Brand(Brands.reddit);
    case 'pinterest':
      return Brand(Brands.pinterest);
    case 'snapchat':
      return Brand(Brands.snapchat);
    case 'tiktok':
      return Brand(Brands.tiktok);
    case 'whatsapp':
      return Brand(Brands.whatsapp);
    case 'skype':
      return Brand(Brands.skype);
    case 'renren':
      return Brand(Brands.renren);
    case 'flickr':
      return Brand(Brands.flickr);
    case 'twitch':
      return Brand(Brands.twitch);
    case 'github':
      return Brand(Brands.github);
    case 'stakoverflow':
      return Brand(Brands.stack_overflow);
    case 'paypal':
      return Brand(Brands.paypal);
    case 'etsy':
      return Brand(Brands.etsy);
    case 'shopify':
      return Brand(Brands.shopify);

    default:
      return null;
  }
}
