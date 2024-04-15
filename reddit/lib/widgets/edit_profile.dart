import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Services/user_service.dart';
import 'profile_header_add_social_link.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  late UserAbout? userData;
  late ProfileSettings? profileSettings;

  late TextEditingController nameController;
  late TextEditingController aboutController;
  final userService = GetIt.instance.get<UserService>();
  final userController = GetIt.instance.get<UserController>();
  int remainingNameCharacters = 30;
  int remainingAboutCharacters = 200;
  late String? _bannerimagepath;
  late String? _profileImagePath;
  late bool activeCommunity;
  late bool contentVisibility;
  bool _dataFetched = false;

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
    _bannerimagepath = userData!.bannerPicture;
    _profileImagePath = userData!.profilePicture;
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    aboutController.dispose();
  }

  fetchData() async {
    ProfileSettings? profileSettings =
        await userService.getProfileSettings(userData!.username);
    contentVisibility = profileSettings!.contentVisibility;
    activeCommunity = profileSettings.activeCommunity;
    setState(() {
      _dataFetched = true;
    });
  }

  selectBannerProfile(bool isBanner) async {
    String? selectedImagePath = isBanner ? _bannerimagepath : _profileImagePath;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(
                FluentIcons.camera_20_regular,
                color: Colors.black,
              ),
              title: Text('Camera'),
            ),
            ListTile(
              leading: const Icon(
                FluentIcons.image_20_regular,
                color: Colors.black,
              ),
              title: const Text('Library'),
              onTap: () async {
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  selectedImagePath = pickedFile.path;
                  setState(() {
                    if (isBanner) {
                      _bannerimagepath = selectedImagePath;
                    } else {
                      _profileImagePath = selectedImagePath;
                    }
                  });
                }
                Navigator.pop(context);
              },
            ),
            if (selectedImagePath != null && selectedImagePath!.isNotEmpty)
              ListTile(
                onTap: () {
                  setState(() {
                    selectedImagePath = null;
                    if (isBanner) {
                      _bannerimagepath = selectedImagePath;
                    } else {
                      _profileImagePath = selectedImagePath;
                    }
                  });
                  Navigator.pop(context);
                },
                leading: const Icon(
                  FluentIcons.delete_20_regular,
                  color: Colors.red,
                ),
                title: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  saveProfile() async {
    var editProfileController = context.read<EditProfileController>();
    await editProfileController.editProfile(
      nameController.text,
      aboutController.text,
      true,
      true,
      contentVisibility,
      activeCommunity,
    );

    var bannerPictureController = context.read<BannerPictureController>();
    if (_bannerimagepath == null) {
      bannerPictureController.removeBannerPicture();
    } else {
      bannerPictureController.changeBannerPicture(_bannerimagepath!);
    }
    var profilePictureController = context.read<ProfilePictureController>();
    if (_profileImagePath == null) {
      profilePictureController.removeProfilePicture();
    } else {
      profilePictureController.changeProfilePicture(_profileImagePath!);
    }
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return _dataFetched ? _buildEditProfileScreen() : _buildLoading();
  }

  Widget _buildLoading() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEditProfileScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () async {
              await saveProfile();
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 1 / 5 * MediaQuery.of(context).size.height + 40,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => selectBannerProfile(true),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    dashPattern: const [10, 4],
                    strokeCap: StrokeCap.round,
                    color: Colors.grey[400]!,
                    child: Container(
                      width: double.infinity,
                      height: 1 / 5 * MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _bannerimagepath != null &&
                                  _bannerimagepath!.isNotEmpty
                              ? File(_bannerimagepath!).existsSync()
                                  ? Image.file(
                                      File(_bannerimagepath!),
                                      fit: BoxFit.fill,
                                    )
                                  : Image(
                                      image: AssetImage(_bannerimagepath!),
                                      fit: BoxFit.fill,
                                    )
                              : Container(
                                  color: Colors.grey[300],
                                ),
                          const Icon(
                            FluentIcons.camera_add_20_regular,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 1 / 5 * MediaQuery.of(context).size.height - 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => selectBannerProfile(false),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.white, // Border color
                              width: 2, // Border width
                            ),
                            image: _profileImagePath != null
                                ? (File(_profileImagePath!).existsSync())
                                    ? DecorationImage(
                                        image:
                                            FileImage(File(_profileImagePath!)),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: () {
                                          try {
                                            return AssetImage(
                                                _profileImagePath!);
                                          } catch (e) {
                                            // The asset doesn't exist, return a default asset
                                            return const AssetImage(
                                                'images/Greddit.png'); // Replace with your default asset path
                                          }
                                        }(),
                                        fit: BoxFit.cover,
                                      )
                                : const DecorationImage(
                                    image: AssetImage('images/Greddit.png'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 33,
                            backgroundColor: Color.fromARGB(22, 0, 0, 0),
                            child: Icon(
                              FluentIcons.camera_add_20_regular,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
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
                ProfileHeaderAddSocialLink(userData!, 'me', false),
                const SizedBox(height: 30),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Content visibility',
                    style: TextStyle(fontSize: 15),
                  ),
                  subtitle: const Text(
                    'Posts to this profile can appear in r/all and your profile can be discovered in /users',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Switch(
                    value: contentVisibility,
                    onChanged: (value) {
                      setState(() {
                        contentVisibility = value;
                      });
                    },
                    thumbColor: MaterialStateProperty.all(Colors.white),
                    activeTrackColor: Colors.blue[900],
                    inactiveTrackColor: Colors.grey[300],
                    trackOutlineColor:
                        MaterialStateProperty.all(Colors.grey[300]),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Show active communities',
                    style: TextStyle(fontSize: 15),
                  ),
                  subtitle: const Text(
                    'Decide whether to show the communities you are active in on your profile',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Switch(
                    value: activeCommunity,
                    onChanged: (value) {
                      setState(() {
                        activeCommunity = value;
                      });
                    },
                    thumbColor: MaterialStateProperty.all(Colors.white),
                    activeTrackColor: Colors.blue[900],
                    inactiveTrackColor: Colors.grey[300],
                    trackOutlineColor:
                        MaterialStateProperty.all(Colors.grey[300]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
