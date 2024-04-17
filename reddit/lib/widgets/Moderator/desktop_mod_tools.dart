import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/mod_tools_list.dart';
import 'package:reddit/widgets/Moderator/mod_tools_ui.dart';
import 'package:reddit/widgets/desktop_appbar.dart';
import 'package:reddit/widgets/desktop_layout.dart';
import 'package:reddit/widgets/mobile_layout.dart';
import 'package:reddit/widgets/responsive_layout.dart';

class DesktopModTools extends StatefulWidget {
  final int index;
  final String communityName;
  const DesktopModTools(
      {super.key, required this.index, required this.communityName});

  @override
  State<DesktopModTools> createState() => _DesktopModToolsState();
}

class _DesktopModToolsState extends State<DesktopModTools> {
  late int modToolIndex;
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();

  @override
  void initState() {
    super.initState();
    modToolIndex = widget.index;
    moderatorController.getCommunity(widget.communityName);
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
        ));
  }
}



//AppBar(
        //   scrolledUnderElevation: 0.3,
        //   elevation: 0.3,
        //   backgroundColor: Colors.white,
        //   shadowColor: Colors.grey,
        //   title: const Center(
        //       child: Text(
        //     "Mod Tools",
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   )),
        // ),