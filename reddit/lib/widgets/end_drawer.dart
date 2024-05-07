import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Pages/history.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/Pages/saved.dart';
import 'package:reddit/Services/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Pages/profile_screen.dart';
import 'package:get_it/get_it.dart';
import '../Controllers/user_controller.dart';
import 'package:reddit/Pages/settings_screen.dart';

class EndDrawerReddit extends StatelessWidget {
  EndDrawerReddit({super.key});
  final userController = GetIt.instance.get<UserController>();
  final chatservice = GetIt.instance.get<ChatsService>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: IntrinsicHeight(
            child: Consumer<ProfilePictureController>(
                builder: (context, profilepicturecontroller, child) {
              return Column(
                children: [
                  userController.userAbout!.profilePicture == null ||
                          userController.userAbout!.profilePicture == ''
                      ? const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('images/Greddit.png'),
                        )
                      : File(userController.userAbout!.profilePicture!)
                              .existsSync()
                          ? CircleAvatar(
                              radius: 40,
                              backgroundImage: FileImage(File(
                                  userController.userAbout!.profilePicture!)),
                            )
                          : CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(
                                  userController.userAbout!.profilePicture!),
                            ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(userController.userAbout!.username,
                        style: const TextStyle(fontSize: 20)),
                  )
                ],
              );
            }),
          )),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text("Profile"),
            onTap: () {
              //Navigate to profile -> rawann
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(userController.userAbout, 'me')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.save_outlined),
            title: const Text("Saved"),
            onTap: () {
              //Navigate to Saved
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Saved()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: const Text("History"),
            onTap: () {
              //Navigate to History
                    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const History()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              //Navigate to Settings
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async{
              userController.userAbout = null;
              await chatservice.SocketClose();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const LoginPage()));

            },
          ),
        ],
      ),
    );
  }
}
