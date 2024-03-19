import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_flutter/widgets/icons.dart';
import '../test_files/test_arrays.dart';
import 'add_social_link_form.dart';
import '../test_files/test_arrays.dart';

class AddSocialLinkButton extends StatelessWidget {
  Function(List<dynamic>?) onDataReceived;
  AddSocialLinkButton({required this.onDataReceived});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Color.fromARGB(99, 105, 105, 105)),
      ),
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(220, 215, 213, 213),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 90),
                              child: Text('Add Social Link',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
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
                          children: socialMediaButtons.map((socialMediaButton) {
                            return IconButtonWithText(
                              text: socialMediaButton['name'].toString(),
                              icon: socialMediaButton['icon'] as IconData,
                              iconColor: Color(int.parse(
                                  '0xFF${(socialMediaButton['color'] as String).substring(1)}')),
                              onDataReceived: onDataReceived,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 2, top: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.add,
                color: const Color.fromARGB(255, 175, 174, 174), size: 20),
            SizedBox(width: 3),
            Text(
              'Add social link',
              style: TextStyle(
                  color: Color.fromARGB(255, 212, 211, 211), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class IconButtonWithText extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  Function(List<dynamic>?) onDataReceived;

  IconButtonWithText({
    required this.text,
    required this.icon,
    required this.iconColor,
    this.backgroundColor = const Color.fromARGB(255, 229, 228, 228),
    required this.onDataReceived,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: ()async {
        Navigator.pop(context);
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => 
            AddSocialLinkForm(
              socialMediaIcon: TextButton(
              onPressed: null,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(backgroundColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(icon, color: iconColor, size: 15),
                  SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ],
              ),
            ),
              socialLink: text,
              iconColor: iconColor,
            ),
          ),
        );
        onDataReceived(result);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: iconColor, size: 15),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
