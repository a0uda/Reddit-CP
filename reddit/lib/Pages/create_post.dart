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
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final postService = GetIt.instance.get<PostService>();
  XFile? _image;
  XFile? _video;
  bool imageSelected = false;
  bool videoSelected = false;
  bool pollSelected = false;
  VideoPlayerController? _videoPlayerController;

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
    }
  }

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
    String question;
    List<String> options = ['', ''];
    int selectedDays = 3;
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
                          'username',
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
                              'data:image/png;base64,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',
                          description: bodyController.text,
                          linkUrl: showLinkField ? URLController.text : null,
                          images: imageSelected
                              ? [ImageItem(path: _image!.path, link: 'linkUrl')]
                              : null,
                          videos: videoSelected
                              ? [VideoItem(path: _video!.path, link: 'linkUrl')]
                              : null,
                          poll: pollSelected
                              ? PollItem(
                                  question: questionController.text,
                                  options: options,
                                  votes: [0, 0])
                              : null),
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
                  if (pollSelected)
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                pollSelected = false;
                              });
                            },
                          ),
                          TextField(
                            controller: questionController,
                            onChanged: (value) => question = value,
                            decoration: InputDecoration(labelText: 'Question'),
                          ),
                          TextField(
                            onChanged: (value) => options[0] = value,
                            decoration: InputDecoration(labelText: 'Option 1'),
                          ),
                          TextField(
                            onChanged: (value) => options[1] = value,
                            decoration: InputDecoration(labelText: 'Option 2'),
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
