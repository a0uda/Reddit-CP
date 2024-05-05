import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/add_modderator.dart';
import 'package:reddit/widgets/Moderator/moderators_list.dart';

class Moderators extends StatefulWidget {
  bool isInvite;
  String msgID;
  Moderators({super.key, this.isInvite = false, this.msgID = ""});

  @override
  State<Moderators> createState() => _ModeratorsState();
}

class _ModeratorsState extends State<Moderators> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Center(child: Text("Moderators")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddModerator(),
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.add)),
          ) //implement add in mock badrrrrr
        ],
      ),
      body: Container(
          color: Colors.grey[200],
          child: ModeratorsList(
            isInvite: widget.isInvite,
            msgID: widget.msgID,
          )),
    );
  }
}
