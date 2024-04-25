import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';

//Hena fel page deeh el mafrood te3ml boolean bey-save el state beta3t el community w yeshoof law etghayret wala laa law etghayret yeb2a hatghayr isSaved
class PostTypes extends StatelessWidget {
  const PostTypes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchCommunityPostComments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // or any loading indicator
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return PostTypesContent();
        }
      },
    );
  }

  Future<void> fetchCommunityPostComments() async {
    final moderatorController = GetIt.instance.get<ModeratorController>();
    await moderatorController
        .getPostTypesAndOptions(moderatorController.communityName);
  }
}

class PostTypesContent extends StatefulWidget {
  const PostTypesContent({super.key});

  @override
  State<PostTypesContent> createState() => _PostTypesState();
}

class _PostTypesState extends State<PostTypesContent> {
  final moderatorController = GetIt.instance.get<ModeratorController>();

  bool doneSaved = true;
  bool isSaved = false;

  late Map<String, dynamic> postCommentOptions;

  late String communityName;
  late String textShown;

  late bool initImageState;
  late bool initPollState;
  late bool initVideoState;
  late String initTextState;

  late bool isAnyIconPressed;
  late bool isLinkOnlyIconPressed;
  late bool isTextOnlyIconPressed;

  bool isOptionsTypeVisible = false;
  bool isVideoImageVisible = true;
  bool toggleOptionsTypeVisiblity = false;

  Future<void> fetchCommunityPostComments() async {
    await moderatorController
        .getPostTypesAndOptions(moderatorController.communityName);
  }

  @override
  void initState() {
    super.initState();

    communityName = moderatorController.communityName;
    fetchCommunityPostComments();
    print(moderatorController.postTypesAndOptions["postTypes"]);
    print(moderatorController.postTypesAndOptions["allowPolls"]);
    print(moderatorController.postTypesAndOptions["allowVideo"]);
    print(moderatorController.postTypesAndOptions["allowImages"]);

    if (moderatorController.postTypesAndOptions["postTypes"] == "Any") {
      isAnyIconPressed = true;
      isLinkOnlyIconPressed = false;
      isTextOnlyIconPressed = false;
      textShown = "Any";
      trueVideoImageVisiblity();
    } else if (moderatorController.postTypesAndOptions["postTypes"] ==
        "Links Only") {
      isAnyIconPressed = false;
      isLinkOnlyIconPressed = true;
      isTextOnlyIconPressed = false;
      textShown = "Link";
      trueVideoImageVisiblity();
    } else {
      isAnyIconPressed = false;
      isLinkOnlyIconPressed = false;
      isTextOnlyIconPressed = true;
      textShown = "Text";
      falseVideoImageVisiblity();
    }
    initImageState = moderatorController.postTypesAndOptions["allowImages"];
    initPollState=moderatorController.postTypesAndOptions["allowPolls"];
    initVideoState=moderatorController.postTypesAndOptions["allowVideo"];
    initTextState = moderatorController.postTypesAndOptions["postTypes"];
  }

  void changeTextShown(String newText) {
    setState(() {
      textShown = newText;
    });
  }

  void checkInitSaveState() {
    if (textShown == initTextState &&
        initPollState ==
            moderatorController.postTypesAndOptions["allowPolls"] &&
        initVideoState ==
            moderatorController.postTypesAndOptions["allowVideo"] &&
        initImageState ==
            moderatorController.postTypesAndOptions["allowImages"]) {
      isSaved = false;
    } else {
      isSaved = true;
      doneSaved = false;
    }
  }

  void chooseAny() {
    setState(() {
      isAnyIconPressed = true;
      isLinkOnlyIconPressed = false;
      isTextOnlyIconPressed = false;
    });
    moderatorController.postTypesAndOptions["postTypes"] = "Any";
    checkInitSaveState();
  }

  void chooseLink() {
    setState(() {
      isAnyIconPressed = false;
      isLinkOnlyIconPressed = true;
      isTextOnlyIconPressed = false;
    });
    moderatorController.postTypesAndOptions["postTypes"] = "Links Only";
    checkInitSaveState();
  }

  void chooseText() {
    setState(() {
      isAnyIconPressed = false;
      isLinkOnlyIconPressed = false;
      isTextOnlyIconPressed = true;
    });
    moderatorController.postTypesAndOptions["postTypes"] = "Text Only";
    moderatorController.postTypesAndOptions["allowVideo"] = false;
    moderatorController.postTypesAndOptions["allowImages"] = false;
    checkInitSaveState();
  }

  void falseVideoImageVisiblity() {
    setState(() {
      isVideoImageVisible = false;
    });
  }

  void trueVideoImageVisiblity() {
    setState(() {
      isVideoImageVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var settingsProvider = context.read<PostSettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post Types',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              settingsProvider.setCommunityPostSetting(
                communityName: communityName,
                allowImages:
                    moderatorController.postTypesAndOptions["allowImages"],
                allowPolls:
                    moderatorController.postTypesAndOptions["allowPolls"],
                allowVideo:
                    moderatorController.postTypesAndOptions["allowVideo"],
                postTypes: moderatorController.postTypesAndOptions["postTypes"],
              );
              setState(() {
                doneSaved = true;
              });
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: (isSaved)
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
                        });
                  }
                })
            : null,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Type Options
              ListTile(
                title: const Text(
                  'Post type options',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: const Text(
                  'Choose the types of posts you allow in you community',
                  style: TextStyle(
                    color: Color.fromARGB(255, 137, 137, 137),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                trailing: SizedBox(
                  width: 50,
                  child: Row(children: [
                    Text(
                      textShown,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 137, 137, 137),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded)
                  ]),
                ),
                onTap: () {
                  setState(
                    () {
                      isOptionsTypeVisible = !isOptionsTypeVisible;
                    },
                  );
                },
              ),
              //Image Posts
              isVideoImageVisible
                  ? ListTile(
                      title: const Text(
                        'Image posts',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Allow images uploaded directly to Reddit as well as links to popular image hosting sites such as imgur',
                        style: TextStyle(
                          color: Color.fromARGB(255, 137, 137, 137),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      trailing: Switch(
                        value: moderatorController
                            .postTypesAndOptions["allowImages"],
                        onChanged: (newValue) {
                          moderatorController
                              .postTypesAndOptions["allowImages"] = newValue;
                          setState(
                            () {
                              checkInitSaveState();
                            },
                          );
                        },
                        activeTrackColor:
                            const Color.fromARGB(255, 0, 110, 200),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor:
                            const Color.fromARGB(255, 242, 242, 242),
                      ),
                      onTap: () => setState(() {
                        moderatorController.postTypesAndOptions["allowImages"] =
                            !moderatorController
                                .postTypesAndOptions["allowImages"];
                        checkInitSaveState();
                      }),
                    )
                  : const SizedBox(),
              //Video Posts
              isVideoImageVisible
                  ? ListTile(
                      title: const Text(
                        'Video posts',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Allow videos uploaded directly to Reddit',
                        style: TextStyle(
                          color: Color.fromARGB(255, 137, 137, 137),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      trailing: Switch(
                        value: moderatorController
                            .postTypesAndOptions["allowVideo"],
                        onChanged: (newValue) {
                          setState(
                            () {
                              moderatorController
                                  .postTypesAndOptions["allowVideo"] = newValue;
                              checkInitSaveState();
                            },
                          );
                        },
                        activeTrackColor:
                            const Color.fromARGB(255, 0, 110, 200),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor:
                            const Color.fromARGB(255, 242, 242, 242),
                      ),
                      onTap: () => setState(() {
                        moderatorController.postTypesAndOptions["allowVideo"] =
                            !moderatorController
                                .postTypesAndOptions["allowVideo"];
                        checkInitSaveState();
                      }),
                    )
                  : const SizedBox(),
              //Poll Posts
              ListTile(
                title: const Text(
                  'Poll Posts',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: const Text(
                  'Allow poll posts in your community',
                  style: TextStyle(
                    color: Color.fromARGB(255, 137, 137, 137),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                trailing: Switch(
                  value: moderatorController.postTypesAndOptions["allowPolls"],
                  onChanged: (newValue) {
                    setState(
                      () {
                        moderatorController.postTypesAndOptions["allowPolls"] =
                            newValue;
                        checkInitSaveState();
                      },
                    );
                  },
                  activeTrackColor: const Color.fromARGB(255, 0, 110, 200),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color.fromARGB(255, 242, 242, 242),
                ),
                onTap: () => setState(() {
                  moderatorController.postTypesAndOptions["allowPolls"] =
                      !moderatorController.postTypesAndOptions["allowPolls"];
                  checkInitSaveState();
                }),
              ),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            left: 0,
            right: 0,
            bottom: isOptionsTypeVisible ? 0 : -100,
            child: isOptionsTypeVisible
                ? GestureDetector(
                    child: OptionsWidget(
                      changeTextShown: changeTextShown,
                      chooseAny: chooseAny,
                      chooseLink: chooseLink,
                      chooseText: chooseText,
                      isAnyIconPressed: isAnyIconPressed,
                      isLinkOnlyIconPressed: isLinkOnlyIconPressed,
                      isTextOnlyIconPressed: isTextOnlyIconPressed,
                      falseVideoImageVisiblity: falseVideoImageVisiblity,
                      trueVideoImageVisibility: trueVideoImageVisiblity,
                    ),
                    onTap: () {
                      setState(() {
                        toggleOptionsTypeVisiblity =
                            !toggleOptionsTypeVisiblity;
                      });
                    })
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class OptionsWidget extends StatefulWidget {
  OptionsWidget(
      {super.key,
      required this.changeTextShown,
      required this.chooseAny,
      required this.chooseLink,
      required this.chooseText,
      required this.isAnyIconPressed,
      required this.isLinkOnlyIconPressed,
      required this.isTextOnlyIconPressed,
      required this.falseVideoImageVisiblity,
      required this.trueVideoImageVisibility});

  final Function(String) changeTextShown;
  final Function() chooseAny;
  final Function() chooseLink;
  final Function() chooseText;
  final Function() falseVideoImageVisiblity;
  bool isAnyIconPressed;
  bool isLinkOnlyIconPressed;
  bool isTextOnlyIconPressed;
  final Function() trueVideoImageVisibility;

  @override
  State<OptionsWidget> createState() => _OptionsWidgetState();
}

class _OptionsWidgetState extends State<OptionsWidget> {
  IconData anyIcon = Icons.check_circle_rounded;
  IconData linkOnlyIcon = Icons.check_circle_rounded;
  IconData textOnlyIcon = Icons.check_circle_rounded;
  String textToBeDisplayed = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListTile(
            leading: widget.isAnyIconPressed
                ? Icon(
                    anyIcon,
                    color: const Color.fromARGB(255, 0, 110, 200),
                  )
                : Container(
                    margin: const EdgeInsets.only(left: 3),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 110, 200),
                            width: 2)),
                  ),
            title: const Text(
              'Any',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Allow text, link , image and video posts',
              style: TextStyle(
                color: Color.fromARGB(255, 137, 137, 137),
                fontSize: 11,
                fontWeight: FontWeight.w300,
              ),
            ),
            onTap: () {
              setState(() {
                textToBeDisplayed = 'Any';
                widget.changeTextShown(textToBeDisplayed);
                widget.chooseAny();
                widget.trueVideoImageVisibility();
              });
            },
          ),
          ListTile(
            leading: widget.isLinkOnlyIconPressed
                ? Icon(
                    linkOnlyIcon,
                    color: const Color.fromARGB(255, 0, 110, 200),
                  )
                : Container(
                    margin: const EdgeInsets.only(left: 3),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 110, 200),
                            width: 2)),
                  ),
            title: const Text(
              'Link only',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Only allow link posts',
              style: TextStyle(
                color: Color.fromARGB(255, 137, 137, 137),
                fontSize: 11,
                fontWeight: FontWeight.w300,
              ),
            ),
            onTap: () {
              setState(() {
                textToBeDisplayed = 'Link';
                widget.changeTextShown(textToBeDisplayed);
                widget.chooseLink();
                widget.trueVideoImageVisibility();
              });
            },
          ),
          ListTile(
            leading: widget.isTextOnlyIconPressed
                ? Icon(
                    textOnlyIcon,
                    color: const Color.fromARGB(255, 0, 110, 200),
                  )
                : Container(
                    margin: const EdgeInsets.only(left: 3),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 110, 200),
                            width: 2)),
                  ),
            title: const Text(
              'Text only',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Only allow text posts',
              style: TextStyle(
                color: Color.fromARGB(255, 137, 137, 137),
                fontSize: 11,
                fontWeight: FontWeight.w300,
              ),
            ),
            onTap: () {
              setState(
                () {
                  textToBeDisplayed = 'Text';
                  widget.changeTextShown(textToBeDisplayed);
                  widget.chooseText();
                  widget.falseVideoImageVisiblity();
                },
              );
            },
          )
        ],
      ),
    );
  }
}
