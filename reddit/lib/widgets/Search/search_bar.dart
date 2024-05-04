import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reddit/widgets/Search/Suggestions.dart';
import 'package:reddit/widgets/Search/comments_search.dart';
import 'package:reddit/widgets/Search/communities_search.dart';
import 'package:reddit/widgets/Search/people_list.dart';
import 'package:reddit/widgets/Search/post_search.dart';

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
  int index = 0;
  @override
  Widget buildResults(BuildContext context) {
    // List<String> matchQuery = [];
    // for (var fruit in searchTerms) {
    //   if (fruit.toLowerCase().contains(query.toLowerCase())) {
    //     matchQuery.add(fruit);
    //   }
    // }
    double size = MediaQuery.of(context).size.width;
    return DefaultTabController(
      initialIndex: index,
      length: 4,
      child: Column(
        children: [
          TabBar(
            onTap: (value) => {index = value},
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            dividerColor: Colors.grey,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              SizedBox(width: size / 4, child: const Tab(text: 'Posts')),
              SizedBox(width: size / 4, child: const Tab(text: 'Communities')),
              SizedBox(width: size / 4, child: const Tab(text: 'Comments')),
              SizedBox(width: size / 4, child: const Tab(text: 'People')),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Content for Array 1
                PostSearch(
                  searchFor: query,
                  inCommunity: false,
                ),
                // Content for Array 2
                CommunitiesSearch(searchFor: query),
                // Content for Array 3
                CommentsSearch(
                  searchFor: query,
                  inComm: false,
                ),
                PeopleList(
                  searchFor: query,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Search Reddit';



  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SuggestCommunities(search: query),
          Divider(
            height: 0.5,
            color: Colors.grey[200],
          ),
          query.isNotEmpty
              ? Text(
                  'Search for "$query"',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 3, 55, 146),
                      fontWeight: FontWeight.bold),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
