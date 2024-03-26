import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Widget buildBlur({required BuildContext context, required Widget child}) {
  return Stack(
    children: <Widget>[
      child,
      BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 2.0,
        ),
        child: Container(
          child: child,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      const Center(
        child: Row(
          children: [Icon(Icons.warning), Text("NSFW Content")],
        ),
      ),
    ],
  );
}
