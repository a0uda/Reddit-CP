import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Report.dart';
import 'package:reddit/widgets/Video_player.dart';

class Post extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final String postContent;
  final String postView;
  final String date;
  const Post({
    Key? key,
    required this.profileImageUrl,
    required this.name,
    required this.postContent,
    required this.postView,
    required this.date,
  }) : super(key: key);

  @override
  PostState createState() => PostState();
}

int counter = 0;
bool isLiked = false;

class PostState extends State<Post> {
  
  void IncrementCounter() {
    setState(() {
      if(isLiked==false){
      counter++;
      isLiked = !isLiked;
      }
    });
  }

  void DecrementCounter() {
    setState(() {
      if (isLiked==true) {
        counter--;
        isLiked = !isLiked;
      }
    });
  }

  // List of items in our dropdown menu

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        // open this post
      },
      child: Card(
        color: Theme.of(context).colorScheme.background,
        shadowColor: Theme.of(context).colorScheme.background,
        surfaceTintColor:Theme.of(context).colorScheme.background,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.profileImageUrl),
              ),
              title: Row(
                children: [
                  Text(widget.name),
                  Padding(padding: EdgeInsets.all(2.0)),
                  Text(widget.date,style: TextStyle(color: const Color.fromARGB(255, 117, 116, 115)),)
                ],
              ),
              trailing: Options(),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.postContent,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    // Border width
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        shape: BoxShape.rectangle),
                    child: VideoApp(),
                  )
                ],

              
              ),
            ),
            ListTile( title:Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_upward_outlined),
                  onPressed: () {
         
                    IncrementCounter();
                  },
                ),
                Text(
                  '$counter',
                  style: TextStyle(fontSize: 24,),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward_outlined),
                  onPressed: () {
                  
                    DecrementCounter();
                  },
                ),
              
                IconButton(
                  icon: Icon(Icons.comment),
                  
                  onPressed: () {
                    // Handle comments
                  },
                ),
                Text('Comments'),
              ],
                ),
               trailing: IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // Handle shares
                  },
            ),
            ),
          ],
        ),
      ),
    );
  }
}
