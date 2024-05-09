import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/create_rule_page.dart';
import 'package:reddit/widgets/Moderator/mod_rules_list.dart';

class ModRules extends StatefulWidget {
  const ModRules({super.key});

  @override
  State<ModRules> createState() => _ModRulesState();
}

class _ModRulesState extends State<ModRules> {
  bool isEditMode = false;
  final moderatorController = GetIt.instance.get<ModeratorController>();

  late bool hasPermission;

  void checkPermission() {
    if (moderatorController.modAccess.everything ||
        moderatorController.modAccess.manageSettings) {
      hasPermission = true;
    } else {
      hasPermission = false;
    }
  }

  @override
  void initState() {
    super.initState();
    isEditMode = false;
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey,
        leading: isEditMode ? const SizedBox() : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? "EditRules" : "Rules",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          !isEditMode
              ? IconButton(
                  onPressed: () {
                    if (hasPermission) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateRulePage(),
                        ),
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: const Text(
                                  'You do not have permission to change this setting',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: const Text(
                                      'Please contact the owner of the community for more information',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 37, 79, 165),
                                        side: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 37, 79, 165)),
                                        padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 16,
                                            top: 16,
                                            bottom: 16),
                                      ),
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }
                  },
                  icon: const Icon(Icons.add))
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: !isEditMode
                ? IconButton(
                    onPressed: () {
                      //change to edit mode badrr
                      if (hasPermission) {
                        setState(() {
                          isEditMode = true;
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: const Text(
                                    'You do not have permission to change this setting',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: const Text(
                                        'Please contact the owner of the community for more information',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 37, 79, 165),
                                          side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 37, 79, 165)),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 16,
                                              top: 16,
                                              bottom: 16),
                                        ),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      }
                    },
                    icon: const Icon(Icons.edit))
                : TextButton(
                    onPressed: () {
                      //out of edit mode
                      if (hasPermission) {
                        setState(() {
                          isEditMode = false;
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: const Text(
                                    'You do not have permission to change this setting',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: const Text(
                                        'Please contact the owner of the community for more information',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 37, 79, 165),
                                          side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 37, 79, 165)),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 16,
                                              top: 16,
                                              bottom: 16),
                                        ),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      }
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
          )
        ],
      ),
      body: ModRulesList(
        isEditMode: isEditMode,
      ),
    );
  }
}
