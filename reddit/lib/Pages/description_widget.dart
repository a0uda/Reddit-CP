import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Pages/profile_screen.dart';
import 'package:reddit/Services/user_service.dart';

class DescriptionWidget extends StatefulWidget {
  const DescriptionWidget({
    super.key,
    required this.communityName,
  });

  final String communityName;
  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  final moderatorController = GetIt.instance.get<ModeratorController>();

  String communityDescription = '';
  late final String communityID;
  late final String communityType;
  late String communityTitle;
  late final bool communityFlag;
  late GeneralSettings communityGeneralSettings;

  bool rulesFetched = false;
  bool generalSettingsFetched = false;
  bool membersFetched = false;
  bool communityInfoFetched = false;
  bool userFetched = false;

  Future<void> fetchModerators() async {
    if (!userFetched) {
      await moderatorController.getModerators(widget.communityName);
      userFetched = true;
    }
  }
  //   Future<void> fetchModerators() async {
  //   if (!userFetched) {
  //     await moderatorController
  //         .getModerators(moderatorController.communityName);
  //     startIndex = moderatorController.moderators.indexWhere(
  //         (mod) => mod["username"] == userController.userAbout?.username);
  //     //print(moderatorController.moderators);
  //     editableMods = startIndex! >= 0
  //         ? moderatorController.moderators.sublist(startIndex!)
  //         : [];
  //     usernameController.text = "";
  //     setState(() {
  //       foundUsers = moderatorController.moderators;
  //       foundeditableUsers = editableMods;
  //       userFetched = true;
  //     });
  //   }
  // }

  Future<void> fetchGeneralSettings() async {
    if (!generalSettingsFetched) {
      await moderatorController.getGeneralSettings(widget.communityName);
      communityGeneralSettings = moderatorController.generalSettings;
    }
  }

  Future<void> fetchRules() async {
    if (!rulesFetched) {
      await moderatorController.getRules(widget.communityName);
      rulesFetched = true;
    }
  }

  Future<void> fetchMembersCount() async {
    if (!membersFetched) {
      await moderatorController.getMembersCount(widget.communityName);
      membersFetched = true;
      //print(moderatorController.membersCount);
    }
  }

  Future<void> fetchCommunityInfo() async {
    if (!communityInfoFetched) {
      await moderatorController.getCommunityInfo(widget.communityName);
      communityInfoFetched = true;
      //print(moderatorController.generalSettings.communityTitle);
      //print(moderatorController.generalSettings.communityDescription);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeGeneralSettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Material(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (MediaQuery.of(context).size.width < 700)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: fetchCommunityInfo(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: LoadingAnimationWidget
                                            .twoRotatingArc(
                                                color: const Color.fromARGB(
                                                    255, 172, 172, 172),
                                                size: 20),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text('');
                                    } else {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          moderatorController
                                              .generalSettings.communityTitle,
                                          //'ba test bas el donya mashya ezay - Community Title',
                                          style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromARGB(
                                                  255, 42, 60, 66)),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                FutureBuilder(
                                  future: fetchCommunityInfo(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: LoadingAnimationWidget
                                            .twoRotatingArc(
                                                color: const Color.fromARGB(
                                                    255, 172, 172, 172),
                                                size: 20),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text('');
                                    } else {
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          moderatorController.generalSettings
                                              .communityDescription,
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255, 87, 111, 118),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder(
                                        future: fetchMembersCount(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: LoadingAnimationWidget
                                                  .twoRotatingArc(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              172,
                                                              172,
                                                              172),
                                                      size: 20),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Text('0');
                                          } else {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 4),
                                              child: Text(
                                                moderatorController
                                                    .membersCount,
                                                //'4',
                                                style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color.fromARGB(
                                                        255, 42, 60, 66)),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      const Text(
                                        'Members',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            color: Color.fromARGB(
                                                255, 87, 111, 118)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 215, 215, 215),
                        height: 1,
                        thickness: 1.0,
                      ),
                      Consumer<RulesProvider>(
                        builder: (context, addRulesProvider, child) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: const Text(
                                      'Rules',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14, // el mafrood 12
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(255, 97, 104, 110),
                                      ),
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: fetchRules(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: LoadingAnimationWidget
                                              .twoRotatingArc(
                                                  color: const Color.fromARGB(
                                                      255, 172, 172, 172),
                                                  size: 20),
                                        );
                                      } else if (snapshot.hasError) {
                                        return const Text('');
                                      } else {
                                        if (moderatorController.rules.isEmpty) {
                                          return const Text(
                                            'No rules have been set for this community yet.',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 97, 104, 110),
                                            ),
                                          );
                                        } else {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: moderatorController
                                                .rules.length,
                                            itemBuilder: (context, index) {      
                                              return Column(
                                                children: [
                                                  RuleTile(
                                                    rule: moderatorController
                                                        .rules[index],
                                                    index: index + 1,
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 215, 215, 215),
                        height: 1,
                        thickness: 1.0,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: const Text(
                                  'Moderators',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14, // el mafrood 12
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 97, 104, 110),
                                  ),
                                ),
                              ),
                              FutureBuilder(
                                future: fetchModerators(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child:
                                          LoadingAnimationWidget.twoRotatingArc(
                                              color: const Color.fromARGB(
                                                  255, 172, 172, 172),
                                              size: 20),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Text('');
                                  } else {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          moderatorController.moderators.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            ModeratorTile(
                                              moderatorUsername:
                                                  moderatorController
                                                          .moderators[index]
                                                      ["username"],
                                              moderatorProfilePicture:
                                                  moderatorController
                                                          .moderators[index]
                                                      ["profile_picture"],
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
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
      },
    );
  }
}

class RuleTile extends StatefulWidget {
  const RuleTile({super.key, required this.rule, required this.index});

  final RulesItem rule;
  final int index;

  @override
  RuleTileState createState() => RuleTileState();
}

class RuleTileState extends State<RuleTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      '${widget.index} ${widget.rule.ruleTitle}',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Color.fromARGB(255, 97, 104, 110),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color.fromARGB(255, 19, 21, 23),
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: isExpanded ? 1.0 : 0.0,
            child: Visibility(
              visible: isExpanded,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  widget.rule.ruleDescription ?? "",
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Color.fromARGB(255, 97, 104, 110),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModeratorTile extends StatefulWidget {
  const ModeratorTile(
      {super.key,
      required this.moderatorUsername,
      required this.moderatorProfilePicture});

  final String moderatorUsername;
  final String moderatorProfilePicture;

  @override
  ModeratorTileState createState() => ModeratorTileState();
}

class ModeratorTileState extends State<ModeratorTile> {
  final userController = GetIt.instance.get<UserController>();
  final userService = GetIt.instance.get<UserService>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(widget.moderatorProfilePicture),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: GestureDetector(
            child: Text(
              "u/${widget.moderatorUsername}",
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: Color.fromARGB(255, 97, 104, 110),
              ),
            ),
            onTap: () {
              String userType =
                  userController.userAbout!.username == widget.moderatorUsername
                      ? 'me'
                      : 'other';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FutureBuilder<UserAbout?>(
                    future: userService.getUserAbout(widget.moderatorUsername),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.white,
                          child: const Center(
                              child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          )),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ProfileScreen(
                          snapshot.data,
                          userType,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
