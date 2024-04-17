import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';

class LocationCustomization extends StatefulWidget {
  const LocationCustomization({super.key});

  @override
  State<LocationCustomization> createState() => _LocationCustomizationState();
}

List<String> locations = [
  'United States',
  'Canada',
  'United Kingdom',
  'Australia',
  'India',
  'Japan',
  'South Korea',
  'China',
  'Germany',
  'France',
  'Italy',
  'Spain',
  'Brazil',
  'Mexico',
  'Argentina',
  'South Africa',
  'Nigeria',
  'Egypt',
  'Kenya',
  'Saudi Arabia',
  'United Arab Emirates',
];

class _LocationCustomizationState extends State<LocationCustomization> {
  final UserController userController = GetIt.instance.get<UserController>();

  @override
  Widget build(BuildContext context) {
    String selectedLocation = userController.userAbout?.country ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(locations[index]),
            leading: Radio(
              activeColor: Colors.blue[900],
              value: locations[index],
              groupValue: selectedLocation,
              onChanged: (String? value) {
                setState(() {
                  selectedLocation = value!;
                  userController.changeCountry(
                      userController.userAbout!.username, value);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
