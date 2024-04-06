import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/mod_tools_list.dart';

class MobileModTools extends StatelessWidget {
  const MobileModTools({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: const Column(
          children: [
            Divider(height: 0.3,color: Colors.grey,),
            Expanded(
                child: ModToolsList(
              isMobile: true,
            )),
          ],
        ));
  }
}
