import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/widgets/hot_listing.dart';
import 'package:reddit/widgets/top_listing.dart';
import 'package:reddit/widgets/best_listing.dart';
import 'package:reddit/widgets/Rising_Listing.dart';
import 'package:reddit/widgets/new_listing.dart';
import 'package:reddit/widgets/trending_card.dart';
import 'package:reddit/Models/user_about.dart';
import '../Models/trending_item.dart';

class Listing extends StatefulWidget {
  final String type;
  final int? comId;
  final UserAbout? userData;

  const Listing({super.key, required this.type,
  this.comId, this.userData});
  @override
  State<Listing> createState() => _Listing();
}

final postService = GetIt.instance.get<PostService>();
List<TrendingItem> trends = postService.getTrendingPosts();

class _Listing extends State<Listing> {
  String dropdownvalue = 'Hot';

  // List of items in our dropdown menu
  var items = [
    'Hot',
    'Best',
    'New',
    'Top',
    'Random',
  ];

  // List of items in our dropdown menu

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          (widget.type=="popular")?
          Container(
            child:Align(
              alignment: Alignment.topCenter,
              child:Text('Trending Today'))
           ,):Container(),
          
        
        
          (widget.type == "popular") 
              ? Container(
                height:  MediaQuery.of(context).size.height * 0.2,
 
                child:  ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trends.length,
                  itemBuilder: (context, index) {
                    return TrendingPost(
                      title: trends[index].title,
                      imageUrl: trends[index].picture.path,
                    );
                  },
                ),)
              : Container(),
          ListTile(
            leading: Container(
              // width: 71,
              // height: 70,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  // Initial Value
                  value: dropdownvalue,
                  // Down Arrow Icon

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),
          if (dropdownvalue == 'Hot')
            Expanded(
              child: HotListing(
                type: widget.type,
                userData: widget.userData,
              ),
            ),
          if (dropdownvalue == "Best")
            Expanded(
              child: BestListing(
                type: widget.type,
                    userData: widget.userData,
              ),
            ),
          if (dropdownvalue == "New")
            Expanded(
              child: NewListing(
                type: widget.type,
                    userData: widget.userData,
              ),
            ),
          if (dropdownvalue == "Top")
            Expanded(
              child: TopListing(
                type: widget.type,
                userData: widget.userData,
              ),
            ),
          if (dropdownvalue == "Random")
            Expanded(
              child: RisingListing(
                type: widget.type,
                 userData: widget.userData,
              ),
            ),
        ],
      ),
      // Your content for the second column here
    );
  }
}
