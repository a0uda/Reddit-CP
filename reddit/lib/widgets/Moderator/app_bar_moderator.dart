import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppBarModerator extends StatefulWidget {
  AppBarModerator(
      {super.key,
      required this.titleText,
      required this.isSaved,
      required this.doneSaved});

  final String titleText;
  bool isSaved;
  bool doneSaved;

  @override
  State<AppBarModerator> createState() => _AppBarModeratorState();
}

class _AppBarModeratorState extends State<AppBarModerator> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AppBar(
      title: Text(
        widget.titleText,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              widget.doneSaved = true;
            });
          },
          child: Text(
            'Save',
            style: TextStyle(
              color: (widget.isSaved)
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
                if (widget.doneSaved) {
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
    );
  }
}
