import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/community_item.dart';

class CommunityType extends StatefulWidget {
  const CommunityType({super.key});

  @override
  State<CommunityType> createState() => _CommunityTypeState();
}

class _CommunityTypeState extends State<CommunityType> {
  bool isSaved = false;
  bool doneSaved = true;

  final moderatorController = GetIt.instance.get<ModeratorController>();

  late String currentCommunityType;
  late String currentCommunityTypeSubtitle;

  late String communityName;

  late String initCommunityType;
  late final bool initCommunityFlag;

  late bool hasPermission;

  void checkPermission() {
    if (moderatorController.modAccess.everything &&
        moderatorController.modAccess.manageSettings) {
      hasPermission = true;
    } else {
      hasPermission = false;
    }
  }

  String publicSubtitle = 'Anyone can see and participate in this community.';
  String restrictedSubtitle =
      'Anyone can see, join or vote in this community, but you control who posts and comments.';
  String privateSubtitle =
      'Only people you approve can see and participate in this community.';

  late Color titleTextColor;
  Color subtitleTextColor = const Color.fromARGB(255, 100, 101, 100);

  @override
  void initState() {
    super.initState();

    currentCommunityType = moderatorController.generalSettings.communityType;
    if (currentCommunityType == "Public") {
      currentCommunityTypeSubtitle = publicSubtitle;
      titleTextColor = const Color.fromARGB(255, 73, 208, 96);
    } else if (currentCommunityType == "Restricted") {
      currentCommunityTypeSubtitle = restrictedSubtitle;
      titleTextColor = const Color.fromARGB(255, 221, 153, 39);
    } else {
      currentCommunityTypeSubtitle = privateSubtitle;
      titleTextColor = const Color.fromARGB(255, 253, 1, 0);
    }
    fetchGeneralSettings();

    communityName = moderatorController.communityName;

    initCommunityType = moderatorController.generalSettings.communityType;
    initCommunityFlag = moderatorController.generalSettings.nsfwFlag;

    checkPermission();
  }

  Future<void> fetchGeneralSettings() async {
    await moderatorController.getGeneralSettings(communityName);
  }

  void setTitleText(String newTitleText, Color newTitleTextColor) {
    setState(() {
      currentCommunityType = newTitleText;
      titleTextColor = newTitleTextColor;
    });
  }

  void setSubtitleText(String newSubtitleText, Color newSubtitleTextColor) {
    setState(() {
      currentCommunityTypeSubtitle = newSubtitleText;
      subtitleTextColor = newSubtitleTextColor;
    });
  }

  void setSaved(String newCommunityType) {
    isSaved = true;
    moderatorController.generalSettings.communityType = newCommunityType;
    checkInitState();
  }

  void checkInitState() {
    if (moderatorController.generalSettings.communityType ==
            initCommunityType &&
        moderatorController.generalSettings.nsfwFlag == initCommunityFlag) {
      isSaved = false;
    } else {
      isSaved = true;
      doneSaved = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = context.read<ChangeGeneralSettingsProvider>();

    double screenWidth = MediaQuery.of(context).size.width;
    double paddingPercentage = 0.1;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community Type',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: (!isSaved)
                ? null
                : () async {
                    await settingsProvider.setGeneralSettings(
                      communityName: moderatorController.communityName,
                      general: GeneralSettings(
                          communityID:
                              moderatorController.generalSettings.communityID,
                          communityTitle: moderatorController
                              .generalSettings.communityTitle,
                          communityDescription: moderatorController
                              .generalSettings.communityDescription,
                          communityType:
                              moderatorController.generalSettings.communityType,
                          nsfwFlag:
                              moderatorController.generalSettings.nsfwFlag),
                    );
                    setState(() {
                      doneSaved = true;
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
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
          Padding(
            padding: EdgeInsets.all(screenWidth * paddingPercentage),
            child: Column(
              children: [
                SingleThumbSlider(
                  titleText: currentCommunityType,
                  subtitleText: currentCommunityTypeSubtitle,
                  setTitleText: setTitleText,
                  setSubtitleText: setSubtitleText,
                  isSavedFunction: setSaved,
                ),
                ListTile(
                  title: Text(
                    currentCommunityType,
                    style: TextStyle(
                        color: titleTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    currentCommunityTypeSubtitle,
                    style: TextStyle(color: subtitleTextColor, fontSize: 14),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Divider(
                    height: 1,
                    color: Color.fromARGB(255, 236, 237, 237),
                    thickness: 1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '18+ community',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Switch(
                      value: moderatorController.generalSettings.nsfwFlag,
                      onChanged: (newValue) {
                        if (hasPermission) {
                          moderatorController.generalSettings.nsfwFlag =
                              newValue;
                          setState(() {
                            if (moderatorController.generalSettings.nsfwFlag !=
                                initCommunityFlag) {}
                          });
                          checkInitState();
                        } else {
                          moderatorController.generalSettings.nsfwFlag =
                              initCommunityFlag;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: const Text(
                                      'You do not have permission to change this setting',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: const Text(
                                          'Please contact the owner of the community for more information',
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
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
                                            'OK',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        }
                      },
                      activeTrackColor: const Color.fromARGB(255, 0, 110, 200),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor:
                          const Color.fromARGB(255, 242, 242, 242),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SingleThumbSlider extends StatefulWidget {
  SingleThumbSlider({
    super.key,
    required this.titleText,
    required this.subtitleText,
    required this.setTitleText,
    required this.setSubtitleText,
    required this.isSavedFunction,
  });
  final String titleText;
  final String subtitleText;
  final Function(String text, Color color) setTitleText;
  final Function(String text, Color color) setSubtitleText;
  final Function(String) isSavedFunction;

  String publicText = 'Public';
  String restrictedText = 'Restricted';
  String privateText = 'Private';

  String publicSubtitle = 'Anyone can see and participate in this community.';
  String restrictedSubtitle =
      'Anyone can see, join or vote in this community, but you control who posts and comments.';
  String privateSubtitle =
      'Only people you approve can see and participate in this community.';

  @override
  State<SingleThumbSlider> createState() => _SingleThumbSliderState();
}

class _SingleThumbSliderState extends State<SingleThumbSlider> {
  final moderatorController = GetIt.instance.get<ModeratorController>();
  late double startValue;
  double endValue = 100;

  late String newCommnuityType;

  Color greenColor = const Color.fromARGB(255, 73, 208, 96);
  Color yellowColor = const Color.fromARGB(255, 221, 153, 39);
  Color redColor = const Color.fromARGB(255, 253, 1, 0);
  Color greyColor = const Color.fromARGB(255, 216, 216, 216);
  Color darkGreyColor = const Color.fromARGB(255, 100, 101, 100);

  late bool hasPermission;

  void checkPermission() {
    if (moderatorController.modAccess.everything &&
        moderatorController.modAccess.manageSettings) {
      hasPermission = true;
    } else {
      hasPermission = false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.titleText == widget.publicText) {
      startValue = 0;
    } else if (widget.titleText == widget.restrictedText) {
      startValue = 50;
    } else if (widget.titleText == widget.privateText) {
      startValue = 100;
    }
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    double thumbRadius = (MediaQuery.of(context).size.width < 700)
        ? MediaQuery.of(context).size.width * 0.03
        : MediaQuery.of(context).size.width * 0.02;
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: getThumbColor(startValue),
        thumbShape: _CustomThumbShape(thumbRadius),
        activeTrackColor: getTrackColor(startValue),
      ),
      child: Slider(
          min: 0,
          max: 100,
          divisions: 2,
          value: startValue,
          onChanged: (newValue) {
            if (hasPermission) {
              setState(() {
                startValue = newValue;
              });
            } else {
              setState(() {
                startValue = startValue;
              });
            }
          },
          onChangeEnd: (newValue) {
            if (hasPermission) {
              setState(() {
                if (newValue < 25) {
                  startValue = 0;
                } else if (newValue >= 25 && newValue <= 75) {
                  startValue = 50;
                } else {
                  startValue = 100;
                }
                adjustTitleAndSubtitleText(startValue);
              });
            }
            widget.isSavedFunction(newCommnuityType);
          }),
    );
  }

  Color getThumbColor(double value) {
    if (value <= 25) {
      return greenColor;
    } else if (value <= 75) {
      return yellowColor;
    } else {
      return redColor;
    }
  }

  Color getTrackColor(double value) {
    if (value <= 50) {
      return yellowColor;
    } else if (value <= 75) {
      return yellowColor;
    } else {
      return redColor;
    }
  }

  void adjustTitleAndSubtitleText(double value) {
    if (value < 25) {
      widget.setTitleText(widget.publicText, greenColor);
      widget.setSubtitleText(widget.publicSubtitle, darkGreyColor);
      newCommnuityType = "Public";
    } else if (value >= 25 && value <= 75) {
      widget.setTitleText(widget.restrictedText, yellowColor);
      widget.setSubtitleText(widget.restrictedSubtitle, darkGreyColor);
      newCommnuityType = "Restricted";
    } else {
      widget.setTitleText(widget.privateText, redColor);
      widget.setSubtitleText(widget.privateSubtitle, darkGreyColor);
      newCommnuityType = "Private";
    }
  }
}

class _CustomThumbShape extends SliderComponentShape {
  final double radius;

  _CustomThumbShape(this.radius);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius * 0.05);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double>? activationAnimation,
      Animation<double>? enableAnimation,
      bool? isDiscrete,
      TextPainter? labelPainter,
      RenderBox? parentBox,
      SliderThemeData? sliderTheme,
      TextDirection? textDirection,
      double? value,
      double? textScaleFactor,
      Size? sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final paint = Paint()
      ..color = sliderTheme!.thumbColor!
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, borderPaint);
  }
}
