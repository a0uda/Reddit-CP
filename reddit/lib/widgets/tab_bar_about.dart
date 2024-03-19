import 'package:flutter/material.dart';

class TabBarAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var postKarma = 1;
    var commentKarma = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
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
                      padding: const EdgeInsets.only(
                          bottom: 20,
                          top: 20,
                          left: 20), // Adjust the padding as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$postKarma',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Post Karma',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: const Color.fromARGB(255, 142, 141, 141),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20,
                          top: 20,
                          left: 60), // Adjust the padding as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$commentKarma',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Comment Karma',
                            style: TextStyle(
                              fontSize: 13.0,
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
        // Padding(
        //     padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
        //     child: Text('TROPHIES',
        //         style: TextStyle(
        //             fontSize: 12,
        //             fontWeight: FontWeight.bold,
        //             color: Color.fromARGB(255, 119, 119, 119)))),
      ],
    );
  }
}
