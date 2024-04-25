import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/rules_item.dart';

class DescriptionWidget extends StatefulWidget {
  const DescriptionWidget(
      {super.key,
      required this.communityDescription,
      required this.communityRules});

  final String communityDescription;
  final communityRules;
  @override
  State<DescriptionWidget> createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  final moderatorController = GetIt.instance.get<ModeratorController>();

  String communityDescription = '';
  late final String communityID;
  late final String communityType;
  late String communityName;
  late final bool communityFlag;
  late GeneralSettings communityGeneralSettings;

  Future<void> fetchGeneralSettings() async {
    await moderatorController.getGeneralSettings(communityName);
    communityGeneralSettings = moderatorController.generalSettings;
  }

  @override
  void initState() {
    super.initState();
    communityName = moderatorController.communityName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeGeneralSettingsProvider>(
        builder: (context, settingsProvider, child) {
      return Material(
        child: SingleChildScrollView(
          child: Card(
            color: const Color.fromARGB(255, 255, 255, 255),
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 215, 215, 215),
                        height: 10,
                        thickness: 1.0,
                      ),
                      FutureBuilder(
                        future: fetchGeneralSettings(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(
                              moderatorController
                                  .generalSettings.communityDescription,
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            );
                          }
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: const Text(
                                      'Rules',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 215, 215, 215),
                                    height: 1,
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.communityRules.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    RuleTile(
                                      rule: widget.communityRules[index],
                                      index: index + 1,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.index}. ${widget.rule.ruleTitle}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.black,
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
            duration: const Duration(milliseconds: 0),
            opacity: isExpanded ? 1.0 : 0.0,
            child: Visibility(
              visible: isExpanded,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.rule.ruleDescription ?? "",
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 215, 215, 215),
            height: 1,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}
