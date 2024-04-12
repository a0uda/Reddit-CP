import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/widgets/custom_settings_tile.dart';

class ConnectGoogleTile extends StatefulWidget {
  const ConnectGoogleTile({super.key});

  @override
  State<ConnectGoogleTile> createState() => _ConnectGoogleTileState();
}

class _ConnectGoogleTileState extends State<ConnectGoogleTile> {
  final UserController userController = GetIt.instance.get<UserController>();

  @override
  Widget build(BuildContext context) {
    bool isConnected = userController.accountSettings!.connectedGoogle;
    return CustomSettingsTile(
      title: 'Google',
      leading: Image.asset(
        'images/google-icon.png',
        width: 22,
        height: 22,
      ),
      trailing: GestureDetector(
        child: Text(
          isConnected ? 'Disconnect' : 'Connect',
          style: TextStyle(
              color: Colors.blue[900],
              fontSize: 14.0,
              fontWeight: FontWeight.bold),
        ),
        onTap: () {
          setState(() {
            isConnected = !isConnected;
            if (isConnected) {
              userController
                  .connectToGoogle(userController.userAbout!.username!);
            } else {
              userController
                  .disconnectFromGoogle(userController.userAbout!.username!);
            }
          });
        },
      ),
      onTap: () {
        // Navigate to the Connect Google Screen
        // Navigator.of(context).pushNamed('/connect-google');
      },
    );
  }
}
