import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/create_removal.dart';
import 'package:reddit/widgets/Moderator/removal_list.dart';

class RemovalReasons extends StatefulWidget {
  const RemovalReasons({super.key});

  @override
  State<RemovalReasons> createState() => _RemovalReasonsState();
}

class _RemovalReasonsState extends State<RemovalReasons> {
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();
  int removalCount = 0;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    isEditMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey,
        leading: isEditMode ? const SizedBox() : null,
        title: Consumer<RemovalProvider>(
            builder: (context, rempov, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditMode ? "Edit Reasons" : "Removal Reasons",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              isEditMode
                  ? const SizedBox()
                  : Text(
                      "${moderatorController.removalReasons.length}/50 reasons",
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    )
            ],
          );
        }),
        actions: [
          !isEditMode
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreateRemoval(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add))
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: !isEditMode
                ? IconButton(
                    onPressed: () {
                      //change to edit mode badrr
                      setState(() {
                        isEditMode = true;
                      });
                    },
                    icon: const Icon(Icons.edit))
                : TextButton(
                    onPressed: () {
                      //out of edit mode
                      setState(() {
                        isEditMode = false;
                      });
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
          )
        ],
      ),
      body: RemovalList(
        isEditMode: isEditMode,
      ),
    );
  }
}
