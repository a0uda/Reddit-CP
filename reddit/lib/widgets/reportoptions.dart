import 'package:flutter/material.dart';

  String selectedreport = "";
class Report_Options extends StatefulWidget {
  const Report_Options({
    Key? key,
  }) : super(key: key);

  @override
  Report createState() => Report();
}

class Report extends State<Report_Options> {
  List<String> Reportoptions = [
    'Harassment',
    'Threating violence',
    'Hate',
    'Minor abuse or sexualization',
    'sharing personal information',
    'Spam',
    'Copyright',
    'Sharing personal information',
    'Non-consensual intimate media',
    'Prohibited transaction',
    'Impersonation',
    'Self-harm or suicide',
    'Trademark violation',

  ];
  var selectedreport = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [ Wrap(
      children: Reportoptions.map(
        (hobby) {
          bool isSelected = false;
          if (selectedreport == hobby) {
            isSelected = true;
          }
          return InkWell(
            onTap: () {
              if (selectedreport != hobby) {
                selectedreport = hobby;
                setState(() {});
                
              }
              else
              {
                selectedreport ="";
                setState(() {});
              }
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: isSelected ? Colors.deepOrange : Colors.grey,
                          width: 2)),
                  child: Text(
                    hobby,
                    style: TextStyle(
                        color: isSelected ? Colors.deepOrange : Colors.grey,
                        fontSize: 14),
                  ),
                )),
          );
        },
      ).toList(),

     ),
       TextButton(
                        onPressed: () => {},
                        child: Text('Next',style: TextStyle(color:Colors.white70 ),),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (selectedreport == "") {
                              return Colors.grey;
                            } else {
                              return Colors.deepOrange;
                            }
                          }),
                        ),
                      )] );
    
  }
}
