import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reddit/widgets/Search/comments_search.dart';
import 'package:reddit/widgets/Search/communities_search.dart';
import 'package:reddit/widgets/Search/people_list.dart';
import 'package:reddit/widgets/Search/post_search.dart';
import 'package:reddit/widgets/Search/user_suggestion.dart';

class BlockSearch extends SearchDelegate {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SuggestUsers(search: query),
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

  @override
  String get searchFieldLabel => 'Block new user';

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SuggestUsers(search: query),
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
