import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Services/user_service.dart';
import 'profile_header_add_social_link.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  var userData;

  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;
  late TextEditingController nameController;
  late TextEditingController aboutController;
  final userService = GetIt.instance.get<UserService>();
  final userController = GetIt.instance.get<UserController>();
  int remainingNameCharacters = 30;
  int remainingAboutCharacters = 200;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: userController.userAbout?.displayName ?? '');
    aboutController =
        TextEditingController(text: userController.userAbout?.about ?? '');
    remainingNameCharacters = 30 - nameController.text.length;
    remainingAboutCharacters = 200 - aboutController.text.length;
    userData = userController.userAbout;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => {},
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: const Color.fromARGB(220, 234, 234, 234),
            height: 1 / 5 * MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => {},
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    color: Colors.grey[400]!,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => {},
                    child: profileWebFile != null
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(profileWebFile!),
                            radius: 32,
                          )
                        : profileFile != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(profileFile!),
                                radius: 32,
                              )
                            : CircleAvatar(
                                backgroundImage: AssetImage(
                                    userData.profilePicture ??
                                        'images/Greddit.png'),
                                radius: 32,
                              ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Display name (optional)',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    TextField(
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {
                          remainingNameCharacters = 30 - value.length;
                        });
                      },
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(220, 234, 234, 234),
                        filled: true,
                        hintText: 'Shown on your profile page',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        contentPadding: EdgeInsets.all(18),
                        counterText: '',
                      ),
                      maxLines: null,
                      maxLength: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: remainingNameCharacters < 30
                          ? Text(
                              '$remainingNameCharacters',
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "This will be displayed to viewers of your profile page and doesn't change your username.",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'About (optional)',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    TextField(
                      controller: aboutController,
                      onChanged: (value) {
                        setState(() {
                          remainingAboutCharacters = 200 - value.length;
                        });
                      },
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(220, 234, 234, 234),
                        filled: true,
                        hintText: 'A little description of yourself',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        contentPadding: EdgeInsets.all(18),
                        counterText: '',
                      ),
                      maxLines: 5,
                      maxLength: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: remainingAboutCharacters < 200
                          ? Text(
                              '$remainingAboutCharacters',
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Social Links (5 max)',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'People who visit your Reddit profile will see your social links',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Consumer<SocialLinksController>(
                  builder: (context, socialLinksController, child) {
                    return ProfileHeaderAddSocialLink(userData, 'me', false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
