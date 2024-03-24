import 'package:flutter/material.dart';

class TabBarAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var postKarma = 1;
    var commentKarma = 0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double widgetSize =
        screenWidth < screenHeight ? screenWidth : screenHeight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(
                (1 / 50) * widgetSize), // Adjust the padding as needed
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(220, 215, 213, 213),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: (1 / 25) * widgetSize,
                          top: (1 / 25) * widgetSize,
                          left: (1 / 25) *
                              widgetSize), // Adjust the padding as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$postKarma',
                            style: TextStyle(
                              fontSize: (1 / 33) * widgetSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Post Karma',
                            style: TextStyle(
                              fontSize: 0.022 * widgetSize,
                              color: const Color.fromARGB(255, 142, 141, 141),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: (1 / 25) * widgetSize,
                          top: (1 / 25) * widgetSize,
                          left: (1 / 8) *
                              widgetSize), // Adjust the padding as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$commentKarma',
                            style: TextStyle(
                              fontSize: (1 / 33) * widgetSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Comment Karma',
                            style: TextStyle(
                              fontSize: 0.022 * widgetSize,
                              color: const Color.fromARGB(255, 142, 141, 141),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
