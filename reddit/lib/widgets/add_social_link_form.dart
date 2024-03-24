import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../Controllers/user_controller.dart';
import '../Services/user_service.dart';
import 'package:get_it/get_it.dart';

class AddSocialLinkForm extends StatefulWidget {
  final Brand socialMediaIcon;
  final String socialLink;

  const AddSocialLinkForm({
    Key? key,
    required this.socialMediaIcon,
    required this.socialLink,
  }) : super(key: key);

  @override
  _AddSocialLinkFormState createState() => _AddSocialLinkFormState(
      socialMediaIcon: socialMediaIcon, socialLink: socialLink);
}

class _AddSocialLinkFormState extends State<AddSocialLinkForm> {
  final Brand socialMediaIcon;
  final String socialLink;

  _AddSocialLinkFormState(
      {required this.socialMediaIcon, required this.socialLink});

  TextEditingController usernameController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final userService = GetIt.instance.get<UserService>();
  final userController = GetIt.instance.get<UserController>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double widgetSize =
        screenWidth < screenHeight ? screenWidth : screenHeight;

    return Material(
      child: FractionallySizedBox(
        heightFactor: 0.98,
        child: Container(
          padding: EdgeInsets.all((1 / 33) * widgetSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(
                              context, userController.userAbout?.social_links);
                        },
                        icon: Icon(
                          Icons.close,
                          size: (1 / 25) * widgetSize,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text('Add Social Link',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: (1 / 33) * widgetSize)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            userService.addSocialLink(
                              userController.userAbout!.username,
                              usernameController.text,
                              socialLink,
                              linkController.text,
                            );
                            userController
                                .getUser(userController.userAbout!.username);
                            print(
                                'social link added successfully ${userController.userAbout?.social_links}');
                            Navigator.pop(context,
                                userController.userAbout?.social_links);
                          } else {
                            print('form is invalid');
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: (1 / 33) * widgetSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: null,
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
                        child: socialMediaIcon),
                    SizedBox(width: (1 / 100) * widgetSize),
                    Text(
                      socialLink,
                      style: TextStyle(
                          color: Colors.black, fontSize: 0.022 * widgetSize),
                    ),
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.only(top: (1 / 33) * widgetSize),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Username',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 0.022 * widgetSize)),
                        controller: usernameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a username';
                          }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Link',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 0.022 * widgetSize)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
