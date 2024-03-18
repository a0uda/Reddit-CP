//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/widgets.dart';
import 'package:reddit/widgets/Listing.dart';
//import 'package:get/get.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => HomePageBuild();
}

class HomePageBuild extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool mobile = width < 800 ? true : false;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      
      body: Row(
        children: <Widget>[
          if (!mobile)
            Expanded(
              flex: 1,
              child: Container(
                color:Theme.of(context).colorScheme.background,
                // Your content for the first column here
              ),
            ),
          Expanded(
            flex: 4,
            child:Listing(),
          ),
        ],
      ),
    );

  
  }
}


