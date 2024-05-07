import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/test_files/test_communities.dart';

class EditScheduledPost extends StatefulWidget {
  final String linkUrl;
  final bool isLinkPost;
  final String postId;
  const EditScheduledPost(
      {super.key,
      required this.postId,
      this.linkUrl = "",
      this.isLinkPost = false});

  @override
  State<EditScheduledPost> createState() => _EditScheduledPostState();
}

class _EditScheduledPostState extends State<EditScheduledPost> {
  bool saveButtonEnable = false;
  TextEditingController contentController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  int selectedDays = 3;

  // addUser() async {
  //   var approvedUserProvider = context.read<ApprovedUserProvider>();
  //   await approvedUserProvider.addApprovedUsers(
  //       userNameController.text, moderatorController.communityName);
  //   Navigator.of(context).pop();
  // }
  void validateValue() {
    if (widget.isLinkPost) {
      RegExp regExp = RegExp(r'\.com\b', caseSensitive: false);
      setState(() {
        saveButtonEnable = regExp.hasMatch(contentController.text);
      });
    } else {
      setState(() {
        saveButtonEnable = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    urlController.text = widget.linkUrl;
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
                        var scheduledProvider =
                            context.read<ScheduledProvider>();
                        await scheduledProvider.EditScheduledPost(
                            moderatorController.communityName,
                            widget.postId,
                            contentController.text);
                        Navigator.of(context).pop();
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
                hintText: "Your text post (optional)",
              ),
            ),
            widget.isLinkPost? TextField(
              cursorColor: Colors.blue,
              controller: urlController,
              onChanged: (value) => {
                validateValue(),
              },
              //autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 8),
                border: InputBorder.none,
                hintText: "URL",
              ),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
