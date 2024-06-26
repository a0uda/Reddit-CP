import 'package:flutter/material.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/report_question.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:get_it/get_it.dart';

String selectedreport = "";

class ReportOptions extends StatefulWidget {
  final String? postId;
  bool isUser;
  String username;
  ReportOptions({
    required this.postId,
    this.isUser = false,
    this.username = '',
    super.key,
  });

  @override
  Report createState() => Report();
}

class Report extends State<ReportOptions> {
  List<String> reportOptions = [
    'Harassment',
    'Threating violence',
    'Hate',
    'Minor abuse or sexualization',
    'sharing personal information',
    'Spam',
    'Copyright',
    'Non-consensual intimate media',
    'Prohibited transaction',
    'Impersonation',
    'Self-harm or suicide',
    'Trademark violation',
  ];
  var selectedreport = "";
  final postService = GetIt.instance.get<PostService>();
  final userService = GetIt.instance.get<UserService>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;
    bool ismobile = (width < 700) ? true : false;
    bool isUser = widget.isUser;
    String username = widget.username;
    return Column(children: [
      Wrap(
        children: reportOptions.map(
          (hobby) {
            bool isSelected = false;
            if (selectedreport == hobby) {
              isSelected = true;
            }
            return InkWell(
              onTap: () {
                if (selectedreport != hobby) {
                  selectedreport = hobby;
                  setState(() {});
                } else {
                  selectedreport = "";
                  setState(() {});
                }
              },
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: isSelected
                                ? const Color.fromARGB(255, 3, 55, 146)
                                : Colors.grey,
                            width: 2)),
                    child: Text(
                      hobby,
                      style: TextStyle(
                          color: isSelected
                              ? const Color.fromARGB(255, 3, 55, 146)
                              : Colors.grey,
                          fontSize: 14),
                    ),
                  )),
            );
          },
        ).toList(),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: TextButton(
          onPressed: () => {
            if (selectedreport != "")
              if (!ismobile)
                {
                  {
                    Navigator.of(context).pop(),
                    if ((selectedreport != 'Hate') &&
                        (selectedreport != 'Self-harm or suicide') &&
                        (selectedreport != 'Prohibited transaction'))
                      {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: const Text('Submit a report'),
                              content: Builder(
                                builder: ((context) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      children: [
                                        Question(
                                          type: selectedreport,
                                          postId: widget.postId,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        )
                      }
                    else
                      {
                        /// TODO REPORT SUBMIT
                        isUser
                            ? userService.reportUser(username, selectedreport)
                            : postService.submitReport(
                                widget.postId, selectedreport),
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: const Text('Submit a report'),
                              content: Builder(
                                builder: ((context) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: const Column(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: Colors.blue,
                                          size: 30.0,
                                        ),
                                        Text('Thanks for your report'),
                                        Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text(
                                              'Thanks again for your report and for looking out for yourself and fellow redditors. Your reporting helps make reddit a better, safer, and more welcoming place for everyone; and it means alot to us '),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        )
                      }
                  }
                }
              else
                {
                  Navigator.of(context).pop(),
                  if ((selectedreport != 'Hate') &&
                      (selectedreport != 'Self-harm or suicide') &&
                      (selectedreport != 'Prohibited transaction'))
                    {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          //barrierColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24))),
                                height: heigth * 0.85,
                                width: width,
                                child: Column(children: [
                                  const ListTile(
                                    leading: Text(
                                      "Submit report",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Question(
                                    type: selectedreport,
                                    postId: widget.postId,
                                  ),
                                ]));
                          })
                    }
                  else
                    {
                      ///Todo submit report
                      isUser
                          ? userService.reportUser(username, selectedreport)
                          : postService.submitReport(
                              widget.postId, selectedreport),

                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(color: Colors.white),
                              height: heigth * 0.5,
                              width: width,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 30.0,
                                  ),
                                  Text('Thanks for your report'),
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                        'Thanks again for your report and for looking out for yourself and fellow redditors. Your reporting helps make reddit a better, safer, and more welcoming place for everyone; and it means alot to us '),
                                  )
                                ],
                              ),
                            );
                          })
                    }
                }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (selectedreport == "") {
                return Colors.grey;
              } else {
                return const Color.fromARGB(255, 3, 55, 146);
              }
            }),
          ),
          child: const Text(
            'Next',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      )
    ]);
  }
}
