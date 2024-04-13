import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddModerator extends StatefulWidget {
  const AddModerator({super.key});

  @override
  State<AddModerator> createState() => _AddModeratorState();
}

class _AddModeratorState extends State<AddModerator> {
  bool inviteButtonEnable = false;
  bool fullPermissions = true,
      manageUsers = true,
      managePostAndComments = true,
      manageSettings = true;
  TextEditingController userNameController = TextEditingController();
  void enableInvite() {
    setState(() {
      if (userNameController.text == "" ||
          (!manageUsers && !managePostAndComments && !manageSettings)) {
        inviteButtonEnable = false;
      } else {
        inviteButtonEnable = true;
      }
    });
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
            "Add an moderator",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: inviteButtonEnable
                    ? () {
                        //Send invite IN MOCK badrrrr
                      }
                    : null,
                child: Text(
                  "Invite",
                  style: TextStyle(
                    color: (inviteButtonEnable)
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
                onChanged: (value) => {enableInvite()},
                autofocus: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    border: InputBorder.none,
                    hintText: "username",
                    prefixText: "u/",
                    prefixStyle: TextStyle(color: Colors.black)),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text("Permisions"),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Checkbox(
                  value: fullPermissions,
                  onChanged: (value) {
                    setState(() {
                      if (!value!) {
                        fullPermissions = false;
                      } else {
                        fullPermissions = true;
                        managePostAndComments = true;
                        manageUsers = true;
                        manageSettings = true;
                      }
                    });
                    enableInvite();
                  },
                  activeColor: const Color.fromARGB(255, 23, 105, 165),
                ),
                const Text("Full permissions"),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey[300],
              height: 0.5,
              endIndent: 20,
              indent: 20,
            ),
            Row(
              children: [
                Checkbox(
                  value: manageUsers,
                  onChanged: (value) {
                    setState(() {
                      if (!value!) {
                        fullPermissions = false;
                        manageUsers = false;
                      } else {
                        manageUsers = true;
                        if (manageSettings && managePostAndComments) {
                          fullPermissions = true;
                        }
                      }
                    });
                    enableInvite();
                  },
                  activeColor: const Color.fromARGB(255, 23, 105, 165),
                ),
                const Text("Manage Users"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: managePostAndComments,
                  onChanged: (value) {
                    setState(() {
                      if (!value!) {
                        managePostAndComments = false;
                        fullPermissions = false;
                      } else {
                        managePostAndComments = true;
                        if (manageUsers && manageSettings) {
                          fullPermissions = true;
                        }
                      }
                    });
                    enableInvite();
                  },
                  activeColor: const Color.fromARGB(255, 23, 105, 165),
                ),
                const Text("Manage Posts and Comments"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: manageSettings,
                  onChanged: (value) {
                    setState(() {
                      if (!value!) {
                        manageSettings = false;
                        fullPermissions = false;
                      } else {
                        manageSettings = true;
                        if (manageUsers && managePostAndComments) {
                          fullPermissions = true;
                        }
                      }
                    });
                    enableInvite();
                  },
                  activeColor: const Color.fromARGB(255, 23, 105, 165),
                ),
                const Text("Manage Settings"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
