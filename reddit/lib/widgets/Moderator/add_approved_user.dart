import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';

class AddApprovedUser extends StatefulWidget {
  const AddApprovedUser({super.key});

  @override
  State<AddApprovedUser> createState() => _AddApprovedUserState();
}

class _AddApprovedUserState extends State<AddApprovedUser> {
  bool addButtonEnable = false;
  TextEditingController userNameController = TextEditingController();
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();

  addUser() async {
    var approvedUserProvider = context.read<ApprovedUserProvider>();
    await approvedUserProvider.addApprovedUsers(
        userNameController.text, moderatorController.communityName);
    print("ALOOOOOOO");
    print(moderatorController
        .approvedUsers[moderatorController.approvedUsers.length-1]);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    //var approvedUserProvider = context.read<ApprovedUserProvider>();
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
            "Add an approved user",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: addButtonEnable
                    ? () async {
                        //ADD IN MOCK badrrrr
                        await addUser();
                      }
                    : null,
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: (addButtonEnable)
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
            const Text("Username"),
            Container(
              color: Colors.grey[200],
              child: TextField(
                cursorColor: Colors.blue,
                controller: userNameController,
                onChanged: (value) => {
                  setState(() {
                    if (value == "") {
                      addButtonEnable = false;
                    } else {
                      addButtonEnable = true;
                    }
                  }),
                },
                autofocus: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    border: InputBorder.none,
                    hintText: "username",
                    prefixText: "u/",
                    prefixStyle: TextStyle(color: Colors.black)),
              ),
            ),
            const Text(
              "This user will be able to submit content to your community",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
