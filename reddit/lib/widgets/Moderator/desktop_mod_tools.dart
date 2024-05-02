import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';
import 'package:reddit/widgets/Moderator/banned_user_list.dart';
import 'package:reddit/widgets/Moderator/community_type.dart';
import 'package:reddit/widgets/Moderator/description.dart';
import 'package:reddit/widgets/Moderator/mod_community_name.dart';
import 'package:reddit/widgets/Moderator/mod_rules_list.dart';
import 'package:reddit/widgets/Moderator/mod_tools_list.dart';
import 'package:reddit/widgets/Moderator/mod_tools_ui.dart';
import 'package:reddit/widgets/Moderator/moderators_list.dart';
import 'package:reddit/widgets/Moderator/muted_users_list.dart';
import 'package:reddit/widgets/Moderator/post_types.dart';
import 'package:reddit/widgets/Moderator/queues.dart';
import 'package:reddit/widgets/Moderator/scheduled_list.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';

class DesktopModTools extends StatefulWidget {
  final int index;
  final String communityName;
  bool isInvite;
  DesktopModTools(
      {super.key,
      required this.index,
      required this.communityName,
      this.isInvite = false});

  @override
  State<DesktopModTools> createState() => _DesktopModToolsState();
}

class _DesktopModToolsState extends State<DesktopModTools> {
  late int modToolIndex;
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  late List<Widget> desktopModTools;

  @override
  void initState() {
    super.initState();
    modToolIndex = widget.index;
    desktopModTools = [
      const ModCommName(),
      const ModDescription(),
      const CommunityType(),
      const PostTypes(),
      ModeratorsList(isInvite: widget.isInvite),
      const ApprovedUserList(),
      const BannedUsersList(),
      const MutedUsersList(),
      const ModQueues(),
      const ModRulesList(
        isEditMode: false,
      ),
      const ScheduledPostsList()
    ];
  }

  void changePage(selected) {
    setState(() {
      modToolIndex = selected;
    });
  }

  void logoTapped() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
            mobileLayout: MobileLayout(
              mobilePageMode: 0,
            ),
            desktopLayout: DesktopHomePage(
              indexOfPage: 0,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var approvedUserProvider = context.read<ApprovedUserProvider>();
    return Scaffold(
      appBar: DesktopAppBar(logoTapped: logoTapped),
      body: Column(
        children: [
          const Divider(
            height: 0.3,
            color: Colors.grey,
          ),
          Expanded(
            child: Row(
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 275),
                    child: ModToolsList(
                      isMobile: false,
                      changePage: changePage,
                    )),
                VerticalDivider(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
                //here the body of each mod tool can be changed by the setstate
                Expanded(child: desktopModTools[modToolIndex])
              ],
            ),
          ),
        ],
      ),
    );
  }
}
