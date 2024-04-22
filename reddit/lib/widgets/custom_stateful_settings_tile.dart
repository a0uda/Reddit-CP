import 'package:flutter/material.dart';
import 'package:reddit/widgets/custom_settings_tile.dart';

class CustomStatefulSettingsTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget leading;

  final Function(String, bool)? onChanged;
  final VoidCallback onTap;
  bool switchValue;

  CustomStatefulSettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    this.onChanged,
    required this.onTap,
    required this.switchValue,
  });

  @override
  State<CustomStatefulSettingsTile> createState() =>
      _CustomStatefulSettingsTileState();
}

class _CustomStatefulSettingsTileState
    extends State<CustomStatefulSettingsTile> {
  // bool _isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return CustomSettingsTile(
      title: widget.title,
      subtitle: widget.subtitle,
      leading: widget.leading,
      trailing: Switch(
          value: widget.switchValue,
          thumbColor: MaterialStateProperty.all(Colors.white),
          activeTrackColor: Colors.blue[900],
          inactiveTrackColor: Colors.grey[300],
          trackOutlineColor: MaterialStateProperty.all(Colors.grey[300]),
          onChanged: (value) {
            setState(() {
              widget.switchValue = value;
            });
            widget.onChanged!(widget.title, value);
          }),
      onTap: widget.onTap,
    );
  }
}
