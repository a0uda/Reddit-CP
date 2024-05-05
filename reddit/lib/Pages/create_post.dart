import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';
import 'package:reddit/widgets/video_player_widget.dart';
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
  String? videoUrl;
  List<CommunityBackend> userCommunities = [];
  bool communitiesFetched = false;
  bool isMod = false;

  List<String> rules = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isSaved = false;

  void setSelectedDate(DateTime date, TimeOfDay time, String selectedRepeat) {
    if (selectedRepeat == "") {
      //hour , day , week , month
      selectedDate = date;
      selectedTime = time;
      setState(() {
        isSaved = true;
      });
    } else {
      //set flags recurring we mashy el denya we schedule bardo
      setState(() {
        isSaved = true;
      });
    }
  }

  Future<void> fetchUserCommunities() async {
    if (!communitiesFetched) {
      await userController.getUserCommunities();
      userCommunities = userController.userCommunities!;
      print('Mohy beyharab print communities');
      print(userCommunities);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        type = 'image_and_videos';
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
        type = 'image_and_videos';
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
      type = 'polls';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserCommunities();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _videoPlayerController?.dispose();
  // }

  Future<void> _pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _video = pickedFile;
      });
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('videos')
          .child('${DateTime.now().microsecondsSinceEpoch}-${_video!.name}');
      print(_video!.name);
      try {
        // upload the file to Firebase Storage
        final uploadFile = File(_video!.path);
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

      videoUrl = await storageRef.getDownloadURL();
      print(videoUrl);
      setState(() {
        showLinkField = false;
        videoSelected = true;
        pollSelected = false;
        imageSelected = false;
        type = 'image_and_videos';
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
  String type = 'text';
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
            isMod
                ? IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return ModalForSchedule(
                            setValues: setSelectedDate,
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_horiz_outlined))
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: (() async => {
                      if (titleController.text.isEmpty)
                        {
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
                                          path: _video!.path, link: videoUrl!)
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 3, 55, 146),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  surfaceTintColor: const Color.fromARGB(255, 3, 55, 146),
                  padding: const EdgeInsets.all(5),
                ),
                child: isSaved
                    ? const Text(
                        "Schedule",
                      )
                    : const Text(
                        "Post",
                      ),
              ),
            ),
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
                                    shrinkWrap: true,
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
                              if (result != null &&
                                  userController
                                          .userAbout?.moderatedCommunities !=
                                      null) {
                                setState(() {
                                  isMod = userController
                                      .userAbout!.moderatedCommunities!
                                      .any((community) =>
                                          community.name == result);
                                  if (!isMod) {
                                    isSaved = false;
                                  }
                                  selectedCommunity = result;
                                });
                              } else {
                                setState(() {
                                  if (result != null) {
                                    selectedCommunity = result;
                                  }
                                });
                              }
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
                                        type = 'text';
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
                              VideoPlayerWidget(videoPath: videoUrl!),
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
                          type = 'url';
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
          const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10),
            child: Text(
              "Rules are different for each community. Reviewing the rules can help you be more successful when posting.",
              style: TextStyle(color: Colors.grey),
            ),
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

class ModalForSchedule extends StatefulWidget {
  final Function(DateTime date, TimeOfDay time, String recurrings) setValues;
  const ModalForSchedule({super.key, required this.setValues});

  @override
  State<ModalForSchedule> createState() => _ModalForScheduleState();
}

class _ModalForScheduleState extends State<ModalForSchedule> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> values = ["hour", "day", "week", "monthly"];
  List<String> labels = [
    "Every hour",
    "Every day ",
    "Weekly on ${DateFormat('EEEE').format(DateTime.now())}",
    "Monthly on the ${DateTime.now().day}th"
  ];
  String selectedRepeat = "";

  void selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              surfaceTint: Colors.white,
              primary: Colors.blue, // Background color for the selected date
              onPrimary: Colors.white, // Text color for the selected date
              surface: Colors.white, // Background color of the picker
              onSurface: Colors.black, // Text color for unselected dates
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void selectTime() async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                surfaceTint: Colors.white,
                primary: Colors.blue,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        });

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 700
          ? MediaQuery.of(context).size.width * 0.4
          : null,
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            children: [
              AppBar(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                title: const Text("Schedule Post"),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.setValues(
                            selectedDate, selectedTime, selectedRepeat);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 69, 172),
                      ),
                      child: const Text("Save"),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Text("Starts on date"),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      selectDate();
                    },
                    child: Text(
                        "${DateFormat.MMM().format(selectedDate)} ${selectedDate.day}, ${selectedDate.year}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 49, 90))),
                  )
                ],
              ),
              Row(
                children: [
                  const Text("Starts at time"),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      selectTime();
                    },
                    child: Text(selectedTime.format(context),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 49, 90))),
                  )
                ],
              ),
              GestureDetector(
                child: const Row(
                  children: [
                    Text("Repeat Every..."),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right_sharp)
                  ],
                ),
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                    ),
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return ListView.builder(
                          itemCount: labels.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RadioListTile(
                              activeColor: Colors.blue[900],
                              selectedTileColor: Colors.blue[900],
                              title: Text(labels[index]),
                              value: values[index],
                              groupValue: selectedRepeat,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedRepeat = newValue!;
                                });
                              },
                            );
                          },
                        );
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
