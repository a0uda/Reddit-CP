import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';

class EditScheduledPost extends StatefulWidget {
  const EditScheduledPost({super.key});

  @override
  State<EditScheduledPost> createState() => _EditScheduledPostState();
}

class _EditScheduledPostState extends State<EditScheduledPost> {
  bool saveButtonEnable = false;
  TextEditingController contentController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  bool isTextPost = false;
  bool isPollPost = true;
  bool isLinkPost = false;
  int selectedDays = 3;
  List<String> options = ['', ''];

  // addUser() async {
  //   var approvedUserProvider = context.read<ApprovedUserProvider>();
  //   await approvedUserProvider.addApprovedUsers(
  //       userNameController.text, moderatorController.communityName);
  //   Navigator.of(context).pop();
  // }
  void validateValue() {
    if (isTextPost) {
      setState(() {
        saveButtonEnable = true;
      });
    } else if (isLinkPost) {
      RegExp regExp = RegExp(r'\.com\b', caseSensitive: false);
      setState(() {
        saveButtonEnable = regExp.hasMatch(contentController.text);
      });
    } else if (isPollPost) {
      saveButtonEnable = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.xmark),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Center(
          child: Text(
            "Edit post",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: saveButtonEnable
                    ? () async {
                        //edit  badrrrr
                      }
                    : null,
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: (saveButtonEnable)
                        ? const Color.fromARGB(255, 23, 105, 165)
                        : const Color.fromARGB(255, 162, 174, 192),
                  ),
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              cursorColor: Colors.blue,
              controller: contentController,
              onChanged: (value) => {
                validateValue(),
              },
              //autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 8),
                border: InputBorder.none,
                hintText: isLinkPost ? "URL" : "Your text post (optional)",
              ),
            ),
            isPollPost
                ? Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Row(children: [
                          const Text(
                            'Poll ends in ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          DropdownButton<int>(
                            value: selectedDays,
                            items: [1, 2, 3, 4, 5].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value days'),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => selectedDays = value!),
                          ),
                        ]),
                        TextField(
                          controller: questionController,
                          decoration:
                              const InputDecoration(labelText: 'Question'),
                        ),
                        TextField(
                          onChanged: (value) => options[0] = value,
                          decoration:
                              const InputDecoration(labelText: 'Option 1'),
                        ),
                        TextField(
                          onChanged: (value) => options[1] = value,
                          decoration:
                              const InputDecoration(labelText: 'Option 2'),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
