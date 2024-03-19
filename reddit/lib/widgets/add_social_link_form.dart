import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_media_flutter/widgets/icons.dart';
import '../test_files/test_arrays.dart';

class AddSocialLinkForm extends StatefulWidget {
  final Widget socialMediaIcon;
  final String socialLink;
  final Color iconColor;

  const AddSocialLinkForm(
      {Key? key,
      required this.socialMediaIcon,
      required this.socialLink,
      required this.iconColor})
      : super(key: key);

  @override
  _AddSocialLinkFormState createState() => _AddSocialLinkFormState(
      socialMediaIcon: socialMediaIcon,
      socialLink: socialLink,
      iconColor: iconColor);
}

class _AddSocialLinkFormState extends State<AddSocialLinkForm> {
  final Widget socialMediaIcon;
  final String socialLink;
  final Color iconColor;

  _AddSocialLinkFormState(
      {required this.socialMediaIcon,
      required this.socialLink,
      required this.iconColor});

  TextEditingController usernameController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FractionallySizedBox(
        heightFactor: 0.9,
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
                        padding: EdgeInsets.only(left: 70, right: 70),
                        child: Text('Add Social Link',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            var socialLinkIcon = socialMediaButtons.firstWhere(
                                (element) =>
                                    (element['name'] as String?)
                                        ?.contains(socialLink) ??
                                    false,
                                orElse: () => <String, Object>{});
                            print('Before update: ${socialLinkIcon['icon']}');
                            (user_data['socialLinks'] as List).add({
                              'icon': socialLinkIcon['icon'] ?? Icons.link,
                              'link': linkController.text,
                              'iconColor': socialLinkIcon['color'].toString(),
                              'placeholder': usernameController.text
                            });
                            print(
                                '----------------------Data added successfully------------------------');
                            print('After update: $user_data');
                            Navigator.pop(context, user_data['socialLinks']);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter valid data'),
                              ),
                            );
                          }
                        },
                        child: Text('Save'),
                      )
                    ],
                  ),
                ),
              ),
              socialMediaIcon,
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      controller: usernameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a username';
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Link'),
                      controller: linkController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a link';
                        }
                        final urlPattern = RegExp(
                            r'^(http|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?$');
                        if (!urlPattern.hasMatch(value)) {
                          return 'Please enter a valid link';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
