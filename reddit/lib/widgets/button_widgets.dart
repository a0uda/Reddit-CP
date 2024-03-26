import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:google_fonts/google_fonts.dart';

class ButtonWidgets extends StatelessWidget {
  const ButtonWidgets(this.buttonWidgetsText, this.onTap,
      {this.icon, this.backgroundColour, this.foregroundColour, super.key});

  final String buttonWidgetsText;
  final Icon? icon;
  final Color ?backgroundColour;
  final Color ?foregroundColour;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, left: 10),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: backgroundColour == null ? Colors.white : backgroundColour,
          foregroundColor: foregroundColour == null ? const Color.fromARGB(255, 0, 0, 0) : foregroundColour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: const BorderSide(color: Colors.black),
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
              style: TextStyle(
                  color: foregroundColour == null ? const Color.fromARGB(255, 0, 0, 0) : foregroundColour,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
