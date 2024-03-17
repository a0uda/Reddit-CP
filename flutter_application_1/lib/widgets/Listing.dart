import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/Hot_Listing.dart';
import 'package:flutter_application_1/widgets/Top_Listing.dart';
import 'package:flutter_application_1/widgets/Best_Listing.dart';
import 'package:flutter_application_1/widgets/Rising_Listing.dart';
import 'package:flutter_application_1/widgets/New_Listing.dart';


class Listing extends StatefulWidget {
  const Listing({Key? key}) : super(key: key);
  @override
  State<Listing> createState() => _Listing();
}

class _Listing extends State<Listing> {
  String dropdownvalue = 'Hot';
  String value2 = 'mohamed';
  String value3 = 'ibrahim';
  String value4 = 'mazen';

  // List of items in our dropdown menu
  var items = [
    'Hot',
    'Best',
    'New',
    'Top',
    'Rising',
  ];
  
  // List of items in our dropdown menu


  @override
  Widget build(BuildContext context) {
    return  Container(
              
              color:Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  ListTile( leading:  Container( width: 71,
                  child:  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      // Initial Value
                      value: dropdownvalue,
                      // Down Arrow Icon
                      

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),),),
                  if (dropdownvalue == 'Hot')
                  Expanded(child: HotListing(),),
             
                  if (dropdownvalue == "Best")Expanded(child: BestListing(),),
                  if (dropdownvalue == "New") Expanded(child: NewListing(),),
                  if (dropdownvalue == "Top") Expanded(child: TopListing(),),
                  if (dropdownvalue == "Rising")Expanded(child: RisingListing(),),
                ],
              ),
              // Your content for the second column here
            );
  }
}
