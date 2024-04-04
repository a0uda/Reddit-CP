import 'package:flutter/material.dart';
import 'package:reddit/widgets/custom_settings_tile.dart';

class ConnectGoogleTile extends StatefulWidget {
  const ConnectGoogleTile({super.key});

  @override
  State<ConnectGoogleTile> createState() => _ConnectGoogleTileState();
}

class _ConnectGoogleTileState extends State<ConnectGoogleTile> {
  bool _isConnected = true;

  @override
  Widget build(BuildContext context) {
    return CustomSettingsTile(
      title: 'Google',
      leading: Image.asset(
        'images/google-icon.png',
        width: 32,
        height: 32,
      ),
      trailing: GestureDetector(
        child: Text(
          _isConnected ? 'Disconnect' : 'Connect',
          style: TextStyle(
              color: Colors.blue[900],
              fontSize: 14.0,
              fontWeight: FontWeight.bold),
        ),
        onTap: () {
          setState(() {
            _isConnected = !_isConnected;
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
