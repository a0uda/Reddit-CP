import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/removal.dart';

class ModalForReasons extends StatefulWidget {
  final Function(String) handleRemove;
  final String communityName;

  ModalForReasons(
      {super.key, required this.handleRemove, required this.communityName});

  @override
  State<ModalForReasons> createState() => _ModalForReasonsState();
}

class _ModalForReasonsState extends State<ModalForReasons> {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  List<RemovalItem> removal = [];
  String selected = "";

  Future<void> fetchRemoval() async {
    await moderatorController.getRemoval(widget.communityName);
    setState(() {
      removal = moderatorController.removalReasons;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRemoval();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Center(
              child: Text(
                "Why it is being removed",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: removal.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < removal.length) {
                  final item = removal[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: Text("${index + 1}."),
                        title: Text(
                          item.title,
                          style: TextStyle(
                              fontWeight: selected == item.title
                                  ? FontWeight.bold
                                  : null),
                        ),
                        onTap: () {
                          setState(() {
                            selected = item.title;
                          });
                        },
                      ),
                      Divider(
                        endIndent: 25,
                        indent: 25,
                        color: Colors.grey[300],
                        height: 1,
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color.fromARGB(255, 3, 55, 146),
                        surfaceTintColor: const Color.fromARGB(255, 3, 55, 146),
                      ),
                      onPressed: (selected != "" || removal.isEmpty)
                          ? () {
                              widget.handleRemove(selected);
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: Text(
                        "Submit",
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
