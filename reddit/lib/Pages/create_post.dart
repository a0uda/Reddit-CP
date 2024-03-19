import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';
import 'package:video_player/video_player.dart';
import 'package:get_it/get_it.dart';
import '../Services/post_service.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final postService = GetIt.instance.get<PostService>();
  XFile? _image;
  XFile? _video;
  bool imageSelected = false;
  bool videoSelected = false;
  VideoPlayerController? _videoPlayerController;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        imageSelected = true;
        if (showLinkField) {
          setState(() {
            showLinkField = false;
            videoSelected = false;
          });
        }
      });
    }
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
        if (showLinkField) {
          showLinkField = false;
          imageSelected = false;
        }
      });

      _videoPlayerController = VideoPlayerController.file(File(_video!.path))
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  final List<bool> _selections = List.generate(2, (index) => false);
  String selectedCommunity = "Select Community";
  bool showLinkField = false;
  String redditRules = '''
1. Be Respectful

2. No Spam or Self-Promotion

3. Stay on Topic

4. No NSFW Content

5. Follow Reddit's Content Policy
''';

  @override
  Widget build(BuildContext context) {
    List<String> userCommunities = ["r/news", "r/programming", "r/Flutter"];
    var counter = 0;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange[900],
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(235, 255, 255, 255),
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
                      postService.addPost(
                          counter++,
                          titleController.text,
                          bodyController.text,
                          DateTime.now(),
                          _image?.path,
                          null,
                          _video?.path),
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const ResponsiveLayout(
                            mobileLayout: MobileLayout(
                              mobilePageMode: 0,
                            ),
                            desktopLayout: DesktopHomePage(
                              indexOfPage: 0,
                            )),
                      ))
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
                    if (showLinkField) // Add this block
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
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
                        child: Image.file(
                          File(_image!.path),
                          fit: BoxFit.scaleDown,
                          height: MediaQuery.of(context).size.height / 2.5,
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
