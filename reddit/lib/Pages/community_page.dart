import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Pages/description_widget.dart';
import 'package:reddit/widgets/Moderator/desktop_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mobile_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mod_responsive.dart';
import 'package:reddit/widgets/Community/button_widgets.dart';
import 'package:reddit/widgets/Community/community_description.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/mobile_appbar.dart';
import 'package:reddit/widgets/post.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage(
      {super.key,
      required this.communityName,
      required this.communityMembersNo,
      required this.communityRule,
      required this.communityProfilePicturePath,
      required this.communityDescription});

  final String communityName;
  final int communityMembersNo;
  final communityRule;
  final String communityProfilePicturePath;
  final String communityDescription;

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String buttonState = 'Join';
  // final CommunityController communityController =
  //     GetIt.instance.get<CommunityController>();
  
  final moderatorController = GetIt.instance.get<ModeratorController>();

  List<Post> communityPost = [];

  @override
  void initState() {
    super.initState();
    moderatorController.communityName = widget.communityName;
  }
  // Future<void> fetchCommunityPosts() async {
  //   for (String communityName in communityNames) {
  //     communityController.getCommunityPost(communityName);
  //     if (communityController.communityItem != null) {
  //         communityPost.add({

  //         });
  //     }
  //   }
  // }

  void setButton() {
    setState(() {
      if (buttonState == 'Joined') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: const Text(
                'Are you sure you want to leave this community?',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor: const Color.fromARGB(255, 242, 243, 245),
                    foregroundColor: const Color.fromARGB(255, 109, 109, 110),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: const BorderSide(
                          color: Color.fromARGB(0, 238, 12, 0)),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      buttonState = 'Join';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor: const Color.fromARGB(255, 240, 6, 6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: const BorderSide(
                        color: Color.fromARGB(0, 240, 6, 6),
                      ),
                    ),
                  ),
                  child: const Text('Leave'),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          buttonState = 'Joined';
        });
      }
    });
  }

  void logoTapped() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DesktopHomePage(indexOfPage: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width > 700
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: DesktopAppBar(logoTapped: logoTapped),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: MobileAppBar(logoTapped: logoTapped),
            ),
      drawer: MediaQuery.of(context).size.width < 700
          ? const DrawerReddit(indexOfPage: 0, inHome: true)
          : null,
      endDrawer: EndDrawerReddit(),
      body: Row(
        children: [
          MediaQuery.of(context).size.width > 700
              ? const DrawerReddit(
                  indexOfPage: 0,
                  inHome: true,
                )
              : const SizedBox(
                  width: 0,
                ),
          VerticalDivider(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CommunityDescription(
                              communityName: widget.communityName,
                              communityMembersNo: widget.communityMembersNo,
                              communityProfilePicturePath:
                                  widget.communityProfilePicturePath,
                              communityRule: widget.communityRule,
                              communityDescription: widget.communityDescription,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (buttonState == 'Join')
                                  ButtonWidgets(buttonState,
                                      backgroundColour: Colors.black,
                                      foregroundColour: Colors.white, () {
                                    setButton();
                                  })
                                else
                                  ButtonWidgets(buttonState, () {
                                    setButton();
                                  }),
                                ButtonWidgets('Create a post',
                                    icon: const Icon(Icons.add), () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => CreatePost(
                                  //       currentCommunity: widget.communityName,
                                  //       communityName: widget.communityName,
                                  //     ),
                                  //   ),
                                  // );
                                  //To be implemented
                                }),
                                ButtonWidgets('Mod Tools', () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ModResponsive(
                                        mobileLayout: MobileModTools(communityName: moderatorController.communityName,),
                                        desktopLayout: DesktopModTools(
                                          index: 0,
                                          communityName: moderatorController.communityName,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    height: 1,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Post(
                                  vote: 0,

                                  isLocked: false,
                                  id: "1",
                                  imageUrl: "assets/images/profile.png",
                                  name: "John Doe",
                                  title: "Flutter is the best",
                                  postContent: "Flutter is the best",
                                  date: "2021-09-09",
                                  likes: 4,
                                  commentsCount: 1,
                                  communityName: "r/FlutterDev",
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Post(
                                      vote: 0,
                                  isLocked: false,
                                  id: "1",
                                  imageUrl: "assets/images/profile.png",
                                  name: "John Doe",
                                  title: "Flutter is the best",
                                  postContent: "Flutter is the best",
                                  date: "2021-09-09",
                                  likes: 4,
                                  commentsCount: 1,
                                  communityName: "r/FlutterDev",
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Post(
                                      vote: 0,
                                  isLocked: false,
                                  id: "1",
                                  imageUrl: "assets/images/profile.png",
                                  name: "John Doe",
                                  title: "Flutter is the best",
                                  postContent: "Flutter is the best",
                                  date: "2021-09-09",
                                  likes: 4,
                                  commentsCount: 1,
                                  communityName: "r/FlutterDev",
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Post(
                                      vote: 0,
                                  isLocked: false,
                                  id: "1",
                                  imageUrl: "assets/images/profile.png",
                                  name: "John Doe",
                                  title: "Flutter is the best",
                                  postContent: "Flutter is the best",
                                  date: "2021-09-09",
                                  likes: 4,
                                  commentsCount: 1,
                                  communityName: "r/FlutterDev",
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Post(
                                      vote: 0,
                                  isLocked: false,
                                  id: "1",
                                  imageUrl: "assets/images/profile.png",
                                  name: "John Doe",
                                  title: "Flutter is the best",
                                  postContent: "Flutter is the best",
                                  date: "2021-09-09",
                                  likes: 4,
                                  commentsCount: 1,
                                  communityName: "r/FlutterDev",
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Post(
                                  isLocked: false,
                                      vote: 0,
                                  id: "1",
                                  imageUrl: "assets/images/profile.png",
                                  name: "John Doe",
                                  title: "Flutter is the best",
                                  postContent: "Flutter is the best",
                                  date: "2021-09-09",
                                  likes: 4,
                                  commentsCount: 1,
                                  communityName: "r/FlutterDev",
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Post(
                                  isLocked: false,
                                      vote: 0,
                                  id: "1",
                                  imageUrl: "assets/images/profile.png",
                                  name: "John Doe",
                                  title: "Flutter is the best",
                                  postContent: "Flutter is the best",
                                  date: "2021-09-09",
                                  likes: 4,
                                  commentsCount: 1,
                                  communityName: "r/FlutterDev",
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Post(
                                      vote: 0,
                                  isLocked: false,
                                  id: "1",
                                  imageUrl: "assets/images/profile.png",
                                  name: "John Doe",
                                  title: "Flutter is the best",
                                  postContent: "Flutter is the best",
                                  date: "2021-09-09",
                                  likes: 4,
                                  commentsCount: 1,
                                  communityName: "r/FlutterDev",
                                ),
                              ),
                              SizedBox(
                              
                                width: double.infinity,
                                child: Post(
                                      vote: 0,
                                  isLocked: false,
                                  id: "1",
                                  imageUrl: "assets/images/profile.png",
                                  name: "John Doe",
                                  title: "Flutter is the best",
                                  postContent: "Flutter is the best",
                                  date: "2021-09-09",
                                  likes: 4,
                                  commentsCount: 1,
                                  communityName: "r/FlutterDev",
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Post(
                                      vote: 0,
                                  isLocked: false,
                                  id: "1",
                                  imageUrl: "assets/images/profile.png",
                                  name: "John Doe",
                                  title: "Flutter is the best",
                                  postContent: "Flutter is the best",
                                  date: "2021-09-09",
                                  likes: 4,
                                  commentsCount: 1,
                                  communityName: "r/FlutterDev",
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (MediaQuery.of(context).size.width > 850)
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: DescriptionWidget(
                              communityDescription: widget.communityDescription,
                              communityRules: widget.communityRule,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
