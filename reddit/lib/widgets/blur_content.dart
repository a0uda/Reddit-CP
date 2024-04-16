import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Widget buildBlur({required BuildContext context, required Widget child}) {
  return BackdropFilter(
    filter: ui.ImageFilter.blur(
      sigmaX: 5.0,
      sigmaY: 5.0,
    ),
    child: Container(
      color: Colors.black.withOpacity(0.5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
      ),
    ),
  );
}
