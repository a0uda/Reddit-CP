// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:reddit/widgets/Search/Suggestions.dart';
// import 'package:reddit/widgets/Search/comments_search.dart';
// import 'package:reddit/widgets/Search/communities_search.dart';
// import 'package:reddit/widgets/Search/people_list.dart';
// import 'package:reddit/widgets/Search/post_search.dart';

// class SearchInCommunity extends SearchDelegate {
//   final String communityName;
//   SearchInCommunity({required this.communityName});

// // first overwrite to
// // clear the search text
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: const Icon(Icons.clear_rounded),
//       ),
//     ];
//   }

// // second overwrite to pop out of search menu
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         close(context, null);
//       },
//       icon: const Icon(Icons.arrow_back),
//     );
//   }

// // third overwrite to show query result
//   int index = 0;
//   @override
//   Widget buildResults(BuildContext context) {
//     double size = MediaQuery.of(context).size.width;
//     return DefaultTabController(
//       initialIndex: index,
//       length: 2,
//       child: Column(
//         children: [
//           TabBar(
//             onTap: (value) => {index = value},
//             tabAlignment: TabAlignment.start,
//             isScrollable: true,
//             dividerColor: Colors.grey,
//             indicatorColor: Colors.black,
//             labelColor: Colors.black,
//             unselectedLabelColor: Colors.grey,
//             tabs: [
//               SizedBox(width: size / 2, child: const Tab(text: 'Posts')),
//               SizedBox(width: size / 2, child: const Tab(text: 'People')),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 // Content for Array 1
//                 PostSearch(searchFor: query),
//                 // Content for Array 3
//                 CommentsSearch(searchFor: query),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   String get searchFieldLabel => 'Search r/$communityName';

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return const SizedBox();
//   }

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     return ThemeData(
//       appBarTheme: AppBarTheme(
//         elevation: 0,
//         color: Colors.blue[850],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reddit/widgets/Search/list_in_community.dart';

class SearchInCommunity extends StatefulWidget {
  final String communityName;
  const SearchInCommunity({super.key, required this.communityName});

  @override
  State<SearchInCommunity> createState() => _SearchInCommunityState();
}

class _SearchInCommunityState extends State<SearchInCommunity> {
  bool isSubmitted = false;
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 4, 64, 168),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Container(
            padding: const EdgeInsets.all(5),
            height: kToolbarHeight - 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(CupertinoIcons.search),
                const SizedBox(
                    width: 4), // Add space between text and container
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 4, 64, 168),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "r/${widget.communityName}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        isSubmitted = false;
                      });
                    },
                    onSubmitted: (query) {
                      searchText = query;
                      setState(() {
                        isSubmitted = true;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: isSubmitted
          ? ListInCommunity(
              query: searchText,
              name: widget.communityName,
            )
          : null,
    );
  }
}
