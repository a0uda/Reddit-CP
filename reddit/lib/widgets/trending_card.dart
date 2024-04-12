import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Models/trending_item.dart';
import 'package:reddit/Services/post_service.dart';

//for merging
class TrendingPost extends StatefulWidget {
  final String title;
  final String imageUrl;

  TrendingPost({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  TrendState createState() => TrendState();
}

class TrendState extends State<TrendingPost> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: InkWell(
        onTap: () => {
          // search for trend
        },
        child: Card(
          child: Container(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.title,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(widget.imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
