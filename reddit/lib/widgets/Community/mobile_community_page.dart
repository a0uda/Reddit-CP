import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/community_controller.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Pages/description_widget.dart';
import 'package:reddit/Pages/history.dart';
import 'package:reddit/test_files/test_communities.dart';
import 'package:reddit/widgets/Moderator/desktop_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mobile_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mod_responsive.dart';
import 'package:reddit/widgets/Search/search_in_community.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/drawer_reddit.dart';
import 'package:reddit/widgets/end_drawer.dart';
import 'package:reddit/widgets/listing.dart';
import 'package:reddit/widgets/mobile_appbar.dart';

class MobileCommunityPage extends StatefulWidget {
  const MobileCommunityPage({
    super.key,
    required this.communityName,
    required this.isMod,
  });

  final String communityName;
  final bool isMod;

  @override
  State<MobileCommunityPage> createState() => _MobileCommunityPageState();
}

class _MobileCommunityPageState extends State<MobileCommunityPage> {
  bool isJoined = false;
  bool communityInfoFetched = false;
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  String? buttonState;
  final CommunityController communityController =
      GetIt.instance.get<CommunityController>();
  final UserController userController = GetIt.instance.get<UserController>();

  Future<void> fetchCommunityInfo() async {
    if (!communityInfoFetched) {
      await moderatorController.getCommunityInfo(widget.communityName);
    }
  }

  @override
  void initState() {
    if (isJoined) {
      buttonState = 'Joined';
    } else {
      buttonState = 'Join';
    }
    super.initState();
  }

  void setButton() {
    setState(() {
      if (moderatorController.joinedFlag) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
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
                      moderatorController.joinedFlag = false;
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
          moderatorController.joinedFlag = true;
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
    final bool userLoggedIn = userController.userAbout != null;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: MediaQuery.of(context).size.width > 700
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: DesktopAppBar(
                logoTapped: logoTapped,
                communityName: widget.communityName,
                isInCommunity: true,
              ),
            )
          : AppBar(
              leading: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), // Make it circular
                  color: Colors.grey[800]!.withOpacity(0.5),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              flexibleSpace: Container(
                decoration: (moderatorController.bannerPictureURL != "")
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              moderatorController.bannerPictureURL),
                          fit: BoxFit.cover,
                        ),
                      )
                    : BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'images/active_community_default_banner.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 10.0, top: 3, bottom: 3),
                  child: Container(
                    height: kToolbarHeight,
                    width: kToolbarHeight,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(50), // Make it circular
                      color: Colors.grey[800]!.withOpacity(0.5),
                    ),
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.search,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SearchInCommunity(
                              communityName: widget.communityName,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                userLoggedIn
                    ? Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Consumer<ProfilePictureController>(builder:
                            (context, profilepicturecontroller, child) {
                          return GestureDetector(
                            child: userController.userAbout!.profilePicture ==
                                        null ||
                                    userController
                                        .userAbout!.profilePicture!.isEmpty
                                ? const CircleAvatar(
                                    radius: kToolbarHeight / 2 - 8,
                                    backgroundImage:
                                        AssetImage('images/Greddit.png'),
                                  )
                                : CircleAvatar(
                                    radius: kToolbarHeight / 2 - 8,
                                    backgroundImage: NetworkImage(userController
                                        .userAbout!.profilePicture!),
                                  ),
                            onTap: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          );
                        }))
                    : const SizedBox(),
              ],
            ),
      endDrawer: userLoggedIn ? EndDrawerReddit() : Container(),
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
                  child: Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: MobileCommunityPageBar(
                      communityName: widget.communityName,
                      buttonState: buttonState!,
                      isJoined: isJoined,
                      isMod: widget.isMod,
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: Listing(
                    type: 'comm',
                    commName: widget.communityName,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//Community name, members count and description widget

class MobileCommunityPageBar extends StatefulWidget {
  const MobileCommunityPageBar({
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
  State<MobileCommunityPageBar> createState() => _MobileCommunityPageBarState();
}

class _MobileCommunityPageBarState extends State<MobileCommunityPageBar> {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  bool membersFetched = false;
  bool generalSettingsFetched = false;

  Future<void> fetchGeneralSettings() async {
    if (!generalSettingsFetched) {
      await moderatorController.getGeneralSettings(widget.communityName);
      generalSettingsFetched = true;
    }
  }

  Future<void> fetchMembersCount() async {
    if (!membersFetched) {
      await moderatorController.getMembersCount(widget.communityName);
      membersFetched = true;
    }
  }

  @override
  void initState() {
    super.initState();
    moderatorController.communityName = widget.communityName;
  }

  bool communityInfoFetched = false;

  Future<void> fetchCommunityInfo() async {
    if (!communityInfoFetched) {
      await moderatorController.getCommunityInfo(widget.communityName);
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
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: fetchCommunityInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.twoRotatingArc(
                              color: const Color.fromARGB(255, 172, 172, 172),
                              size: 20),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        print("Commmunittyyyyyy");
                        print(moderatorController.profilePictureURL);
                        return CircleAvatar(
                          backgroundImage: NetworkImage((moderatorController
                                      .profilePictureURL ==
                                  "")
                              ? "https://avatars.githubusercontent.com/u/95462348"
                              : moderatorController.profilePictureURL),
                          backgroundColor: Colors.white,
                          radius: 20,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "r/${widget.communityName}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      FutureBuilder<void>(
                        future: fetchMembersCount(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return const Text('none');
                            case ConnectionState.waiting:
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: LoadingAnimationWidget.twoRotatingArc(
                                      color: const Color.fromARGB(
                                          255, 172, 172, 172),
                                      size: 20),
                                ),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              return Text(
                                "${moderatorController.membersCount} members",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 98, 98, 98),
                                  fontSize: 12,
                                ),
                              );
                            default:
                              return const Text('badr');
                          }
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  widget.isMod
                      ? OutlineButtonWidget(
                          'Mod Tools',
                          () {
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
                          },
                          borderColor: Colors.transparent,
                          backgroundColour:
                              const Color.fromARGB(255, 0, 69, 172),
                          foregroundColour: Colors.white,
                        )
                      : userController.userAbout != null
                          ? FutureBuilder(
                              future: fetchCommunityInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return OutlineButtonWidget(
                                    moderatorController.joinedFlag
                                        ? 'Joined'
                                        : 'Join',
                                    () async {
                                      setButton(moderatorController.joinedFlag);
                                    },
                                    backgroundColour: moderatorController
                                            .joinedFlag
                                        ? Colors.white
                                        : const Color.fromARGB(255, 69, 72, 78),
                                    borderColor: moderatorController.joinedFlag
                                        ? Colors.black
                                        : Colors.transparent,
                                    foregroundColour:
                                        moderatorController.joinedFlag
                                            ? Colors.black
                                            : Colors.white,
                                  );
                                }
                              },
                            )
                          : const SizedBox(),
                ],
              ),
            ),
          ),
          FutureBuilder<void>(
            future: fetchCommunityInfo(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('none');
                case ConnectionState.waiting:
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return Container(
                    margin: const EdgeInsets.only(top: 0),
                    child: Text(
                      moderatorController.generalSettings.communityDescription,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  );
                default:
                  return const Text('badr');
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DescriptionWidget(
                    communityName: widget.communityName,
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
                shape: const ContinuousRectangleBorder(),
                padding: const EdgeInsets.all(0)),
            child: const Text(
              'See more',
              style: TextStyle(
                  color: Color.fromARGB(255, 37, 79, 165),
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
//Outlined Buttons Widget

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: backgroundColour ?? Colors.white,
        foregroundColor: foregroundColour ?? const Color.fromARGB(255, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        side: BorderSide(color: borderColor ?? Colors.transparent),
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
