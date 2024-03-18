import 'package:flutter/material.dart';

class EndDrawerReddit extends StatelessWidget {
  const EndDrawerReddit({super.key});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
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
