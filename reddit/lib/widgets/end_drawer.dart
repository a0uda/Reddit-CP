import 'package:flutter/material.dart';
import '../Pages/profile_screen.dart';
import 'package:get_it/get_it.dart';
import '../Controllers/user_controller.dart';

class EndDrawerReddit extends StatelessWidget {
  EndDrawerReddit({super.key});
  final userController = GetIt.instance.get<UserController>();
  @override
  Widget build(BuildContext context) {
    userController
        .getUser('Purple-7544'); //rawannnn: to be replaced 
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
              child: IntrinsicHeight(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("images/pp.jpg"),
                  radius: 40,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text('"UserNamee"'),
                )
              ],
            ),
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
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: const Text("History"),
            onTap: () {
              //Navigate to History
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              //Navigate to Settings
            },
          ),
        ],
      ),
    );
  }
}
