import 'package:flutter/material.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/widgets/custom_settings_tile.dart';
import 'package:reddit/widgets/allow_people_to_follow_tile.dart';
import 'package:reddit/widgets/connect_google_tile.dart';
import '../Controllers/user_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = GetIt.instance.get<UserController>();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SettingsGroup(
              title: 'BASIC SETTINGS',
              titleTextStyle: TextStyle(
                  height: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.grey[700]),
              children: <Widget>[
                buildUpdateEmail(userController.userAbout!.email!),
                buildAddPassword(),
                buildGender(userController.userAbout!.gender!),
                buildCountry(),
              ],
            ),
            SettingsGroup(
              title: 'CONNECTED ACCOUNTS',
              titleTextStyle: TextStyle(
                  height: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.grey[700]),
              children: const <Widget>[
                ConnectGoogleTile(),
              ],
            ),
            SettingsGroup(
              title: 'CONTACT SETTINGS',
              titleTextStyle: TextStyle(
                  height: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.grey[700]),
              children: <Widget>[
                buildManageNotifications(),
              ],
            ),
            SettingsGroup(
              title: 'BLOCKING AND PERMESSIONS',
              titleTextStyle: TextStyle(
                  height: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.grey[700]),
              children: <Widget>[
                buildManageBlockedAccounts(),
                const AllowPeopleToFollowTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildUpdateEmail(String email) => CustomSettingsTile(
      title: 'Update email address',
      subtitle: email,
      leading: const Icon(Icons.settings_outlined),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        // Navigate to the Update Email Screen
        // Navigator.of(context).pushNamed('/update-email');
      },
    );

Widget buildAddPassword() => CustomSettingsTile(
      title: 'Add password',
      leading: const Icon(Icons.settings_outlined),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        // Navigate to the Add Password Screen
        // Navigator.of(context).pushNamed('/add-password');
      },
    );
Widget buildManageNotifications() => CustomSettingsTile(
      title: 'Manage notifications',
      leading: const Icon(Icons.notifications_none_outlined),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        // Navigate to the Manage Notifications Screen
        // Navigator.of(context).pushNamed('/manage-notifications');
      },
    );

Widget buildGender(String gender) => CustomSettingsTile(
      title: 'Gender',
      subtitle: gender,
      leading: const Icon(Icons.person),
      trailing: const Icon(Icons.keyboard_arrow_down, size: 16.0),
      onTap: () {
        // Navigate
        // Navigator.of(context).push
      },
    );
Widget buildCountry() => CustomSettingsTile(
      title: 'Location customization',
      subtitle: 'Egypt',
      leading: const Icon(Icons.location_on_outlined),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        // Navigate
        // Navigator.of(context).push
      },
    );

Widget buildConnectFacebook() => CustomSettingsTile(
      title: 'Facebook',
      leading: Icon(
        FontAwesomeIcons.facebook,
        color: Colors.blue[900],
        size: 22,
      ),
      trailing: Text(
        'Disconnect',
        style: TextStyle(
            color: Colors.blue[900],
            fontSize: 14.0,
            fontWeight: FontWeight.bold),
      ),
      onTap: () {
        // Navigate to the Connect Facebook Screen
        // Navigator.of(context).pushNamed('/connect-facebook');
      },
    );
Widget buildManageBlockedAccounts() => CustomSettingsTile(
      title: 'Manage blocked accounts',
      leading: const Icon(Icons.block_flipped),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        // Navigate to the Manage Blocked Accounts Screen
        // Navigator.of(context).pushNamed('/manage-blocked-accounts');
      },
    );
