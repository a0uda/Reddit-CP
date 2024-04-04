import 'package:flutter/material.dart';
import 'package:reddit/widgets/custom_settings_tile.dart';

class CustomStatefulSettingsTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget leading;

  final Function(bool) onChanged;
  final VoidCallback onTap;

  const CustomStatefulSettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    required this.onChanged,
    required this.onTap,
  });

  @override
  State<CustomStatefulSettingsTile> createState() =>
      _CustomStatefulSettingsTileState();
}

class _CustomStatefulSettingsTileState
    extends State<CustomStatefulSettingsTile> {
  bool _isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return CustomSettingsTile(
      title: widget.title,
      subtitle: widget.subtitle,
      leading: widget.leading,
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
            widget.onChanged(value);
          }),
      onTap: widget.onTap,
    );
  }
}
