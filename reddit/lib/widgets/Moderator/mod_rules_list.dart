import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/create_rule_page.dart';
import 'package:reddit/widgets/Moderator/edit_rule_page.dart';

class ModRulesList extends StatefulWidget {
  final bool isEditMode;
  const ModRulesList({super.key, required this.isEditMode});

  @override
  State<ModRulesList> createState() => _ModRulesListState();
}

class _ModRulesListState extends State<ModRulesList> {
  final moderatorController = GetIt.instance.get<ModeratorController>();

  bool isEditing = false;
  bool rulesFetched = false;
  late bool hasPermission;

  void checkPermission() {
    if (moderatorController.modAccess.everything &&
        moderatorController.modAccess.manageSettings) {
      hasPermission = true;
    } else {
      hasPermission = false;
    }
  }

  Future<void> fetchRules() async {
    if (!rulesFetched) {
      await moderatorController.getRules(moderatorController.communityName);
      setState(() {
        rulesFetched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isEditing = widget.isEditMode;
    rulesFetched = false;
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 700) {
      isEditing = widget.isEditMode;
    }
    return Consumer<RulesProvider>(builder: (context, rulesProvider, child) {
      return RefreshIndicator(
        onRefresh: () async {
          rulesFetched = false;
          await fetchRules();
        },
        child: Column(
          children: [
            (screenWidth > 700)
                ? AppBar(
                    leading: const SizedBox(),
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
                            if (hasPermission) {
                              setState(() {
                                isEditing = !isEditing;
                                rulesFetched = true;
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                backgroundColor:
                                                    const Color.fromARGB(
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 42, 101, 210)),
                                  onPressed: () {
                                    if (hasPermission) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateRulePage(),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: const Text(
                                                  'You do not have permission to change this setting',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: const Text(
                                                      'Please contact the owner of the community for more information',
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: OutlinedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                37, 79, 165),
                                                        side: const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    37,
                                                                    79,
                                                                    165)),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 20,
                                                                right: 16,
                                                                top: 16,
                                                                bottom: 16),
                                                      ),
                                                      child: const Text(
                                                        'OK',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    }
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
            FutureBuilder<void>(
              future: fetchRules(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('none');
                  case ConnectionState.waiting:
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: moderatorController.rules.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = moderatorController.rules[index];
                          return Column(
                            children: [
                              ListTile(
                                  tileColor: Colors.white,
                                  leading:
                                      !isEditing ? Text("${index + 1}") : null,
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.ruleTitle.length > 45
                                            ? "${item.ruleTitle.substring(0, 45)}..."
                                            : item.ruleTitle,
                                      ),
                                      item.ruleDescription != null
                                          ? Text(
                                              item.ruleDescription!.length > 130
                                                  ? "${item.ruleDescription!.substring(0, 130)}..."
                                                  : item.ruleDescription!,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                  trailing: isEditing
                                      ? IconButton(
                                          onPressed: () async {
                                            //delete rule badrrr

                                            await rulesProvider.deleteRule(
                                                moderatorController
                                                    .communityName,
                                                item.id!);
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline_outlined,
                                            color: Colors.red,
                                          ))
                                      : const Icon(
                                          Icons.keyboard_arrow_right_rounded),
                                  onTap: isEditing
                                      ? null
                                      : () {
                                          if (hasPermission) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditRulePage(
                                                  ruleTitle: item.ruleTitle,
                                                  id: item.id!,
                                                  ruleDescription:
                                                      item.ruleDescription,
                                                  appliesToOption:
                                                      item.appliesTo,
                                                  reportReason:
                                                      item.reportReason,
                                                ),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CupertinoAlertDialog(
                                                    title: Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      child: const Text(
                                                        'You do not have permission to change this setting',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                          child: const Text(
                                                            'Please contact the owner of the community for more information',
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                          child: OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      37,
                                                                      79,
                                                                      165),
                                                              side: const BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          37,
                                                                          79,
                                                                          165)),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 20,
                                                                      right: 16,
                                                                      top: 16,
                                                                      bottom:
                                                                          16),
                                                            ),
                                                            child: const Text(
                                                              'OK',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          }
                                        }),
                              const Divider(
                                color: Colors.grey,
                                height: 1,
                              )
                            ],
                          );
                        },
                      ),
                    );
                  default:
                    return const Text('badr');
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
