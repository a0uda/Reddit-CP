import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Search/comments_search.dart';
import 'package:reddit/widgets/Search/communities_search.dart';
import 'package:reddit/widgets/Search/people_list.dart';
import 'package:reddit/widgets/Search/post_search.dart';

class SearchTrendBody extends StatefulWidget {
  final String search;
  const SearchTrendBody({super.key , required this.search});

  @override
  State<SearchTrendBody> createState() => _SearchTrendBodyState();
}

class _SearchTrendBodyState extends State<SearchTrendBody> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
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
                  searchFor: widget.search,
                  inCommunity: false,
                ),
                // Content for Array 2
                CommunitiesSearch(searchFor: widget.search),
                // Content for Array 3
                CommentsSearch(
                  searchFor: widget.search,
                  inComm: false,
                ),
                PeopleList(
                  searchFor: widget.search,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
