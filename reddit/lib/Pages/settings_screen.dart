import 'package:flutter/material.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/widgets/country_tile.dart';
import 'package:reddit/widgets/custom_settings_tile.dart';
import 'package:reddit/widgets/custom_stateful_settings_tile.dart';
import 'package:reddit/widgets/connect_google_tile.dart';
import 'package:reddit/widgets/gender_settings_tile.dart';
import 'package:reddit/widgets/manage_blocked_accounts.dart';
import 'package:reddit/widgets/notifications_settings.dart';
import 'package:reddit/widgets/reset_password.dart';
import 'package:reddit/widgets/add_password.dart';
import 'package:reddit/widgets/update_email.dart';
import '../Controllers/user_controller.dart';
import 'package:reddit/widgets/location_customization.dart';

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
        surfaceTintColor: Colors.white,
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
                Consumer<ChangeEmail>(
                  builder: (context, changeEmail, child) {
                    return buildUpdateEmail(
                        userController.userAbout!.email!, context);
                  },
                ),
                buildAddPassword(context),
                //buildGender(userController.userAbout!.gender!),
                Consumer<AccountSettingsController>(
                  builder: (context, accountSettingsController, child) {
                    return const GenderTile();
                  },
                ),
                Consumer<AccountSettingsController>(
                  builder: (context, accountSettingsController, child) {
                    return const CountryTile();
                  },
                ),
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
                buildManageNotifications(context),
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
                buildManageBlockedAccounts(context),
                buildAllowPeopleToFollowYou(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void handleUpdateAllowFollowers(String setting, bool value) {
  final UserController userController = GetIt.instance.get<UserController>();
  userController.updateAllowFollowers(value);
}

Widget buildUpdateEmail(String email, context) => CustomSettingsTile(
      title: 'Update email address',
      subtitle: email,
      leading: const Icon(Icons.settings_outlined),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const UpdateEmail(),
          ),
        );
      },
    );

Widget buildAddPassword(context) {
  final UserController userController = GetIt.instance.get<UserController>();
  bool isSetPass = userController.userAbout!.isPasswordSetFlag!;
  print('is set');
  print(isSetPass);
  return CustomSettingsTile(
    title: isSetPass ? 'Change password' : 'Add password',
    leading: const Icon(Icons.settings_outlined),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
    onTap: () {
      if (isSetPass) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ResetPassword(),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddPassword(),
          ),
        );
      }
    },
  );
}

Widget buildManageNotifications(context) => CustomSettingsTile(
      title: 'Manage notifications',
      leading: const Icon(Icons.notifications_none_outlined),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NotificationsSettings(),
          ),
        );
      },
    );

Widget buildCountry(context, String country) => CustomSettingsTile(
      title: 'Location customization',
      subtitle: country,
      leading: const Icon(Icons.location_on_outlined),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LocationCustomization(),
          ),
        );
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
Widget buildManageBlockedAccounts(context) => CustomSettingsTile(
      title: 'Manage blocked accounts',
      leading: const Icon(Icons.block_flipped),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ManageBlockedAccounts(),
          ),
        );
      },
    );

Widget buildAllowPeopleToFollowYou() => CustomStatefulSettingsTile(
      switchValue: userController.profileSettings!.allowFollowers!,
      title: 'Allow people to follow you',
      subtitle:
          'Followers will be notified about posts you make to your profile and see them in their home feed.',
      leading: const Icon(Icons.account_circle_outlined),
      onChanged: handleUpdateAllowFollowers,
      onTap: () {},
    );
