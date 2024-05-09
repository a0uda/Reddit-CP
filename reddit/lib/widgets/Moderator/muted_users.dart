import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/add_muted_user.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';
import 'package:reddit/widgets/Moderator/muted_users_list.dart';

class MutedUsers extends StatefulWidget {
  const MutedUsers({super.key});

  @override
  State<MutedUsers> createState() => _MutedUsersState();
}

class _MutedUsersState extends State<MutedUsers> {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Center(child: Text("Muted Users")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  if (moderatorController.modAccess.everything ||
                      moderatorController.modAccess.manageUsers) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddMutedUser(),
                      ),
                    );
                  } else {
                    showError(context);
                  }
                },
                icon: const Icon(CupertinoIcons.add)),
          ) //Badrr navigate to mute user page
        ],
      ),
      body: Container(color: Colors.grey[200], child: const MutedUsersList()),
    );
  }
}
