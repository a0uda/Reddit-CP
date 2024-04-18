import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';

class CreateRulePage extends StatefulWidget {
  const CreateRulePage({super.key});

  @override
  State<CreateRulePage> createState() => _CreateRulePageState();
}

class _CreateRulePageState extends State<CreateRulePage> {
  final moderatorController = GetIt.instance.get<ModeratorController>();

  bool saveButtonEnable = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descritionController = TextEditingController();
  TextEditingController reportReasonController = TextEditingController();
  String selectedOption = 'Post and comments';

  @override
  Widget build(BuildContext context) {
    var rulesProvider = context.read<RulesProvider>();

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
            "Create a rule",
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
                    ? () {
                        //save rule
                        rulesProvider.createRules(
                          id: Random().nextInt(100000).toString(),
                          communityName: moderatorController.communityName,
                          ruleTitle: titleController.text,
                          appliesTo: selectedOption,
                          reportReason: reportReasonController.text,
                          ruleDescription: descritionController.text,
                        );
                        Navigator.of(context).pop();
                      }
                    : null,
                child: const Text(
                  "Save",
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
                maxLength: 100,
                maxLines: null,
                cursorColor: Colors.blue,
                controller: titleController,
                onChanged: (value) => {
                  setState(() {
                    if (value == "") {
                      saveButtonEnable = false;
                    } else {
                      saveButtonEnable = true;
                    }
                  }),
                },
                autofocus: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Rule title",
                ),
              ),
              const Text(
                "Descrition ",
                style: TextStyle(color: Colors.grey),
              ),
              TextField(
                minLines: 5,
                maxLength: 500,
                maxLines: null,
                cursorColor: Colors.blue,
                controller: descritionController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Rule description",
                ),
              ),
              const Text(
                "Report Reason ",
                style: TextStyle(color: Colors.grey),
              ),
              TextField(
                maxLength: 100,
                maxLines: null,
                cursorColor: Colors.blue,
                controller: reportReasonController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Report reason text",
                ),
              ),
              const Text(
                "Report reason applies to:",
                style: TextStyle(color: Colors.grey),
              ),
              RadioListTile<String>(
                activeColor: const Color.fromARGB(255, 42, 101, 210),
                title: const Text("Post and comments"),
                value: 'Post and comments',
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value!;
                  });
                },
              ),
              RadioListTile<String>(
                activeColor: const Color.fromARGB(255, 42, 101, 210),
                title: const Text('Only comments'),
                value: 'comments',
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value!;
                  });
                },
              ),
              RadioListTile<String>(
                activeColor: const Color.fromARGB(255, 42, 101, 210),
                title: const Text('Only posts'),
                value: 'posts', //Badrrr
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
