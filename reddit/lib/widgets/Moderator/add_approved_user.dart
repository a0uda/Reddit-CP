import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddApprovedUser extends StatefulWidget {
  const AddApprovedUser({super.key});

  @override
  State<AddApprovedUser> createState() => _AddApprovedUserState();
}

class _AddApprovedUserState extends State<AddApprovedUser> {
  bool addButtonEnable = false;
  TextEditingController userNameController = TextEditingController();
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
            "Add an approved user",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: addButtonEnable
                    ? () {
                        //ADD IN MOCK badrrrr
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