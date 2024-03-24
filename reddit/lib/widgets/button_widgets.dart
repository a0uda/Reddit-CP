import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:google_fonts/google_fonts.dart';

class ButtonWidgets extends StatelessWidget {
  const ButtonWidgets(this.buttonWidgetsText, this.onTap,
      {this.icon, super.key});

  final String buttonWidgetsText;
  final Icon? icon;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, left: 10),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: const BorderSide(color: Color.fromARGB(0, 238, 12, 0)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!],
            const SizedBox(
              width: 2,
            ),
            Text(
              buttonWidgetsText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color.fromARGB(255, 144, 144, 144),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
