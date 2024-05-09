import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/create_removal.dart';
import 'package:reddit/widgets/Moderator/edit_removal.dart';

class RemovalList extends StatefulWidget {
  final bool isEditMode;
  const RemovalList({super.key, required this.isEditMode});

  @override
  State<RemovalList> createState() => _RemovalListState();
}

class _RemovalListState extends State<RemovalList> {
  final moderatorController = GetIt.instance.get<ModeratorController>();

  bool isEditing = false;
  bool remFetched = false;
  late bool hasPermission;

  void checkPermission() {
    if (moderatorController.modAccess.everything ||
        moderatorController.modAccess.manageSettings) {
      hasPermission = true;
    } else {
      hasPermission = false;
    }
  }

  Future<void> fetchRem() async {
    if (!remFetched) {
      await moderatorController.getRemoval(moderatorController.communityName);
      setState(() {
        remFetched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isEditing = widget.isEditMode;
    remFetched = false;
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 700) {
      isEditing = widget.isEditMode;
    }
    return Consumer<RemovalProvider>(builder: (context, remPov, child) {
      return RefreshIndicator(
        onRefresh: () async {
          remFetched = false;
          await fetchRem();
        },
        child: Column(
          children: [
            (screenWidth > 700)
                ? AppBar(
                    leading: const SizedBox(),
                    title: Text(
                      isEditing ? "Edit Reason" : 'Removal Reasons',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                        TextButton(
                          onPressed: () {
                            if (hasPermission) {
                              setState(() {
                                isEditing = !isEditing;
                                remFetched = true;
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: const Text(
                                          'You do not have permission to change this setting',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            child: const Text(
                                              'Please contact the owner of the community for more information',
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 37, 79, 165),
                                                side: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 37, 79, 165)),
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 16,
                                                    top: 16,
                                                    bottom: 16),
                                              ),
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            }
                          },
                          child: Text(
                            isEditing ? "Done" : "Delete",
                            style: TextStyle(
                                color: isEditing
                                    ? Colors.black
                                    : const Color.fromARGB(255, 42, 101, 210),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        !isEditing
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: const Color.fromARGB(
                                          255, 42, 101, 210)),
                                  onPressed: () {
                                    if (hasPermission) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateRemoval(),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: const Text(
                                                  'You do not have permission to change this setting',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: const Text(
                                                      'Please contact the owner of the community for more information',
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: OutlinedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                37, 79, 165),
                                                        side: const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    37,
                                                                    79,
                                                                    165)),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 20,
                                                                right: 16,
                                                                top: 16,
                                                                bottom: 16),
                                                      ),
                                                      child: const Text(
                                                        'OK',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    }
                                  }, // add rule Badrrr ele hya add
                                  child: const Text(
                                    "Add removal reason",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ])
                : const SizedBox(),
            FutureBuilder<void>(
              future: fetchRem(),
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
                    return Expanded(
                      child: ListView.builder(
                        itemCount: moderatorController.removalReasons.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item =
                              moderatorController.removalReasons[index];
                          return Column(
                            children: [
                              ListTile(
                                tileColor: Colors.white,
                                leading:
                                    !isEditing ? Text("${index + 1}") : null,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title.length > 45
                                          ? "${item.title.substring(0, 45)}..."
                                          : item.title,
                                    ),
                                    item.message != null
                                        ? Text(
                                            item.message!.length > 130
                                                ? "${item.message!.substring(0, 130)}..."
                                                : item.message!,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                                trailing: isEditing
                                    ? IconButton(
                                        onPressed: () async {
                                          //delete rule badrrr
                                          await remPov.deleteRemovalReason(
                                              moderatorController.communityName,
                                              item.id!);
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline_outlined,
                                          color: Colors.red,
                                        ))
                                    : const Icon(
                                        Icons.keyboard_arrow_right_rounded),
                                onTap: isEditing
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditRemovalReason(
                                              title: item.title,
                                              id: item.id!,
                                              message: item.message,
                                            ),
                                          ),
                                        );
                                      },
                              ),
                              const Divider(
                                color: Colors.grey,
                                height: 1,
                              )
                            ],
                          );
                        },
                      ),
                    );
                  default:
                    return const Text('badr');
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
