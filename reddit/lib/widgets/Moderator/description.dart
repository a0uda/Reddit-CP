import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/community_item.dart';

class ModDescription extends StatefulWidget {
  const ModDescription({super.key});

  @override
  State<ModDescription> createState() => _ModDescriptionState();
}

class _ModDescriptionState extends State<ModDescription> {
  TextEditingController inputController = TextEditingController();
  final moderatorController = GetIt.instance.get<ModeratorController>();

  int maxCounter = 500;
  int remainingCharacters = 500;
  bool isSaved = false;
  bool doneSaved = true;

  late final String communityDescription;
  late final String communityID;
  late final String communityType;
  late String communityName;
  late final bool communityFlag;
  late GeneralSettings communityGeneralSettings;
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
    remainingCharacters = maxCounter;
    communityName = moderatorController.communityName;
    checkPermission();
    fetchGeneralSettings();

  }

  Future<void> fetchGeneralSettings() async {
    await moderatorController.getGeneralSettings(communityName);
    communityGeneralSettings = moderatorController.generalSettings;
  }

  void updateCharachterCounter() {
    setState(() {
      remainingCharacters = maxCounter - inputController.text.length;
      if (remainingCharacters < 0) {
        inputController.text = inputController.text.substring(0, maxCounter);
        inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: inputController.text.length),
        );
        remainingCharacters = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = context.read<ChangeGeneralSettingsProvider>();
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingPercentage = 0.1;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Description',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: (!isSaved)
                ? null
                : () async {
                    await settingsProvider.setGeneralSettings(
                      communityName: moderatorController.communityName,
                      general: GeneralSettings(
                          communityID:
                              moderatorController.generalSettings.communityID,
                          communityTitle: moderatorController
                              .generalSettings.communityTitle,
                          communityDescription: inputController.text,
                          communityType:
                              moderatorController.generalSettings.communityType,
                          nsfwFlag:
                              moderatorController.generalSettings.nsfwFlag),
                    );
                    setState(() {
                      doneSaved = true;
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
            child: Text(
              'Save',
              style: TextStyle(
                color: (isSaved)
                    ? const Color.fromARGB(255, 23, 105, 165)
                    : const Color.fromARGB(255, 162, 174, 192),
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
        leading: (screenWidth < 700)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (doneSaved) {
                    Navigator.pop(context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: const Text(
                                'Leave without saving',
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
                                    'You cannot undo this action',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 242, 242, 243),
                                          side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 242, 242, 243)),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 16,
                                              top: 16,
                                              bottom: 16),
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 108, 108, 108)),
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
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
                                          'Leave',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }
                })
            : null,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * paddingPercentage),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              children: [
                Align(
                  alignment: Alignment(0, 0),
                  child: Text(
                    'Describe your community',
                    style: TextStyle(
                      color: Color.fromARGB(255, 48, 129, 185),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: inputController,
              readOnly: !hasPermission,
              maxLines: null,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 23, 105, 165)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 23, 105, 165)),
                ),
              ),
              onChanged: ((value) {
                updateCharachterCounter();
                setState(() {
                  if (maxCounter == remainingCharacters) {
                    isSaved = false;
                    doneSaved = true;
                  } else {
                    isSaved = true;
                    doneSaved = false;
                  }
                });
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  child: Text(
                    '$remainingCharacters',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 173, 173, 173),
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
