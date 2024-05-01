import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/Pages/description_widget.dart';
import 'package:reddit/widgets/Community/community_description.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';
import 'package:video_player/video_player.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Services/community_service.dart';
import '../Services/post_service.dart';
import '../Controllers/user_controller.dart';
import '../Models/image_item.dart';
import '../Models/poll_item.dart';
import '../Models/video_item.dart';

// TODO: FIREBASE
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreatePost extends StatefulWidget {
  final String? currentCommunity;
  final String? communityName;

  const CreatePost({
    super.key,
    this.currentCommunity,
    this.communityName,
  });

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final postService = GetIt.instance.get<PostService>();
  final communityService = GetIt.instance.get<CommunityService>();
  final communityController = GetIt.instance.get<CommunityController>();
  final UserController userController = GetIt.instance.get<UserController>();
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();

  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;
  XFile? _image;
  XFile? _video;
  bool imageSelected = false;
  bool videoSelected = false;
  bool pollSelected = false;
  VideoPlayerController? _videoPlayerController;
  String? url;
  String? imageUrl;
  List<CommunityBackend> userCommunities = [];

  List<String> rules = [];

  Future<void> fetchUserCommunities() async {
    await userController.getUserCommunities();
    userCommunities = userController.userCommunities!;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        type = 'image';
      });

      //TODO: FIREBASE
      //saveImage();
      // try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${DateTime.now().microsecondsSinceEpoch}-${_image!.name}');
      print('images/${DateTime.now().microsecondsSinceEpoch}-${_image!.name}');
      print(_image!.name);
      try {
        // upload the file to Firebase Storage
        final uploadFile = File(_image!.path);
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
        // Handle the error as needed, such as displaying an error message to the user.
      }

      imageUrl = await storageRef.getDownloadURL();
      print(imageUrl);
      setState(() {
        imageSelected = true;
        showLinkField = false;
        videoSelected = false;
        pollSelected = false;
      });
      // } catch (e) {
      //   print(e);
      // }
    }
  }

  // void saveImage() async {
  //   imageUrl = await StoreData().saveData(
  //       collection: 'images',
  //       file: Uint8List.fromList(await File(_image!.path).readAsBytesSync()));
  // }

  void _pollPressed() {
    setState(() {
      pollSelected = true;
      showLinkField = false;
      imageSelected = false;
      videoSelected = false;
      type = 'poll';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserCommunities();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.dispose();
  }

  Future<void> _pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _video = pickedFile;
        videoSelected = true;
        showLinkField = false;
        imageSelected = false;
        pollSelected = false;
        type = 'video';
      });

      _videoPlayerController = VideoPlayerController.file(File(_video!.path))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController URLController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  final List<bool> _selections = List.generate(2, (index) => false);
  bool showLinkField = false;
  String type = 'type';
  String selectedCommunity = "Select Community";
  String communityDescription = "Select Community";

  var communityRules;
  int selectedDays = 3;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String question;
    List<String> options = ['', ''];

    Future<int> response;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(235, 255, 255, 255),
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon:
                  Icon(Icons.arrow_back_ios_rounded, color: Colors.blue[900])),
          actions: [
            IconButton(
                onPressed: (() async => {
                      if (titleController.text.isEmpty)
                        {
                          //print(selectedCommunity),
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content:
                                      const Text('Add a title to your post!'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                              color: Colors.deepOrange),
                                        )),
                                  ],
                                );
                              })
                        }
                      else
                        {
                          response = postService.addPost(
                              userController.userAbout!.id,
                              userController.userAbout!.username,
                              titleController.text,
                              bodyController.text,
                              type,
                              showLinkField ? URLController.text : null,
                              imageSelected
                                  ? [
                                      ImageItem(
                                          path: _image!.path, link: imageUrl!)
                                    ]
                                  : null,
                              videoSelected
                                  ? [
                                      VideoItem(
                                          path: _video!.path, link: 'linkUrl')
                                    ]
                                  : null,
                              pollSelected
                                  ? PollItem(
                                      question: questionController.text,
                                      options: options,
                                      votes: [0, 0],
                                      option1Votes: [],
                                      option2Votes: [],
                                    )
                                  : null,
                              selectedCommunity == "Select Community"
                                  ? ''
                                  : selectedCommunity,
                              selectedCommunity,
                              false,
                              _selections[1],
                              _selections[0],
                              !(selectedCommunity == "Select Community")),
                          //print(_selections),
                          if (await response == 400)
                            {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Error creating post, please try again later!'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                  color: Colors.deepOrange),
                                            )),
                                      ],
                                    );
                                  })
                            }
                          else
                            {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const ResponsiveLayout(
                                    mobileLayout: MobileLayout(
                                      mobilePageMode: 0,
                                    ),
                                    desktopLayout: DesktopHomePage(
                                      indexOfPage: 0,
                                    )),
                              ))
                            }
                        }
                    }),
                icon: Icon(Icons.check, color: Colors.blue[900])),
          ],
          title: const Text('Create Post'),
          titleTextStyle: TextStyle(
            color: Colors.blue[900],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          selectedCommunity,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.currentCommunity == null)
                          IconButton(
                            onPressed: () async {
                              final result = await showModalBottomSheet(
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context) {
                                  return ListView.builder(
                                    itemCount: userCommunities.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          userCommunities[index].name,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onTap: () async {
                                          await moderatorController.getRules(
                                              userCommunities[index].name);
                                          Navigator.pop(context,
                                              userCommunities[index].name);
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                              setState(() {
                                if (result != null) selectedCommunity = result;
                                // print(selectedCommunity);
                              });
                            },
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blue[900],
                              size: 20,
                            ),
                          ),
                        const Spacer(),
                        if (selectedCommunity != "Select Community")
                          TextButton(
                            onPressed: () => {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (BuildContext context) {
                                  return ModalForRules();
                                },
                              ),
                            },
                            child: Text(
                              'RULES',
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Title',
                        labelStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (showLinkField)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: URLController,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'URL',
                                          labelStyle: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        showLinkField = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            TextFormField(
                              controller: bodyController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'body text (optional)',
                              ),
                              maxLines: null,
                            ),
                            if (imageSelected)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      // image: FileImage(File(_image!.path)),
                                      image: NetworkImage(imageUrl!),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                ),
                              ),
                            if (videoSelected)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    _videoPlayerController!.value.isInitialized
                                        ? AspectRatio(
                                            aspectRatio: _videoPlayerController!
                                                .value.aspectRatio,
                                            child: VideoPlayer(
                                                _videoPlayerController!),
                                          )
                                        : Container(),
                              ),
                            if (pollSelected)
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      const Text(
                                        'Poll ends in ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      DropdownButton<int>(
                                        value: selectedDays,
                                        items: [1, 2, 3, 4, 5].map((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text('$value days'),
                                          );
                                        }).toList(),
                                        onChanged: (value) => setState(
                                            () => selectedDays = value!),
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            setState(() {
                                              pollSelected = false;
                                            });
                                          },
                                        ),
                                      ),
                                    ]),
                                    TextField(
                                      controller: questionController,
                                      onChanged: (value) => question = value,
                                      decoration: const InputDecoration(
                                          labelText: 'Question'),
                                    ),
                                    TextField(
                                      onChanged: (value) => options[0] = value,
                                      decoration: const InputDecoration(
                                          labelText: 'Option 1'),
                                    ),
                                    TextField(
                                      onChanged: (value) => options[1] = value,
                                      decoration: const InputDecoration(
                                          labelText: 'Option 2'),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // TOGGLE BUTTONS
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ToggleButtons(
                        isSelected: _selections,
                        borderRadius: BorderRadius.circular(30),
                        onPressed: (int index) {
                          setState(() {
                            _selections[index] = !_selections[index];
                          });
                        },
                        color: Colors.grey,
                        selectedColor: Colors.deepOrange,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.warning),
                                Text("NSFW"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.visibility_off),
                                Text("Spoiler"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                        foregroundColor: Colors.blue[900],
                      ),
                      onPressed: () {
                        setState(() {
                          showLinkField = true;
                          type = 'link';
                          if (imageSelected) {
                            setState(() => imageSelected = false);
                          }
                        });
                      },
                      child: const Icon(Icons.link),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                        foregroundColor: Colors.blue[900],
                      ),
                      onPressed: _pickImage,
                      child: const Column(
                        children: [
                          Icon(Icons.image),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                        foregroundColor: Colors.blue[900],
                      ),
                      onPressed: _pickVideo,
                      child: const Column(
                        children: [
                          Icon(Icons.video_call),
                          // Text('Video'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                        foregroundColor: Colors.blue[900],
                      ),
                      onPressed: _pollPressed,
                      child: const Column(
                        children: [
                          Icon(Icons.poll),
                          // Text('Video'),
                        ],
                      ),
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

class ModalForRules extends StatelessWidget {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();

  ModalForRules({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Center(
              child: Text(
                "Community Rules",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          const Text(
            "Rules are different for each community. Reviewing the rules can help you be more successful when posting",
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: moderatorController.rules.length,
              itemBuilder: (BuildContext context, int index) {
                final item = moderatorController.rules[index];
                return Column(
                  children: [
                    ListTile(
                      leading: Text("${index + 1}."),
                      title: Text(item.ruleTitle),
                    ),
                    Divider(
                      endIndent: 25,
                      indent: 25,
                      color: Colors.grey[300],
                      height: 1,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
