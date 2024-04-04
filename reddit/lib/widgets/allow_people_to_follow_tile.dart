import 'package:flutter/material.dart';
import 'package:reddit/widgets/custom_settings_tile.dart';

class AllowPeopleToFollowTile extends StatefulWidget {
  const AllowPeopleToFollowTile({super.key});

  @override
  State<AllowPeopleToFollowTile> createState() =>
      _AllowPeopleToFollowTileState();
}

class _AllowPeopleToFollowTileState extends State<AllowPeopleToFollowTile> {
  bool _isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return CustomSettingsTile(
      title: 'Allow people to follow you',
      subtitle:
          'Followers will be notified about posts you make to your profile and see them in their home feed.',
      leading: const Icon(Icons.account_circle_outlined),
      trailing: Switch(
          value: _isSwitched,
          thumbColor: MaterialStateProperty.all(Colors.white),
          activeTrackColor: Colors.blue[900],
          inactiveTrackColor: Colors.grey[300],
          trackOutlineColor: MaterialStateProperty.all(Colors.grey[300]),
          onChanged: (value) {
            setState(() {
              _isSwitched = value;
            });
          }),
      onTap: () {
        // Navigate to the Allow People to Follow Screen
        // Navigator.of(context).pushNamed('/allow-people-to-follow');
      },
    );
  }
}
