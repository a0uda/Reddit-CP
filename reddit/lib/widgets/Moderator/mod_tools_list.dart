import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';

class ModToolsList extends StatelessWidget {
  final bool isMobile;
  final Function(int) changePage;
  ModToolsList({super.key, required this.isMobile, required this.changePage});
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        !isMobile
            ? ListTile(
                leading: const Icon(Icons.arrow_back),
                title: const Text(
                  'Exit mod tools',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  //navigate back to community page
                },
              )
            : const SizedBox(),
        !isMobile
            ? const Divider(
                color: Colors.grey,
                height: 10,
                indent: 30,
                endIndent: 30,
              )
            : const SizedBox(),
        ListTile(
          leading: const Icon(CupertinoIcons.pencil),
          title: Text(
            'Community Name',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () => {changePage(0)},
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.pencil),
          title: Text(
            'Description',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () => {changePage(1)},
        ),
        ListTile(
          leading: const Icon(Icons.photo_size_select_actual_rounded),
          title: Text(
            'Change Pictures',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () {
            changePage(2);
          },
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.lock),
          title: Text(
            'Community Type',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () {
            changePage(3);
          },
        ),
        ListTile(
          leading: const Icon(Icons.post_add_rounded),
          title: Text(
            ' Post Types',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () {
            changePage(4);
          },
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.shield),
          title: Text(
            'Moderators',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () {
            changePage(5);
          },
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.person),
          title: Text(
            'Approved Users',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () {
            changePage(6);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person_off_outlined),
          title: Text(
            'Banned Users',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () {
            changePage(7);
          },
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.speaker_slash),
          title: Text(
            'Muted Users',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () {
            changePage(8);
          },
        ),
        ListTile(
          leading: const Icon(Icons.queue),
          title: Text(
            'Queues',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: (moderatorController.modAccess.everything ||
                  moderatorController.modAccess.managePostsAndComments)
              ? () {
                  changePage(9);
                }
              : null,
        ),
        ListTile(
          leading: const Icon(Icons.rule),
          title: Text(
            'Rules',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () {
            changePage(10);
          },
        ),
        ListTile(
          leading: const Icon(Icons.close),
          title: Text(
            'Removal Reasons',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () {
            changePage(11);
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month),
          title: Text(
            'Scheduled Posts',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          trailing: isMobile
              ? const Icon(Icons.arrow_forward_rounded)
              : const SizedBox(),
          onTap: () {
            changePage(12);
          },
        ),
      ],
    );
  }
}
