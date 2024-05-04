import 'package:flutter/material.dart';

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
          // search for trend to do badr 

        },
        child: Card(
          child: Container(
            decoration: BoxDecoration(
        
            ),
            child: Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
