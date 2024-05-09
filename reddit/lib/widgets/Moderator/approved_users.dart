import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/add_approved_user.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';

class ApprovedUsers extends StatefulWidget {
  const ApprovedUsers({super.key});

  @override
  State<ApprovedUsers> createState() => _ApprovedUsersState();
}

class _ApprovedUsersState extends State<ApprovedUsers> {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Center(child: Text("Approved Users")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  if (moderatorController.modAccess.everything ||
                      moderatorController.modAccess.manageUsers) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddApprovedUser(),
                      ),
                    );
                  } else {
                    showError(context);
                  }
                },
                icon: const Icon(CupertinoIcons.add)),
          ) //implement add in mock badrrrr
        ],
      ),
      body: Container(color: Colors.grey[200], child: const ApprovedUserList()),
    );
  }
}
