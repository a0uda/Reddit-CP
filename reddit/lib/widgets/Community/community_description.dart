import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Pages/description_widget.dart';

class CommunityDescription extends StatefulWidget {
  const CommunityDescription({
    required this.communityName,
    required this.communityMembersNo,
    required this.communityRule,
    required this.communityProfilePicturePath,
    required this.communityDescription,
    super.key,
  });

  final String communityName;
  final int communityMembersNo;
  final communityRule;
  final String communityProfilePicturePath;
  final String communityDescription;

  @override
  State<CommunityDescription> createState() => _CommunityDescriptionState();
}

class _CommunityDescriptionState extends State<CommunityDescription> {
  final moderatorController = GetIt.instance.get<ModeratorController>();
  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeGeneralSettingsProvider>(
        builder: (context, settingsProvider, child) {
      return Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 0),
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage(widget.communityProfilePicturePath),
                    backgroundColor: Colors.white,
                    radius: 40,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'r/${moderatorController.communityName}',
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.communityMembersNo} members',
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              color: Color.fromARGB(255, 144, 144, 144)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    if (MediaQuery.of(context).size.width < 850)
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DescriptionWidget(
                                  communityDescription:
                                      widget.communityDescription,
                                  communityRules: widget.communityRule,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'See community info',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12,
                              color: Color.fromARGB(255, 38, 73, 150),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 0),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
