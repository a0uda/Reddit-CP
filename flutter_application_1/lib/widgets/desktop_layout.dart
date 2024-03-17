import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/drawer_reddit.dart';

class DesktopHomePage extends StatefulWidget {
  final int indexOfPage;
  const DesktopHomePage({super.key, required this.indexOfPage});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerScrimColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: ElevatedButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchBarClass());
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey,
                  shadowColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              child: const Row(
                children: [
                  Icon(Icons.search , color: Colors.black,),
                  Text("Search...")]
                ),
              onHover: (test) {
                test = false;
              },
            ),
          ),
          shadowColor: Colors.black,
          elevation: 0.5,
        ),
        body: Row(
          children: [
            DrawerReddit(
              indexOfPage: widget.indexOfPage,
              inHome: true,
            ),
            const VerticalDivider(
              color: Colors.grey,
              width: 0,
            ),
            const Text("YARAABBBBB") // rest of the desktop home page
          ],
        ));
  }
}

class SearchBarClass extends SearchDelegate {
// Demo list to show querying
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries"
  ];

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
