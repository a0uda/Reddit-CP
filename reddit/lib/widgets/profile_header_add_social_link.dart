import 'package:flutter/material.dart';
import '../Services/user_service.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_social_link_button.dart';

class ProfileHeaderAddSocialLink extends StatefulWidget {
  UserAbout userData;
  String userType;
  ProfileHeaderAddSocialLink(this.userData, this.userType);
  @override
  _ProfileHeaderAddSocialLinkState createState() =>
      _ProfileHeaderAddSocialLinkState(userData, userType);
}

class _ProfileHeaderAddSocialLinkState
    extends State<ProfileHeaderAddSocialLink> {
  late List<SocialLlinkItem>? socialLinks;
  late bool showAddSocialLinkButton;
  UserAbout userData;
  String userType;

  _ProfileHeaderAddSocialLinkState(this.userData, this.userType);

  final userService = GetIt.instance.get<UserService>();

  @override
  void initState() {
    super.initState();
    socialLinks = userData.social_links;
    updateAddSocialLinkButtonVisibility();
  }

  void updateAddSocialLinkButtonVisibility() {
    setState(() {
      if (socialLinks != null && socialLinks!.length < 5) {
        showAddSocialLinkButton = true;
      } else {
        showAddSocialLinkButton = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double widgetSize =
        screenWidth < screenHeight ? screenWidth : screenHeight;

    return Container(
      padding: EdgeInsets.only(
          left: (1 / 25) * widgetSize,
          right: (1 / 25) * widgetSize,
          bottom: (1 / 12) * widgetSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: (1 / 55) * widgetSize,
            runSpacing: (1 / 55) * widgetSize,
            children: [
              ...(socialLinks?.map((linkData) {
                    String websiteName = linkData.type.toLowerCase();
                    return TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse(linkData.custom_url));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(99, 105, 105, 105)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: (1 / 25) * widgetSize,
                            height: (1 / 25) * widgetSize,
                            child: getSocialMediaIcon(websiteName),
                          ),
                          SizedBox(width: (1 / 100) * widgetSize),
                          Text(
                            linkData.display_text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 0.022 * widgetSize,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList() ??
                  []),
              if (userType == 'me' && showAddSocialLinkButton)
                AddSocialLinkButton(onDataReceived: (result) {
                  setState(() {
                    socialLinks = result;
                    updateAddSocialLinkButtonVisibility();
                  });
                }),
            ],
          ),
        ],
      ),
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
