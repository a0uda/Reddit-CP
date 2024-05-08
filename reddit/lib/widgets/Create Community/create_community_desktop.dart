import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/moderator_item.dart';
import 'package:reddit/widgets/Community/community_responsive.dart';
import 'package:reddit/widgets/Community/desktop_community_page.dart';
import 'package:reddit/widgets/Community/mobile_community_page.dart';
import 'package:reddit/widgets/best_listing.dart';

class CreateCommunityPopup extends StatefulWidget {
  const CreateCommunityPopup({super.key});

  @override
  State<CreateCommunityPopup> createState() => _CreateCommunityPopupState();
}

class _CreateCommunityPopupState extends State<CreateCommunityPopup> {
  TextEditingController inputController = TextEditingController();
  final moderatorController = GetIt.instance.get<ModeratorController>();
  final UserController userController = GetIt.instance.get<UserController>();

  int maxCounter = 21;
  int remainingCharacters = 21;
  int minCounter = 3;

  bool isViolated = false;
  bool notAvailable = false;
  bool startedTyping = false;
  bool showClearButton = false;
  bool isFinished = false;

  bool initCommunityFlag = false;

  String chosenCommunityType = 'Public';
  String chosenCommunityTypeSubtitle =
      'Anyone can view, post and comment to this community';

  String publicTitle = 'Public';
  String restrictedTitle = 'Restricted';
  String privateTitle = 'Private';

  String publicSubtitle = 'Anyone can view, post and comment to this community';
  String restrictedSubtitle =
      'Anyone can view this community, but only approved users can post';
  String privateSubtitle =
      'Only approved users can view and submit to this community';

  Future<void> fetchCommunityNames() async {
    //to be implemented to check on community names
  }

  final RegExp _regex = RegExp(r'^[a-zA-Z0-9_]*$');

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

  bool isInputValid(String input) {
    return _regex.hasMatch(input);
  }

  void checkViolation() {
    if (inputController.text.isNotEmpty &&
        !isInputValid(inputController.text)) {
      setState(() {
        isViolated = true;
      });
    } else if (inputController.text.length < 3 &&
        inputController.text.isNotEmpty) {
      setState(() {
        isViolated = true;
      });
    } else {
      setState(() {
        isViolated = false;
      });
    }
  }

  void checkTyping() {
    if (inputController.text.isEmpty || remainingCharacters == 21) {
      setState(() {
        startedTyping = false;
      });
    } else {
      startedTyping = true;
    }
  }

  void checkIfFinished() {
    if (inputController.text.isNotEmpty && !isViolated) {
      setState(() {
        isFinished = true;
      });
    } else {
      setState(() {
        isFinished = false;
      });
    }
  }

  Future<void> checkAvailibleName() async {
    var createCommunityProvider = context.read<CreateCommunityProvider>();
    var addProfilePictuireProvider = context.read<UpdateProfilePicture>();
    var communityProvider = context.read<CommunityProvider>();
    int validation = await createCommunityProvider.createCommuntiy(
        communityName: inputController.text,
        communityType: chosenCommunityType,
        communityFlag: initCommunityFlag);
    if (validation == 400) {
      setState(() {
        notAvailable = true;
      });
    } else {
      notAvailable = false;
      addProfilePictuireProvider.updateProfilePicture(
          communityName: inputController.text,
          pictureUrl: "https://avatars.githubusercontent.com/u/95462348");
      // ignore: use_build_context_synchronously
      moderatorController.modAccess = ModeratorItem(
          everything: true,
          managePostsAndComments: true,
          manageSettings: true,
          manageUsers: true,
          username: userController.userAbout!.username);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => (CommunityLayout(
            desktopLayout: DesktopCommunityPage(
                isMod: true, communityName: inputController.text),
            mobileLayout: MobileCommunityPage(
              isMod: true,
              communityName: inputController.text,
            ),
          )),
        ),
      );
      communityProvider.getUserModerated();
      communityProvider.getUserCommunities();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: screenWidth < 700 ? screenWidth * 0.9 : 700,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: const Text(
                  'Community name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 243, 243),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4, left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'r/',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Color.fromARGB(255, 124, 129, 128)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: inputController,
                              maxLines: null,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0,
                              ),
                              cursorColor:
                                  const Color.fromARGB(255, 39, 79, 164),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: ((value) {
                                notAvailable = false;
                                updateCharachterCounter();
                                checkViolation();
                                checkTyping();
                                checkIfFinished();
                                showClearButton = value.isNotEmpty;
                              }),
                            ),
                          ),
                          Text(
                            '$remainingCharacters',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 173, 173, 173),
                              fontSize: 15,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          startedTyping
                              ? AnimatedOpacity(
                                  opacity: showClearButton ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 10000),
                                  child: CupertinoButton(
                                    onPressed: () {
                                      setState(() {
                                        inputController.clear();
                                        startedTyping = false;
                                        updateCharachterCounter();
                                        checkViolation();
                                        checkTyping();
                                        checkIfFinished();
                                      });
                                    },
                                    child: const Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      size: 18,
                                      color: Color.fromARGB(255, 117, 117, 117),
                                    ),
                                  ),
                                )
                              : const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isViolated
                  ? const Text(
                      'Community names must be between 3-21 characters, and can only contain letters, numbers, or underscores.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 101, 101, 101),
                        fontSize: 12,
                      ),
                    )
                  : notAvailable
                      ? Text(
                          "Sorry, ${inputController.text} is taken. Try another.",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 0, 0),
                            fontSize: 12,
                          ),
                        )
                      : const SizedBox(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: const Text(
                  'Community type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Text(
                      chosenCommunityType,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      size: 24,
                      color: Color.fromARGB(255, 117, 117, 117),
                    ),
                  ],
                ),
                subtitle: Text(
                  chosenCommunityTypeSubtitle,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 117, 117, 117),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 209, 212, 217),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Community Type',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            ListTile(
                              title: Text(
                                publicTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              subtitle: Text(
                                publicSubtitle,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 117, 117, 117),
                                  fontSize: 13,
                                ),
                              ),
                              leading: const Icon(
                                CupertinoIcons.person_crop_circle,
                              ),
                              onTap: () {
                                setState(() {
                                  chosenCommunityType = publicTitle;
                                  chosenCommunityTypeSubtitle = publicSubtitle;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text(
                                restrictedTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              subtitle: Text(
                                restrictedSubtitle,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 117, 117, 117),
                                  fontSize: 13,
                                ),
                              ),
                              leading: const Icon(
                                CupertinoIcons.checkmark_alt_circle,
                              ),
                              onTap: () {
                                setState(() {
                                  chosenCommunityType = restrictedTitle;
                                  chosenCommunityTypeSubtitle =
                                      restrictedSubtitle;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: Text(
                                privateTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              subtitle: Text(
                                privateSubtitle,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 117, 117, 117),
                                  fontSize: 13,
                                ),
                              ),
                              leading: const Icon(CupertinoIcons.lock),
                              onTap: () {
                                setState(() {
                                  chosenCommunityType = privateTitle;
                                  chosenCommunityTypeSubtitle = privateSubtitle;
                                });
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '18+ community',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Switch(
                    value: initCommunityFlag,
                    onChanged: (newValue) {
                      setState(() {
                        initCommunityFlag = newValue;
                      });
                    },
                    activeTrackColor: const Color.fromARGB(255, 0, 110, 200),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor:
                        const Color.fromARGB(255, 242, 242, 242),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (isViolated || inputController.text.isEmpty)
                          ? null
                          : () async {
                              await checkAvailibleName();
                            },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isFinished
                            ? const Color.fromARGB(255, 0, 110, 200)
                            : const Color.fromARGB(255, 243, 243, 243),
                        side: const BorderSide(color: Colors.transparent),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Create community',
                        style: TextStyle(
                          color: isFinished
                              ? Colors.white
                              : const Color.fromARGB(255, 211, 211, 211),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
