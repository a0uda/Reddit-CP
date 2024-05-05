import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';

class CustomSettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget leading;
  final Widget trailing;
  final VoidCallback onTap;

  const CustomSettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leading,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeEmail>(
      builder: (context, theme, child) {
        return Container(
          color: Colors.white,
          child: ListTile(
            title: Text(
              title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
            subtitle: (subtitle != null) ? Text(subtitle!) : null,
            leading: leading,
            trailing: trailing,
            onTap: onTap,
          ),
        );
      },
    );
  }
}
