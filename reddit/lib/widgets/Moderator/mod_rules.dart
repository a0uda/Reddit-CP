import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/test_files/test_communities.dart';
import 'package:reddit/widgets/Moderator/create_rule_page.dart';
import 'package:reddit/widgets/Moderator/mod_rules_list.dart';

class ModRules extends StatefulWidget {
  const ModRules({super.key});

  @override
  State<ModRules> createState() => _ModRulesState();
}

class _ModRulesState extends State<ModRules> {
  bool isEditMode = false;
    final moderatorController = GetIt.instance.get<ModeratorController>();

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? "EditRules" : "Rules",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          !isEditMode
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreateRulePage(),
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
      body: ModRulesList(
        isEditMode: isEditMode,
      ),
    );
  }
}
