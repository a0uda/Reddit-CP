import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Search/search_trend_body.dart';

class SearchTrending extends StatefulWidget {
  final String result;
  const SearchTrending({super.key, required this.result});

  @override
  State<SearchTrending> createState() => _SearchTrendingState();
}

class _SearchTrendingState extends State<SearchTrending> {
  int index = 0;
  TextEditingController searchController = TextEditingController();
  bool isSubmit = true;

  @override
  void initState() {
    super.initState();
    searchController.text = widget.result;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
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

                Flexible(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        isSubmit = false;
                      });
                    },
                    onSubmitted: (value) {
                      setState(() {
                        isSubmit = true;
                      });
                    },
                    controller: searchController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: isSubmit
          ? SearchTrendBody(
              search: searchController.text,
            )
          : null,
    );
  }
}
