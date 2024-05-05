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
    super.key,
  });

  final String communityName;
  final String communityMembersNo;
  final communityRule;
  final String communityProfilePicturePath;

  @override
  State<CommunityDescription> createState() => _CommunityDescriptionState();
}

class _CommunityDescriptionState extends State<CommunityDescription> {
  final moderatorController = GetIt.instance.get<ModeratorController>();

  Future<void> fetchGeneralSettings() async {
    if (false) {
      await moderatorController
          .getGeneralSettings(moderatorController.communityName);
      //communityGeneralSettings = moderatorController.generalSettings;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchGeneralSettings(),
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
                                NetworkImage(widget.communityProfilePicturePath),
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
                                  'r/${widget.communityName}',
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
                                      color:
                                          Color.fromARGB(255, 144, 144, 144)),
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
                                          communityName: widget.communityName,
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

          default:
            return const Text('badr');
        }
      },
    );
  }
}
