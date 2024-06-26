import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Pages/description_widget.dart';
import 'package:reddit/Pages/history.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/widgets/Moderator/desktop_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mobile_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mod_responsive.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/listing.dart';
import 'package:reddit/widgets/mobile_appbar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DesktopCommunityPage extends StatefulWidget {
  const DesktopCommunityPage({
    super.key,
    required this.communityName,
    required this.isMod,
  });

  final String communityName;
  final bool isMod;

  @override
  State<DesktopCommunityPage> createState() => _DesktopCommunityPageState();
}

class _DesktopCommunityPageState extends State<DesktopCommunityPage> {
  bool isJoined = false;
  String? buttonState;
  final CommunityController communityController =
      GetIt.instance.get<CommunityController>();
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();

  double descriptionOffset = 0.0;

  bool membersFetched = false;
  bool generalSettingsFetched = false;

  @override
  void initState() {
    if (moderatorController.joinedFlag) {
      buttonState = 'Joined';
    } else {
      buttonState = 'Join';
    }
    moderatorController.communityName = widget.communityName;
    isJoined = moderatorController.joinedFlag;
    super.initState();
  }

  void updateDescriptionOffset(double offset) {
    setState(() {
      descriptionOffset = offset;
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
      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
      appBar: MediaQuery.of(context).size.width > 700
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: DesktopAppBar(
                logoTapped: logoTapped,
                communityName: widget.communityName,
                isInCommunity: true,
              ),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: MobileAppBar(
                logoTapped: logoTapped,
                communityName: widget.communityName,
                isInCommunity: true,
              ),
            ),
      drawer: MediaQuery.of(context).size.width < 700
          ? const DrawerReddit(indexOfPage: 0, inHome: true)
          : null,
      endDrawer: EndDrawerReddit(),
      body: SizedBox(
        child: Row(
          children: [
            MediaQuery.of(context).size.width > 700
                ? const DrawerReddit(
                    indexOfPage: 0,
                    inHome: true,
                  )
                : const SizedBox(
                    width: 0,
                  ),
            MediaQuery.of(context).size.width > 700
                ? VerticalDivider(
                    color: Theme.of(context).colorScheme.primary, width: 1)
                : const SizedBox(
                    width: 0,
                  ),
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: DesktopCommunityPageBar(
                              communityName: widget.communityName,
                              buttonState: buttonState!,
                              isJoined: isJoined,
                              isMod: widget.isMod,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 24,
                      color: const Color.fromARGB(255, 251, 251, 251),
                    ),
                  ),
                  SliverFillRemaining(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Listing(
                              type: 'comm',
                              commName: widget.communityName,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: SingleChildScrollView(
                              child: DescriptionWidget(
                                communityName: widget.communityName,
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
          ],
        ),
      ),
    );
  }
}

class DesktopCommunityPageBar extends StatefulWidget {
  const DesktopCommunityPageBar({
    super.key,
    required this.communityName,
    required this.buttonState,
    required this.isJoined,
    required this.isMod,
  });

  final String communityName;
  final String buttonState;
  final bool isJoined;
  final bool isMod;

  @override
  State<DesktopCommunityPageBar> createState() =>
      _DesktopCommunityPageBarState();
}

class _DesktopCommunityPageBarState extends State<DesktopCommunityPageBar> {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  bool membersFetched = false;
  bool generalSettingsFetched = false;
  bool communityInfoFetched = false;

  Future<void> fetchCommunityInfo() async {
    if (!communityInfoFetched) {
      await moderatorController.getCommunityInfo(widget.communityName);
      communityInfoFetched = true;
    }
  }

  Future<void> fetchMembersCount() async {
    if (!membersFetched) {
      await moderatorController.getMembersCount(widget.communityName);
      membersFetched = true;
    }
  }

  void setButton(bool isJoined) async {
    var isJoinedProvider = context.read<IsJoinedProvider>();
    if (isJoined) {
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
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: const Color.fromARGB(255, 242, 243, 245),
                  surfaceTintColor: const Color.fromARGB(255, 242, 243, 245),
                  foregroundColor: const Color.fromARGB(255, 109, 109, 110),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(
                      color: Color.fromARGB(0, 238, 12, 0),
                    ),
                  ),
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await isJoinedProvider.leaveCommunity(
                    communityName: moderatorController.communityName,
                    isJoined: false,
                  );
                  setState(() {
                    moderatorController.joinedFlag = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      await isJoinedProvider.joinCommunity(
        communityName: moderatorController.communityName,
        isJoined: true,
      );
      setState(() {
        moderatorController.joinedFlag = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                Column(
                  children: [
                    FutureBuilder(
                      future: fetchCommunityInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: LoadingAnimationWidget.twoRotatingArc(
                                  color:
                                      const Color.fromARGB(255, 172, 172, 172),
                                  size: 30));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Consumer<UpdateProfilePicture>(
                              builder: (context, updateProfilePicture, child) {
                            return Container(
                              height: 128,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      moderatorController.bannerPictureURL),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          });
                        }
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: screenWidth >= 576 && screenWidth < 768
                                    ? 85 // Adjust margin for medium devices
                                    : screenWidth >= 768 && screenWidth < 992
                                        ? 90 // Adjust margin for large devices
                                        : screenWidth >= 992 &&
                                                screenWidth < 1200
                                            ? 100 // Adjust margin for extra large devices
                                            : screenWidth > 1200
                                                ? 100
                                                : 80), // Default margin size),
                            child: Text(
                              "r/${widget.communityName}",
                              style: TextStyle(
                                fontSize: screenWidth >= 576 &&
                                        screenWidth < 768
                                    ? 20 // Adjust font size for medium devices
                                    : screenWidth >= 768 && screenWidth < 992
                                        ? 25 // Adjust font size for large devices
                                        : screenWidth >= 992 &&
                                                screenWidth < 1200
                                            ? 30 // Adjust font size for extra large devices
                                            : screenWidth > 1200
                                                ? 32
                                                : 20, // Default font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          OutlineButtonWidget(
                            'Create a post',
                            () {
                              if (userController.userAbout != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModResponsive(
                                      mobileLayout: MobileModTools(
                                        communityName:
                                            moderatorController.communityName,
                                      ),
                                      desktopLayout: DesktopModTools(
                                        index: 0,
                                        communityName:
                                            moderatorController.communityName,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                            icon: const Icon(CupertinoIcons.add),
                            borderColor: Colors.black,
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          widget.isMod
                              ? OutlineButtonWidget(
                                  'Mod Tools',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ModResponsive(
                                          mobileLayout: MobileModTools(
                                            communityName: moderatorController
                                                .communityName,
                                          ),
                                          desktopLayout: DesktopModTools(
                                            index: 0,
                                            communityName: moderatorController
                                                .communityName,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  borderColor: Colors.transparent,
                                  backgroundColour:
                                      const Color.fromARGB(255, 0, 69, 172),
                                  foregroundColour: Colors.white,
                                )
                              : userController.userAbout != null ?
                              FutureBuilder(
                                  future: fetchCommunityInfo(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                                  color: const Color.fromARGB(
                                                      255, 172, 172, 172),
                                                  size: 30));
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return (OutlineButtonWidget(
                                        moderatorController.joinedFlag
                                            ? 'Joined'
                                            : 'Join',
                                        () async {
                                          setButton(
                                              moderatorController.joinedFlag);
                                        },
                                        backgroundColour:
                                            moderatorController.joinedFlag
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    255, 69, 72, 78),
                                        borderColor:
                                            moderatorController.joinedFlag
                                                ? Colors.black
                                                : Colors.transparent,
                                        foregroundColour:
                                            moderatorController.joinedFlag
                                                ? Colors.black
                                                : Colors.white,
                                      ));
                                    }
                                  },
                                ) : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 90,
                  left: screenWidth * 0.01,
                  child: FutureBuilder(
                    future: fetchCommunityInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: LoadingAnimationWidget.twoRotatingArc(
                                color: const Color.fromARGB(255, 172, 172, 172),
                                size: 30));
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Consumer<UpdateProfilePicture>(
                            builder: (context, updateProfilePicture, child) =>
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 4),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                        moderatorController.profilePictureURL),
                                  ),
                                ));
                      }
                    },
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

//outlined button class
class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget(this.buttonWidgetsText, this.onTap,
      {this.icon,
      this.backgroundColour,
      this.foregroundColour,
      this.borderColor,
      super.key});

  final String buttonWidgetsText;
  final Icon? icon;
  final Color? backgroundColour;
  final Color? foregroundColour;
  final Color? borderColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8, right: 14),
        backgroundColor: backgroundColour ?? Colors.white,
        foregroundColor: foregroundColour ?? const Color.fromARGB(255, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        side: BorderSide(color: borderColor ?? Colors.transparent, width: 0.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!],
          const SizedBox(
            width: 2,
          ),
          Text(
            buttonWidgetsText,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: foregroundColour ?? const Color.fromARGB(255, 0, 0, 0),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
