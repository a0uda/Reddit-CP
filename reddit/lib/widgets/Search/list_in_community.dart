import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Search/comments_search.dart';
import 'package:reddit/widgets/Search/post_search.dart';

class ListInCommunity extends StatefulWidget {
  final String query;
  final String name;
  const ListInCommunity({super.key, required this.query, required this.name});

  @override
  State<ListInCommunity> createState() => _ListInCommunityState();
}

class _ListInCommunityState extends State<ListInCommunity> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return DefaultTabController(
      initialIndex: index,
      length: 2,
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
              SizedBox(width: size / 2, child: const Tab(text: 'Posts')),
              SizedBox(width: size / 2, child: const Tab(text: 'Comments')),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Content for Array 1
                PostSearch(
                  searchFor: widget.query,
                  communityName: widget.name,
                  inCommunity: true,
                ),
                // Content for Array 3
                CommentsSearch(
                  searchFor: widget.query,
                  name: widget.name,
                  inComm: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
