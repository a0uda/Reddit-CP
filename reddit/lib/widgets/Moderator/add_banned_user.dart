import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<String> rules = [
  "Rule1",
  "Rule1",
  "Rule1",
  "Rule1",
  "Rule1",
];

class AddBannedUser extends StatefulWidget {
  const AddBannedUser({super.key});

  @override
  State<AddBannedUser> createState() => _AddBannedUserState();
}

class _AddBannedUserState extends State<AddBannedUser> {
  final formKey = GlobalKey<FormState>();
  bool addButtonEnable = false;
  bool isChecked = true;
  TextEditingController userNameController = TextEditingController();
  TextEditingController banReasonController = TextEditingController(text: null);
  TextEditingController modNoteController = TextEditingController();
  TextEditingController banPeriodController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  void validateForm() {
    setState(() {
      if (userNameController.text.isEmpty ||
          banReasonController.text.isEmpty ||
          (banPeriodController.text == "" && isChecked == false)) {
        addButtonEnable = false;
      } else {
        addButtonEnable = true;
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
            "Add an banned user",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: addButtonEnable
                    ? () {
                        //add to mock Badrrrrr
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Username"),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  color: Colors.grey[200],
                  child: TextFormField(
                    cursorColor: Colors.blue,
                    controller: userNameController,
                    onChanged: (value) => {
                      validateForm(),
                    },
                    decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(top: 10, bottom: 10, left: 8),
                        prefix: Text(
                          "u/",
                          style: TextStyle(color: Colors.black),
                        ),
                        hintText: "username",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal)),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text("Reason for ban"),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () => {
                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (BuildContext context) {
                        return ModalForRules(
                          banReason: banReasonController,
                          validate: validateForm,
                        );
                      },
                    ),
                  },
                  child: Container(
                    color: Colors.grey[200],
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      controller: banReasonController,
                      enabled: false,
                      decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "Pick a reason",
                          hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                          contentPadding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 8),
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey[700],
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text("Mod note"),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  color: Colors.grey[200],
                  child: TextFormField(
                    cursorColor: Colors.blue,
                    controller: modNoteController,
                    decoration: const InputDecoration(
                        isDense: true,
                        hintText: "Only mods will see this",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(top: 10, bottom: 10, left: 8)),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text("How long?"),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      color: Colors.grey[200],
                      child: TextFormField(
                        cursorColor: Colors.blue,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly // Allow only digits
                        ],
                        controller: banPeriodController,
                        onChanged: (value) => {
                          setState(() {
                            if (value == "") {
                              isChecked = true;
                            } else {
                              isChecked = false;
                            }
                          }),
                          validateForm()
                        },
                        decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 8)),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 25),
                      child: Text("Days"),
                    ),
                    Checkbox(
                      value: isChecked,
                      activeColor: const Color.fromARGB(255, 23, 105, 165),
                      onChanged: (value) => {
                        setState(() {
                          isChecked = value!;
                        }),
                        if (value == false) {validateForm()}
                      },
                    ),
                    const Text("Permanent")
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text("Note to include in ban message"),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  color: Colors.grey[200],
                  height: 100,
                  child: TextFormField(
                    cursorColor: Colors.blue,
                    controller: noteController,
                    decoration: const InputDecoration(
                        isDense: true,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        hintText:
                            "The user will recieve this note in a message",
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(top: 10, bottom: 10, left: 8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ModalForRules extends StatelessWidget {
  final TextEditingController banReason;
  final VoidCallback validate;
  const ModalForRules(
      {super.key, required this.banReason, required this.validate});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 17, bottom: 10),
          child: Text(
            "REASON FOR BAN",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        Divider(
          color: Colors.grey[300],
          endIndent: 20,
          indent: 20,
          height: 0.5,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: rules.length,
            itemBuilder: (BuildContext context, int index) {
              final item = rules[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(item),
                    onTap: () {
                      banReason.text = item;
                      validate();
                      Navigator.of(context).pop();
                    },
                  ),
                  Divider(
                    color: Colors.grey[300],
                    height: 1,
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
