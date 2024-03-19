import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reddit_app/widgets/add_social_link_button.dart';
import 'package:social_media_flutter/widgets/icons.dart';
import 'package:social_media_flutter/widgets/text.dart';

class ProfileHeaderAddSocialLink extends StatefulWidget {
  var userData;
  String userType;
  ProfileHeaderAddSocialLink(this.userData, this.userType);
  @override
  _ProfileHeaderAddSocialLinkState createState() =>
      _ProfileHeaderAddSocialLinkState(userData, userType);
}

class _ProfileHeaderAddSocialLinkState
    extends State<ProfileHeaderAddSocialLink> {
  late List<dynamic>? socialLinks;
  late bool showAddSocialLinkButton;
  var userData;
  var userType;

  _ProfileHeaderAddSocialLinkState(this.userData, this.userType);

  @override
  void initState() {
    super.initState();
    socialLinks = userData['socialLinks'] as List<dynamic>?;
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
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: socialLinks?.map((linkData) {
                  return TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(99, 105, 105, 105)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SocialWidget(
                            placeholderText: linkData['placeholder'] ?? '',
                            iconData: linkData['icon'] ?? Icons.link,
                            link: linkData['link'] ?? '',
                            iconColor: Color(int.parse(
                                '0xFF${(linkData['iconColor'] as String).substring(1)}')),
                            iconSize: 15,
                            placeholderStyle: TextStyle(
                                color: Color.fromARGB(255, 212, 211, 211),
                                fontSize: 12)),
                      ],
                    ),
                  );
                }).toList() ??
                [],
          ),
          // Add Social Link Button
          if(userType == 'me' && showAddSocialLinkButton != null && showAddSocialLinkButton)
            AddSocialLinkButton(onDataReceived: (result) {
              setState(() {
                socialLinks = (result ?? '') as List?;
                updateAddSocialLinkButtonVisibility();
              });
            }),
        ],
      ),
    );
  }
}
