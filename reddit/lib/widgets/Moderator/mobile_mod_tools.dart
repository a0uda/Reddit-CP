import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/desktop_mod_tools.dart';
import 'package:reddit/widgets/Moderator/mod_responsive.dart';
import 'package:reddit/widgets/Moderator/mod_tools_list.dart';
import 'package:reddit/widgets/Moderator/mod_tools_ui.dart';

class MobileModTools extends StatefulWidget {
  final String communityName;
  const MobileModTools({super.key, required this.communityName});

  @override
  State<MobileModTools> createState() => _MobileModToolsState();
}

class _MobileModToolsState extends State<MobileModTools> {
  final ModeratorController moderatorController = GetIt.instance.get<ModeratorController>();

  @override
  void initState() {
    super.initState();
    moderatorController.getCommunity(widget.communityName);
  }

  @override
  Widget build(BuildContext context) {
    
    void changePage(selected) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ModResponsive(
            mobileLayout: mobileModTools[selected],
            desktopLayout: DesktopModTools(index: selected , communityName: widget.communityName,)),
      ));
    }

    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: const Center(
              child: Text(
            "Mod Tools",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
        body: Column(
          children: [
            const Divider(
              height: 0.3,
              color: Colors.grey,
            ),
            Expanded(
                child: ModToolsList(
              isMobile: true,
              changePage: changePage,
            )),
          ],
        ));
  }
}
