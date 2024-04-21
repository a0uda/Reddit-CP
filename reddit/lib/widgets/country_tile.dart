import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/widgets/custom_settings_tile.dart';
import 'package:reddit/widgets/location_customization.dart';

class CountryTile extends StatefulWidget {
  const CountryTile({super.key});

  @override
  State<CountryTile> createState() => _CountryTileState();
}

class _CountryTileState extends State<CountryTile> {
  final UserController userController = GetIt.instance.get<UserController>();

  @override
  Widget build(BuildContext context) {
    return CustomSettingsTile(
      title: 'Location customization',
      subtitle: userController.accountSettings!.country??'',
      leading: const Icon(Icons.location_on_outlined),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LocationCustomization(),
          ),
        );
        setState(() {});
      },
    );
  }
}
