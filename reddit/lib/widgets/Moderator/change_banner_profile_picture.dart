import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';

class ChangeProfilePicture extends StatefulWidget {
  const ChangeProfilePicture({super.key});

  @override
  State<ChangeProfilePicture> createState() => _ChangeProfilePictureState();
}

class _ChangeProfilePictureState extends State<ChangeProfilePicture> {
  String? bannerimagepath;
  String? profileImagePath;
  bool isSaved = true;
  bool doneSaved = false;

    final moderatorController = GetIt.instance.get<ModeratorController>();

  @override
  void initState() {
    super.initState();
    bannerimagepath = moderatorController.bannerPictureURL;
    profileImagePath = moderatorController.profilePictureURL;
  }
  

  Future<void> _pickImage(bool isBanner, bool isCamera) async {
    var pickedFile;
    if (isCamera) {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (pickedFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${DateTime.now().microsecondsSinceEpoch}-${pickedFile.name}');
      print(
          'images/${DateTime.now().microsecondsSinceEpoch}-${pickedFile.name}');
      print(pickedFile.name);
      try {
        // upload the file to Firebase Storage
        final uploadFile = File(pickedFile.path);
        print(uploadFile.path);
        await storageRef
            .putFile(
                uploadFile,
                SettableMetadata(
                  cacheControl: "public,max-age=300",
                  contentType: 'image/png',
                ))
            .whenComplete(() {});
      } catch (e) {
        print('Error uploading file to Firebase Storage: $e');
      }
      if (isBanner) {
        bannerimagepath = await storageRef.getDownloadURL();
      } else {
        profileImagePath = await storageRef.getDownloadURL();
      }
    }
  }

  selectBannerProfile(bool isBanner) async {
    String? selectedImagePath = isBanner ? bannerimagepath : profileImagePath;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                FluentIcons.camera_20_regular,
                color: Colors.black,
              ),
              title: const Text('Camera'),
              onTap: () async {
                await _pickImage(isBanner, true);
                setState(() {});
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                FluentIcons.image_20_regular,
                color: Colors.black,
              ),
              title: const Text('Library'),
              onTap: () async {
                await _pickImage(isBanner, false);
                setState(() {});
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
            if (selectedImagePath != null && selectedImagePath!.isNotEmpty)
              ListTile(
                onTap: () {
                  setState(() {
                    selectedImagePath = null;
                    if (isBanner) {
                      bannerimagepath = selectedImagePath;
                    } else {
                      profileImagePath = selectedImagePath;
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var profileBannerProvider = context.read<UpdateProfilePicture>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit profile and banner picture',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
               await profileBannerProvider.updateProfilePicture(communityName: moderatorController.communityName, pictureUrl: profileImagePath!);
               await profileBannerProvider.updateBannerPicture(communityName: moderatorController.communityName, pictureUrl: bannerimagepath!);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: isSaved
                    ? const Color.fromARGB(255, 23, 105, 165)
                    : const Color.fromARGB(255, 162, 174, 192),
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
        leading: (screenWidth < 700)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (doneSaved) {
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: const Text(
                              'Leave without saving',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: const Text(
                                  'You cannot undo this action',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 242, 242, 243),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 242, 242, 243)),
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 16,
                                            top: 16,
                                            bottom: 16),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 108, 108, 108)),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 37, 79, 165),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 37, 79, 165)),
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 16,
                                            top: 16,
                                            bottom: 16),
                                      ),
                                      child: const Text(
                                        'Leave',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              )
            : null,
      ),
      body: SizedBox(
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
                      bannerimagepath != null && bannerimagepath!.isNotEmpty
                          ? Image.network(
                              bannerimagepath!,
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
                        image: profileImagePath != null &&
                                profileImagePath!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(profileImagePath!),
                                fit: BoxFit.fill,
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
    );
  }
}
