import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityType extends StatefulWidget {
  const CommunityType({super.key});

  @override
  State<CommunityType> createState() => _CommunityTypeState();
}

class _CommunityTypeState extends State<CommunityType> {
  String titleText = 'Public';
  String subtitleText = 'Anyone can see and participate in this community.';
  bool isSaved = false;
  bool doneSaved = true;

  Color titleTextColor = const Color.fromARGB(255, 73, 208, 96);
  Color subtitleTextColor = const Color.fromARGB(255, 100, 101, 100);

  bool communitySwitchValue = false;

  void setTitleText(String newTitleText, Color newTitleTextColor) {
    setState(() {
      titleText = newTitleText;
      titleTextColor = newTitleTextColor;
    });
  }

  void setSubtitleText(String newSubtitleText, Color newSubtitleTextColor) {
    setState(() {
      subtitleText = newSubtitleText;
      subtitleTextColor = newSubtitleTextColor;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
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
          Padding(
            padding: EdgeInsets.all(screenWidth * paddingPercentage),
            child: Column(
              children: [
                SingleThumbSlider(
                  titleText: titleText,
                  subtitleText: subtitleText,
                  setTitleText: setTitleText,
                  setSubtitleText: setSubtitleText,
                  isSaved: isSaved,
                  doneSaved: doneSaved,
                ),
                ListTile(
                  title: Text(
                    titleText,
                    style: TextStyle(
                        color: titleTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    subtitleText,
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
                      value: communitySwitchValue,
                      onChanged: (newValue) {
                        setState(
                          () {
                            communitySwitchValue = !communitySwitchValue;
                            isSaved = !isSaved;
                          },
                        );
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
  SingleThumbSlider(
      {super.key,
      required this.titleText,
      required this.subtitleText,
      required this.setTitleText,
      required this.setSubtitleText,
      required this.isSaved,
      required this.doneSaved});
  final String titleText;
  final String subtitleText;
  final Function(String text, Color color) setTitleText;
  final Function(String text, Color color) setSubtitleText;
  bool isSaved;
  bool doneSaved;

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
  double startValue = 0;
  double endValue = 100;

  Color greenColor = const Color.fromARGB(255, 73, 208, 96);
  Color yellowColor = const Color.fromARGB(255, 221, 153, 39);
  Color redColor = const Color.fromARGB(255, 253, 1, 0);
  Color greyColor = const Color.fromARGB(255, 216, 216, 216);
  Color darkGreyColor = const Color.fromARGB(255, 100, 101, 100);

  @override
  Widget build(BuildContext context) {
    double thumbRadius = (MediaQuery.of(context).size.width < 700)
        ? MediaQuery.of(context).size.width * 0.03
        : MediaQuery.of(context).size.width * 0.02;
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: getThumbColor(
            startValue), // Change thumb color based on its position
        thumbShape: _CustomThumbShape(
            thumbRadius), // Add a custom thumb shape with border
        activeTrackColor: getTrackColor(startValue),
      ),
      child: Slider(
          min: 0,
          max: 100,
          divisions: 2,
          value: startValue,
          onChanged: (newValue) {
            setState(() {
              startValue = newValue;
            });
          },
          onChangeEnd: (newValue) {
            setState(() {
              if (newValue < 25) {
                startValue = 0;
              } else if (newValue >= 25 && newValue <= 75) {
                startValue = 50;
              } else {
                startValue = 100;
              }
              adjustTitleAndSubtitleText(startValue);
              widget.isSaved = true;
            });
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
    } else if (value >= 25 && value <= 75) {
      widget.setTitleText(widget.restrictedText, yellowColor);
      widget.setSubtitleText(widget.restrictedSubtitle, darkGreyColor);
    } else {
      widget.setTitleText(widget.privateText, redColor);
      widget.setSubtitleText(widget.privateSubtitle, darkGreyColor);
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
