import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';

// ignore: must_be_immutable
class EditRemovalReason extends StatefulWidget {
  final String title;
  final String id;
  final String message;
  const EditRemovalReason({
    super.key,
    required this.title,
    required this.id,
    required this.message,
  });

  @override
  State<EditRemovalReason> createState() => _EditRemovalReasonState();
}

class _EditRemovalReasonState extends State<EditRemovalReason> {
  bool saveButtonEnable = false;
  final moderatorController = GetIt.instance.get<ModeratorController>();

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    messageController.text = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    var resPov = context.read<RemovalProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.xmark),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Center(
          child: Text(
            "Edit Reason",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color.fromARGB(255, 42, 101, 210),
                    surfaceTintColor: const Color.fromARGB(255, 42, 101, 210),
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent),
                onPressed: saveButtonEnable
                    ? () async {
                        //save rule
                        await resPov.editRemovalReason(
                          id: widget.id,
                          communityName: moderatorController.communityName,
                          title: titleController.text,
                          reason: messageController.text,
                        );
                        Navigator.of(context).pop();
                      }
                    : null,
                child: const Text(
                  "Update",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(color: Colors.grey),
              ),
              TextField(
                maxLength: 50,
                maxLines: null,
                cursorColor: Colors.blue,
                controller: titleController,
                onChanged: (value) => {
                  setState(() {
                    if (value == "" || messageController.text == "") {
                      saveButtonEnable = false;
                    } else {
                      saveButtonEnable = true;
                    }
                  }),
                },
                autofocus: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Reason title",
                ),
              ),
              const Text(
                "Message ",
                style: TextStyle(color: Colors.grey),
              ),
              TextField(
                minLines: 5,
                maxLength: 1000,
                maxLines: null,
                cursorColor: Colors.blue,
                controller: messageController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add description that helps users understand",
                ),
                onChanged: (value) => {
                  setState(() {
                    if (value == "" || titleController.text == "") {
                      saveButtonEnable = false;
                    } else {
                      saveButtonEnable = true;
                    }
                  }),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
