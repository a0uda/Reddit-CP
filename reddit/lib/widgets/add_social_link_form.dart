import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Models/social_link_item.dart';
import '../Controllers/user_controller.dart';
import 'package:get_it/get_it.dart';

class AddSocialLinkForm extends StatefulWidget {
  final Brand socialMediaIcon;
  final String socialLink;
  final bool isEdit;
  final SocialLlinkItem? socialLinkItem;

  const AddSocialLinkForm({
    super.key,
    required this.socialMediaIcon,
    required this.socialLink,
    this.isEdit = false,
    this.socialLinkItem,
  });

  @override
  AddSocialLinkFormState createState() => AddSocialLinkFormState();
}

class AddSocialLinkFormState extends State<AddSocialLinkForm> {
  late Brand socialMediaIcon;
  late String socialLink;
  bool isEdit = false;
  SocialLlinkItem? socialLinkItem;
  TextEditingController usernameController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    socialMediaIcon = widget.socialMediaIcon;
    socialLink = widget.socialLink;
    isEdit = widget.isEdit;
    socialLinkItem = widget.socialLinkItem;
    if (isEdit == true) {
      usernameController =
          TextEditingController(text: socialLinkItem!.displayText);
      linkController = TextEditingController(text: socialLinkItem!.customUrl);
    } else {
      usernameController = TextEditingController();
      linkController = TextEditingController();
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final userController = GetIt.instance.get<UserController>();

  @override
  Widget build(BuildContext context) {
    var socialLinksController = context.read<SocialLinksController>();
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
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                              isEdit ? 'Edit Social link' : 'Add Social Link',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (isEdit) {
                              print('isEdit');
                              print(isEdit);
                              socialLinksController.editSocialLink(
                                userController.userAbout!.username,
                                socialLinkItem!.id,
                                usernameController.text,
                                linkController.text,
                              );
                            } else {
                              socialLinksController.addSocialLink(
                                userController.userAbout!.username,
                                usernameController.text,
                                socialLink,
                                linkController.text,
                              );
                            }
                            Navigator.pop(context);
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
                    SizedBox(width: 20, height: 20, child: socialMediaIcon),
                    const SizedBox(width: 8),
                    Text(
                      socialLink,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      controller: usernameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Link'),
                      controller: linkController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a link';
                        }
                        final urlPattern = RegExp(
                            r'^(http|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/+#-]*[\w@?^=%&/+#-])?$');
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
