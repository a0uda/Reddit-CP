import 'package:flutter/material.dart';
import 'package:reddit/widgets/report_options.dart';

class Options extends StatefulWidget {
  const Options({
    super.key,
  });

  @override
  Postoptions createState() => Postoptions();
}

class Postoptions extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () => {},
          child: const Row(
            children: [
              Icon(Icons.save),
              SizedBox(
                width: 10,
              ),
              Text("Save")
            ],
          ),
        ),
        // PopupMenuItem 2
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.hide_image),
              SizedBox(
                width: 10,
              ),
              Text("Hide")
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          onTap: () => {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return const SizedBox(
                  height: 100,
                  width: 100,
                  child: AlertDialog(
                    scrollable: true,
                    title: Text('Submit a report'),
                    content: Text(
                        'Thanks for looking out for yourself and your fellow redditors by reporting things that break the rules. Let us know what s happening, and we ll look into it. '),
                    actions: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      ReportOptions(),
                    ],
                  ),
                );
              },
            )
          },
          child: const Row(
            children: [
              Icon(Icons.report),
              SizedBox(
                width: 10,
              ),
              Text("Report")
            ],
          ),
        ),
      ],
      offset: const Offset(0, 25),
      color: Colors.white,
      elevation: 2,
      // on selected we show the dialog box
    );
  }
}
