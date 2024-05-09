import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/create_removal.dart';
import 'package:reddit/widgets/Moderator/removal_list.dart';

class RemovalReasons extends StatefulWidget {
  const RemovalReasons({super.key});

  @override
  State<RemovalReasons> createState() => _RemovalReasonsState();
}

class _RemovalReasonsState extends State<RemovalReasons> {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  int removalCount = 0;
  bool isEditMode = false;
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
        title: Consumer<RemovalProvider>(builder: (context, rempov, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditMode ? "Edit Reasons" : "Removal Reasons",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              isEditMode
                  ? const SizedBox()
                  : Text(
                      "${moderatorController.removalReasons.length}/50 reasons",
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    )
            ],
          );
        }),
        actions: [
          !isEditMode
              ? IconButton(
                  onPressed: () {
                    if (hasPermission) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateRemoval(),
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
                      setState(() {
                        isEditMode = false;
                      });
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
          )
        ],
      ),
      body: RemovalList(
        isEditMode: isEditMode,
      ),
    );
  }
}
