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
    return Material(
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(
                              context, userController.userAbout?.socialLinks);
                        },
                        icon: const Icon(Icons.close),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text('Add Social Link',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
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
                                'social link added successfully ${userController.userAbout?.socialLinks}');
                            Navigator.pop(
                                context, userController.userAbout?.socialLinks);
                          } else {
                            print('form is invalid');
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.black,
                          ),
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
                    Container(width: 20, height: 20, child: socialMediaIcon),
                    SizedBox(width: 8),
                    Text(
                      socialLink,
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
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
