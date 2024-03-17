import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/reportoptions.dart';

class Options extends StatefulWidget {
  const Options({
    Key? key,
  }) : super(key: key);

  @override
  Postoptions createState() => Postoptions();
}

class Postoptions extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_horiz),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () => {},
          child: Row(
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
        PopupMenuItem(
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
                return Container(
                height: 100,
                width: 100,
                  child: AlertDialog(
                    scrollable: true,
                    title: Text('Submit a report'),
                    content: Text(
                        'Thanks for looking out for yourself and your fellow redditors by reporting things that break the rules. Let us know what s happening, and we ll look into it. '),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),
                      Report_Options(),
                    
                    ],
                  ),
                );
              },
            )
          },
          child: Row(
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
      offset: Offset(0, 25),
      color: Colors.grey,
      elevation: 2,
      // on selected we show the dialog box
    );
  }
}
