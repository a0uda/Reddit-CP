import 'package:flutter/material.dart';

class PostTypes extends StatefulWidget {
  const PostTypes({super.key});

  @override
  State<PostTypes> createState() => _PostTypesState();
}

class _PostTypesState extends State<PostTypes> {
  bool imageSwitchValue = true;
  bool videoSwitchValue = true;
  bool pollSwitchValue = true;

  bool isOptionsTypeVisible = false;
  bool toggleOptionsTypeVisiblity = false;
  String textShown = 'Any';

  bool isAnyIconPressed = true;
  bool isLinkOnlyIconPressed = false;
  bool isTextOnlyIconPressed = false;

  bool isVideoImageVisible = true;

  void changeTextShown(String newText) {
    setState(() {
      textShown = newText;
    });
  }

  void chooseAny() {
    setState(() {
      isAnyIconPressed = true;
      isLinkOnlyIconPressed = false;
      isTextOnlyIconPressed = false;
    });
  }

  void chooseLink() {
    setState(() {
      isAnyIconPressed = false;
      isLinkOnlyIconPressed = true;
      isTextOnlyIconPressed = false;
    });
  }

  void chooseText() {
    setState(() {
      isAnyIconPressed = false;
      isLinkOnlyIconPressed = false;
      isTextOnlyIconPressed = true;
    });
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
    double paddingPercentage = 0.1;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * paddingPercentage),
            // Column that contain the page consists of 4 ListTiles (Post type options, Image posts, video posts, Poll posts)
            child: Column(
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
                    // showBottomSheet(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return const OptionsWidget();
                    //     });
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
                          value: imageSwitchValue,
                          onChanged: (newValue) {
                            setState(
                              () {
                                imageSwitchValue = !imageSwitchValue;
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
                          imageSwitchValue = !imageSwitchValue;
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
                          value: videoSwitchValue,
                          onChanged: (newValue) {
                            setState(
                              () {
                                videoSwitchValue = !videoSwitchValue;
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
                          videoSwitchValue = !videoSwitchValue;
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
                    value: pollSwitchValue,
                    onChanged: (newValue) {
                      setState(
                        () {
                          pollSwitchValue = !pollSwitchValue;
                        },
                      );
                    },
                    activeTrackColor: const Color.fromARGB(255, 0, 110, 200),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor:
                        const Color.fromARGB(255, 242, 242, 242),
                  ),
                  onTap: () => setState(() {
                    pollSwitchValue = !pollSwitchValue;
                  }),
                ),
              ],
            ),
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
  final Function() trueVideoImageVisibility;
  bool isAnyIconPressed;
  bool isLinkOnlyIconPressed;
  bool isTextOnlyIconPressed;
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
