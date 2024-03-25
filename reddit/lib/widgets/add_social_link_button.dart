import 'package:flutter/material.dart';
import 'social_media_buttons.dart';
import 'add_social_link_form.dart';
import 'package:icons_plus/icons_plus.dart';
import '../Models/user_about.dart';

class AddSocialLinkButton extends StatelessWidget {
  final Function(List<SocialLlinkItem>?) onDataReceived;
  const AddSocialLinkButton({super.key, required this.onDataReceived});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double widgetSize =
        screenWidth < screenHeight ? screenWidth : screenHeight;
    return TextButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(const Color.fromARGB(99, 105, 105, 105)),
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
                  padding: EdgeInsets.all((1 / 33) * widgetSize),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: (1 / 33) * widgetSize),
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
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Add Social Link',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 1 / 33 * widgetSize,
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
                            spacing: (1 / 50) * widgetSize,
                            runSpacing: (1 / 50) * widgetSize,
                            children:
                                socialMediaButtons.map((socialMediaButton) {
                              return IconButtonWithText(
                                text: socialMediaButton['name'].toString(),
                                icon: socialMediaButton['brand'] as Brand,
                                onDataReceived: onDataReceived,
                              );
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
        children: <Widget>[
          Icon(
            Icons.add,
            color: Color.fromARGB(255, 175, 174, 174),
            size: (1 / 25) * widgetSize,
          ),
          SizedBox(width: (1 / 100) * widgetSize),
          Text(
            'Add social link',
            style: TextStyle(
                color: Color.fromARGB(255, 212, 211, 211),
                fontSize: 0.022 * widgetSize),
          ),
        ],
      ),
    );
  }
}

class IconButtonWithText extends StatelessWidget {
  final String text;
  final Brand icon;
  Function(List<SocialLlinkItem>?) onDataReceived;

  IconButtonWithText({
    required this.text,
    required this.icon,
    required this.onDataReceived,
  });

  @override
  Widget build(BuildContext context) {
    print('text: $text icon: $icon');
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double widgetSize =
        screenWidth < screenHeight ? screenWidth : screenHeight;
    return TextButton(
      onPressed: () async {
        Navigator.pop(context);
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddSocialLinkForm(
              socialMediaIcon: icon,
              socialLink: text,
            ),
          ),
        );
        onDataReceived(result);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 229, 228, 228)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: (1 / 25) * widgetSize,
              height: (1 / 25) * widgetSize,
              child: icon),
          SizedBox(width: (1 / 100) * widgetSize),
          Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 0.022 * widgetSize),
          ),
        ],
      ),
    );
  }
}
