import 'package:flutter/material.dart';
import 'package:reddit/test_files/test_communities.dart';
import 'package:reddit/widgets/Moderator/create_rule_page.dart';
import 'package:reddit/widgets/Moderator/edit_rule_page.dart';
import 'package:reddit/widgets/Moderator/mod_rules.dart';

class ModRulesList extends StatefulWidget {
  final bool isEditMode;
  const ModRulesList({super.key, required this.isEditMode});

  @override
  State<ModRulesList> createState() => _ModRulesListState();
}

class _ModRulesListState extends State<ModRulesList> {
  bool isEditing = false;
  @override
  void initState() {
    super.initState();
    isEditing = widget.isEditMode;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 700) {
      isEditing = widget.isEditMode;
    }
    return Column(
      children: [
        (screenWidth > 700)
            ? AppBar(
                title: Text(
                  isEditing ? "EditRules" : 'Rules',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                      child: Text(
                        isEditing ? "Done" : "Delete",
                        style: TextStyle(
                            color: isEditing
                                ? Colors.black
                                : const Color.fromARGB(255, 42, 101, 210),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    !isEditing
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                      const Color.fromARGB(255, 42, 101, 210)),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateRulePage(),
                                  ),
                                );
                              }, // add rule Badrrr ele hya add
                              child: const Text(
                                "Add rule",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ])
            : const SizedBox(),
        Expanded(
          child: ListView.builder(
            itemCount: rules.length,
            itemBuilder: (BuildContext context, int index) {
              final item = rules[index];
              return Column(
                children: [
                  ListTile(
                    tileColor: Colors.white,
                    leading: !isEditing ? Text("${index+1}") : null,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.ruleTitle!.length > 45
                              ? "${item.ruleTitle!.substring(0, 45)}..."
                              : item.ruleTitle!,
                        ),
                        item.ruleDescription != null
                            ? Text(
                                item.ruleDescription!.length > 130
                                    ? "${item.ruleDescription!.substring(0, 130)}..."
                                    : item.ruleDescription!,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 10),
                              )
                            : const SizedBox()
                      ],
                    ),
                    trailing: isEditing
                        ? IconButton(
                            onPressed: () {
                              //delete rule badrrr
                            },
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            ))
                        : const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: isEditing
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditRulePage(
                                  ruleTitle: item.ruleTitle!,
                                  ruleDescription: item.ruleDescription,
                                  appliesToOption: "posts",
                                ),
                              ),
                            );
                          },
                  ),
                  const Divider(
                    color: Colors.grey,
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
