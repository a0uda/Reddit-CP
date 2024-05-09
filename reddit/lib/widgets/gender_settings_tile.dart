import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/widgets/custom_settings_tile.dart';
import 'package:get_it/get_it.dart';

class GenderTile extends StatefulWidget {
  const GenderTile({super.key});

  @override
  State<GenderTile> createState() => _GenderTileState();
}

class _GenderTileState extends State<GenderTile> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = GetIt.instance.get<UserController>();
    final AccountSettingsController accountSettingsController =
        context.read<AccountSettingsController>();
    Future<AccountSettings>? accountSettings =
        userController.getAccountSettings(userController.userAbout!.username);
    String gender = userController.accountSettings!.gender;
    return Consumer<AccountSettingsController>(
        builder: (context, accountSettingsController, child) {
      return CustomSettingsTile(
        title: 'Gender',
        subtitle: userController.accountSettings!.gender,
        leading: const Icon(Icons.person),
        trailing: const Icon(Icons.keyboard_arrow_down, size: 16.0),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Select gender',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'This information may be used to improve your recommendations and ads.',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  title: const Text('Male'),
                  leading: Radio(
                    activeColor: Colors.blue[900],
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (String? value) async {
                      gender = value!;
                      bool changed =
                          await accountSettingsController.changeGender(gender);
                      if (changed) {
                        setState(() {
                          accountSettings = userController.getAccountSettings(
                              userController.userAbout!.username);
                          gender = value;
                        });
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Female'),
                  leading: Radio(
                      value: 'Female',
                      activeColor: Colors.blue[900],
                      groupValue: gender,
                      onChanged: (String? value) async {
                        gender = value!;
                        bool changed = await accountSettingsController
                            .changeGender(gender);
                        if (changed) {
                          setState(() {
                            accountSettings = userController.getAccountSettings(
                                userController.userAbout!.username);
                            gender = value;
                          });
                        }
                        Navigator.pop(context);
                      }),
                ),
                ListTile(
                  title: const Text('I prefer not to say'),
                  leading: Radio(
                      value: 'I prefer not to say',
                      activeColor: Colors.blue[900],
                      groupValue: gender,
                      onChanged: (String? value) async {
                        gender = value!;
                        bool changed = await accountSettingsController
                            .changeGender(gender);
                        if (changed) {
                          setState(() {
                            accountSettings = userController.getAccountSettings(
                                userController.userAbout!.username);
                            gender = value;
                          });
                        }
                        Navigator.pop(context);
                      }),
                ),
                const SizedBox(height: 20.0)
              ],
            ),
          );
        },
      );
    });
  }
}
