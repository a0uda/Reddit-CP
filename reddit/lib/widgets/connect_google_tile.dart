import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/account_settings_item.dart';
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
    return FutureBuilder<AccountSettings>(
        future: userController
            .getAccountSettings(userController.userAbout!.username),
        builder:
            (BuildContext context, AsyncSnapshot<AccountSettings> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            bool isConnected = snapshot.data!.connectedGoogle;
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
                onTap: () async {
                  bool newConnectionStatus = !isConnected;
                  bool connectStatus;
                  int disconnectStatus;
                  if (newConnectionStatus) {
                    connectStatus = await userController
                        .connectToGoogle(userController.userAbout!.username);
                    if (connectStatus) {
                      setState(() {
                        isConnected = newConnectionStatus;
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                "Cannot connect to this account."),
                            actions: <Widget>[
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      return Colors.deepOrange[400];
                                    },
                                  ),
                                ),
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    final TextEditingController passwordController =
                        TextEditingController();
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Enter your password'),
                          content: TextField(
                            controller: passwordController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    return Colors.deepOrange[400];
                                  },
                                ),
                              ),
                              child: const Text('Submit'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    String password = passwordController.text;

                    disconnectStatus =
                        await userController.disconnectFromGoogle(
                            userController.userAbout!.username, password);

                    if (disconnectStatus == 2) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                "Your don't have password, Add a password to your account first please."),
                            actions: <Widget>[
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      return Colors.deepOrange[400];
                                    },
                                  ),
                                ),
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (disconnectStatus == 200) {
                      setState(() {
                        isConnected = newConnectionStatus;
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text("Cannot disconnect."),
                            actions: <Widget>[
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      return Colors.deepOrange[400];
                                    },
                                  ),
                                ),
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
              ),
              onTap: () {},
            );
          }
        });
  }
}
