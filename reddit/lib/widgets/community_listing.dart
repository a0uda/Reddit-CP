import 'package:flutter/material.dart';
import 'package:reddit/widgets/hot_listing.dart';
import 'package:reddit/widgets/top_listing.dart';
import 'package:reddit/widgets/best_listing.dart';
import 'package:reddit/widgets/Rising_Listing.dart';
import 'package:reddit/widgets/new_listing.dart';

class Listing extends StatefulWidget {
  const Listing({super.key});
  @override
  State<Listing> createState() => _Listing();
}

class _Listing extends State<Listing> {
  String dropdownvalue = 'Hot';

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
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          ListTile(
            leading: DropdownButtonHideUnderline(
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
            ),
          ),
          if (dropdownvalue == 'Hot')
            const Expanded(
              child: HotListing(),
            ),
          if (dropdownvalue == "Best")
            const Expanded(
              child: BestListing(),
            ),
          if (dropdownvalue == "New")
            const Expanded(
              child: NewListing(),
            ),
          if (dropdownvalue == "Top")
            const Expanded(
              child: TopListing(),
            ),
          if (dropdownvalue == "Rising")
            const Expanded(
              child: RisingListing(),
            ),
        ],
      ),
      // Your content for the second column here
    );
  }
}
