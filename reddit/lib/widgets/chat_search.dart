import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reddit/widgets/Search/Suggestions.dart';
import 'package:reddit/widgets/Search/comments_search.dart';
import 'package:reddit/widgets/Search/communities_search.dart';
import 'package:reddit/widgets/Search/people_list.dart';
import 'package:reddit/widgets/Search/post_search.dart';

class ChatSearch extends SearchDelegate {
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
    return PeopleList(searchFor: query , inChat: true,);
  }

  @override
  String get searchFieldLabel => 'Search people';

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox();
  }
}
