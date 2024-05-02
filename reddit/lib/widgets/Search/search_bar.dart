import 'package:flutter/material.dart';
import 'package:reddit/widgets/Search/communities_search.dart';
import 'package:reddit/widgets/Search/people_list.dart';

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
        icon: const Icon(Icons.clear),
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
    // List<String> matchQuery = [];
    // for (var fruit in searchTerms) {
    //   if (fruit.toLowerCase().contains(query.toLowerCase())) {
    //     matchQuery.add(fruit);
    //   }
    // }
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            dividerColor: Colors.grey,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Communities'),
              Tab(text: 'Comments'),
              Tab(text: 'People'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Content for Array 1
                Container(
                  child: Center(
                    child: Text('Content for Array 1'),
                  ),
                ),
                // Content for Array 2
                CommunitiesSearch(searchFor: query),
                // Content for Array 3
                Container(
                  child: Center(
                    child: Text('Content for Array 3'),
                  ),
                ),
                PeopleList(searchFor: query,),
              ],
            ),
          ),
        ],
      ),
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
