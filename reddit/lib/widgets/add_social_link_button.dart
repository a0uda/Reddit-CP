import 'package:flutter/material.dart';
import 'social_media_buttons.dart';
import 'add_social_link_form.dart';
import 'package:icons_plus/icons_plus.dart';

class AddSocialLinkButton extends StatelessWidget {
  final bool notEditProfile;
  const AddSocialLinkButton({super.key, required this.notEditProfile});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.only(right: 12, left: 8)),
        backgroundColor: MaterialStateProperty.all(notEditProfile
            ? const Color.fromARGB(99, 105, 105, 105)
            : const Color.fromARGB(220, 234, 234, 234)),
      ),
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.3,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(220, 215, 213, 213),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close),
                              ),
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'Add Social Link',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                socialMediaButtons.map((socialMediaButton) {
                              return IconButtonWithText(
                                  text: socialMediaButton['name'].toString(),
                                  icon: socialMediaButton['brand'] as Brand);
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.add,
              color: notEditProfile
                  ? const Color.fromARGB(255, 175, 174, 174)
                  : Colors.black,
              size: 18),
          const SizedBox(width: 3),
          Text(
            'Add social link',
            style: TextStyle(
                color: notEditProfile
                    ? const Color.fromARGB(255, 212, 211, 211)
                    : Colors.black,
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class IconButtonWithText extends StatelessWidget {
  final String text;
  final Brand icon;

  const IconButtonWithText({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddSocialLinkForm(
              socialMediaIcon: icon,
              socialLink: text,
            ),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 229, 228, 228)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 20, height: 20, child: icon),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
