import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';

// ignore: must_be_immutable
class AddBannedUser extends StatefulWidget {
  final bool seeDetails;
  String? username;
  bool? permanentFlag;
  String? banReason;
  String? modNote;
  String? banPeriod;
  String? banNote;

  AddBannedUser(
      {super.key,
      required this.seeDetails,
      this.username,
      this.permanentFlag,
      this.banReason,
      this.banNote,
      this.banPeriod,
      this.modNote});

  @override
  State<AddBannedUser> createState() => _AddBannedUserState();
}

class _AddBannedUserState extends State<AddBannedUser> {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  final formKey = GlobalKey<FormState>();
  bool addButtonEnable = false;
  bool permanentIsChecked = true;
  TextEditingController userNameController = TextEditingController();
  TextEditingController banReasonController = TextEditingController(text: null);
  TextEditingController modNoteController = TextEditingController();
  TextEditingController banPeriodController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  void validateForm() {
    setState(() {
      if (userNameController.text.isEmpty ||
          banReasonController.text.isEmpty ||
          (banPeriodController.text == "" && permanentIsChecked == false)) {
        addButtonEnable = false;
      } else {
        addButtonEnable = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.seeDetails) {
      userNameController.text = widget.username ?? "";
      permanentIsChecked = widget.permanentFlag!;
      banReasonController.text = widget.banReason ?? "";
      modNoteController.text = widget.modNote ?? "";
      banPeriodController.text = widget.banPeriod ?? "";
      noteController.text = widget.banNote ?? "";
    }
  }

  banUser() async {
    var bannedUserProvider = context.read<BannedUserProvider>();
    await bannedUserProvider.addBannedUsers(
      username: userNameController.text,
      communityName: moderatorController.communityName,
      permanentFlag: permanentIsChecked,
      reasonForBan: banReasonController.text,
      bannedUntil: banPeriodController.text,
      modNote: modNoteController.text,
      noteForBanMessage: noteController.text,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var bannedUserProvider = context.read<BannedUserProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.xmark),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Text(
            widget.seeDetails ? "Ban details " : "Add an banned user",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: addButtonEnable
                    ? () async {
                        //print(banPeriodController.text);
                        if (widget.seeDetails) {
                          bannedUserProvider.updateBannedUser(
                            username: userNameController.text,
                            communityName: moderatorController.communityName,
                            permanentFlag: permanentIsChecked,
                            reasonForBan: banReasonController.text,
                            bannedUntil: banPeriodController.text,
                            modNote: modNoteController.text,
                            noteForBanMessage: noteController.text,
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        } else {
                          await banUser();
                        }
                      }
                    : null,
                child: Text(
                  widget.seeDetails ? "Update " : "Add",
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
                    enabled: !widget.seeDetails,
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
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
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
                    onChanged: widget.seeDetails
                        ? (value) {
                            validateForm();
                          }
                        : null,
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
                              permanentIsChecked = true;
                            } else {
                              permanentIsChecked = false;
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
                      value: permanentIsChecked,
                      activeColor: const Color.fromARGB(255, 23, 105, 165),
                      onChanged: (value) => {
                        setState(() {
                          permanentIsChecked = value!;
                          if (value == true) {
                            banPeriodController.text = "";
                          }
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
                    onChanged: widget.seeDetails
                        ? (value) {
                            validateForm();
                          }
                        : null,
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
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  final TextEditingController banReason;
  final VoidCallback validate;
  ModalForRules({super.key, required this.banReason, required this.validate});

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
        ListTile(
          title: const Text("Spam"),
          onTap: () {
            banReason.text = "Spam";
            validate();
            Navigator.of(context).pop();
          },
        ),
        Divider(
          color: Colors.grey[300],
          height: 1,
        ),
        ListTile(
          title: const Text("Personal information"),
          onTap: () {
            banReason.text = "Personal information";
            validate();
            Navigator.of(context).pop();
          },
        ),
        Divider(
          color: Colors.grey[300],
          height: 1,
        ),
        ListTile(
          title: const Text("Threatening"),
          onTap: () {
            banReason.text = "Threatening";
            validate();
            Navigator.of(context).pop();
          },
        ),
        Divider(
          color: Colors.grey[300],
          height: 1,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: moderatorController.rules.length,
            itemBuilder: (BuildContext context, int index) {
              final item = moderatorController.rules[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(item.ruleTitle),
                    onTap: () {
                      banReason.text = item.ruleTitle;
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
