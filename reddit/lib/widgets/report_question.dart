import 'package:flutter/material.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/user_service.dart';

class Question extends StatefulWidget {
  final String? type;
  final String? postId;
  final bool isUser;
  final String Username;

  const Question(
      {super.key,
      required this.type,
      required this.postId,
      this.isUser = false,
      this.Username = ''});
  @override
  QuestionScreen createState() => QuestionScreen();
}

class QuestionScreen extends State<Question> {
  String selectedAnswer = '';
  final postService = GetIt.instance.get<PostService>();
  final userService = GetIt.instance.get<UserService>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;
    bool ismobile = (width < 700) ? true : false;
    bool isUser = widget.isUser;
    String username = widget.Username;
    return Column(
      children: [
        if (widget.type == 'Harassment')
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Who is the harassment towards?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RadioListTile<String>(
                title: const Text('you'),
                value: 'you',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Someone else'),
                value: 'someone else',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
            ],
          ),
        if (widget.type == 'Threating violence')
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Who is the threat towards?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RadioListTile<String>(
                title: const Text('you'),
                value: 'you',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Someone else'),
                value: 'someone else',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
            ],
          ),
        if (widget.type == 'Minor abuse or sexualization')
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'What type of minor abuse or sexualization is this?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RadioListTile<String>(
                title: const Text('Sexual or suggestive content'),
                value: 'sexual or suggestive content',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Predatory or inappropriate behavior'),
                value: 'Predatory or inappropriate behavior',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text(
                    'Content involving physical or emotional abuse or neglect'),
                value:
                    'Content involving physical or emotional abuse or neglect',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
            ],
          ),
        if (widget.type == 'sharing personal information')
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Whose personal information is it?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RadioListTile<String>(
                title: const Text('you'),
                value: 'you',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Someone else'),
                value: 'someone else',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
            ],
          ),
        if (widget.type == 'Spam')
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'What type of spam is it?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RadioListTile<String>(
                title: const Text('Link farming'),
                value: 'link farming',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Unsolocited messaging'),
                value: 'Unsolocited messaging',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Excessive posts or comments in a community'),
                value: 'Excessive posts or comments in a community',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Posting harmful links (malware)'),
                value: 'Posting harmful links (malware)',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Harmful bots'),
                value: 'harmful bots',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Others'),
                value: 'Others',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
            ],
          ),
        if (widget.type == 'Copyright')
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Whose copyright is it?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RadioListTile<String>(
                title: const Text(
                    'yours or an individual or entity you represent'),
                value: 'yours or an individual or entity you represent',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Someone else'),
                value: 'someone else',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
            ],
          ),
        if (widget.type == 'Non-consensual intimate media')
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Who is the non-consensual intimate media of?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RadioListTile<String>(
                title: const Text('you'),
                value: 'you',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Someone else'),
                value: 'someone else',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
            ],
          ),
        if (widget.type == 'Impersonation')
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Who is being impersonated?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RadioListTile<String>(
                title:
                    const Text('you or an individual or entity you represent'),
                value: 'you or an individual or entity you represent',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Someone else'),
                value: 'someone else',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
            ],
          ),
        if (widget.type == 'Trademark violation')
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Whose trademark is it?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              RadioListTile<String>(
                title: const Text(
                    'yours or an individual or entity you represent'),
                value: 'yours or an individual or entity you represent',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Someone else'),
                value: 'someone else',
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
              ),
            ],
          ),
        TextButton(
          onPressed: () => {
            if (selectedAnswer != "")
              {
                ///// TODO SUBMIT REPORTTT
                isUser
                    ? userService.reportUser(
                        username, widget.type! + ' ' + selectedAnswer)
                    : postService.submitReport(
                        widget.postId, widget.type! + ' ' + selectedAnswer),
                Navigator.of(context).pop(),
                if (!ismobile)
                  {
                    /// send report TODO
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
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                width: MediaQuery.of(context).size.width * 0.5,
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
                else
                  {
                    //submit report Todo
                    isUser
                        ? userService.reportUser(
                            username, widget.type! + ' ' + selectedAnswer)
                        : postService.submitReport(
                            widget.postId, widget.type! + ' ' + selectedAnswer),

                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: heigth * 0.5,
                            width: width,
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
                        })
                  }
              }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (selectedAnswer == "") {
                return Colors.grey;
              } else {
                return Colors.deepOrange;
              }
            }),
          ),
          child: const Text('submit'),
        )
      ],
    );
  }
}
