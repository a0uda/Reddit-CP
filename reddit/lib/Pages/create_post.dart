import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit/resources/add_data.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';
import 'package:video_player/video_player.dart';
import 'package:get_it/get_it.dart';
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
  final String? currentCommunityRules;

  const CreatePost(
      {super.key, this.currentCommunity, this.currentCommunityRules});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final postService = GetIt.instance.get<PostService>();

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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        imageSelected = true;
        showLinkField = false;
        videoSelected = false;
        pollSelected = false;
      });

      //TODO: FIREBASE
      //saveImage();
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
    });
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    String selectedCommunity = widget.currentCommunity ?? "Select Community";
    String redditRules = widget.currentCommunityRules ??
        '''
1. Be Respectful

2. No Spam or Self-Promotion

3. Stay on Topic

4. No NSFW Content

5. Follow Reddit's Content Policy
''';
    final UserController userController = GetIt.instance.get<UserController>();
    // ignore: unused_local_variable
    String question;
    List<String> options = ['', ''];
    int selectedDays = 3;
    List<String> userCommunities = ["r/news", "r/programming", "r/Flutter"];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange[900],
      ),
      home: Scaffold(
        backgroundColor: Color.fromARGB(235, 255, 255, 255),
        appBar: AppBar(
          elevation: 40,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: Colors.white)),
          actions: [
            IconButton(
                onPressed: (() => {
                      if (titleController.text.isEmpty ||
                          selectedCommunity == "Select Community")
                        {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Choose a community and add a title to your post!'),
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
                          postService.addPost(
                              userController.userAbout!.username,
                              titleController.text,
                              'type',
                              0,
                              selectedCommunity,
                              false,
                              _selections[1],
                              _selections[0],
                              0,
                              0,
                              [],
                              DateTime.now(),
                              profilePic:
                                  'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
                              description: bodyController.text,
                              linkUrl:
                                  showLinkField ? URLController.text : null,
                              images: imageSelected
                                  ? [
                                      ImageItem(
                                          path: _image!.path, link: imageUrl!)
                                    ]
                                  : null,
                              videos: videoSelected
                                  ? [
                                      VideoItem(
                                          path: _video!.path, link: 'linkUrl')
                                    ]
                                  : null,
                              poll: pollSelected
                                  ? PollItem(
                                      question: questionController.text,
                                      options: options,
                                      votes: [0, 0],
                                      option1Votes: [],
                                      option2Votes: [],
                                    )
                                  : null),
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
                    }),
                icon: const Icon(Icons.check, color: Colors.white)),
          ],
          title: const Text('Create Post'),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.orange[900],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(children: [
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
                                        userCommunities[index],
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(
                                            context, userCommunities[index]);
                                      },
                                    );
                                  },
                                );
                              },
                            );
                            setState(() {
                              if (result != null) selectedCommunity = result;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.deepOrange,
                            size: 20,
                          ),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => {
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Community Rules',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        redditRules,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        },
                        child: const Text(
                          'RULES',
                          style: TextStyle(
                            color: Colors.deepOrange,
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
                            image: FileImage(File(_image!.path)),
                            fit: BoxFit.contain,
                          ),
                        ),
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ),
                  if (videoSelected)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _videoPlayerController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio:
                                  _videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(_videoPlayerController!),
                            )
                          : Container(),
                    ),
                  if (pollSelected)
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
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
                              onChanged: (value) =>
                                  setState(() => selectedDays = value!),
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
                            decoration:
                                const InputDecoration(labelText: 'Question'),
                          ),
                          TextField(
                            onChanged: (value) => options[0] = value,
                            decoration:
                                const InputDecoration(labelText: 'Option 1'),
                          ),
                          TextField(
                            onChanged: (value) => options[1] = value,
                            decoration:
                                const InputDecoration(labelText: 'Option 2'),
                          ),
                        ],
                      ),
                    )
                ]),
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
                        foregroundColor: Colors.deepOrange,
                      ),
                      onPressed: () {
                        setState(() {
                          showLinkField = true;
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
                        foregroundColor: Colors.deepOrange,
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
                        foregroundColor: Colors.deepOrange,
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
                        foregroundColor: Colors.deepOrange,
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
