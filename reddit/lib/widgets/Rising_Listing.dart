
import 'package:flutter/material.dart';
import 'package:reddit/widgets/post.dart';

class PostItems {
  final String name;
  final String profileImage;
  final String postContent;

  PostItems(this.name, this.profileImage, this.postContent);
}

final List<PostItems> posts = [
  PostItems(
      'Jennifer Lopez',
      'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
'kasdmaklsd askdmlaksd skmlamdlkasd asdmklasm sdkamldklasm askdmlalksmd askldmklamsdlka askldmklasmdlk aksdmlkamsdlk klasmdklasmdkla skmdslamsdlkam asklmdklamsda jkasndklamskldamr'
  ),
   PostItems(
      'Jennifer Lopez',
      'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
'ekremna yarab'
  ),
    PostItems(
      'Jennifer Lopez',
      'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
'ekremna yarab'
  ),
    PostItems(
      'Jennifer Lopez',
      'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
'ekremna yarab'
  ),
    PostItems(
      'Jennifer Lopez',
      'https://www.bing.com/images/search?view=detailV2&ccid=dEsZGs1F&id=2970CE49D1A1E702216D64E53A29F66C2904925B&thid=OIP.dEsZGs1FOiXATGM73lmGpAHaEK&mediaurl=https%3a%2f%2fwww.androidcoding.in%2fwp-content%2fuploads%2fflutter_banner_expandable_listview.png&cdnurl=https%3a%2f%2fth.bing.com%2fth%2fid%2fR.744b191acd453a25c04c633bde5986a4%3frik%3dW5IEKWz2KTrlZA%26pid%3dImgRaw%26r%3d0&exph=720&expw=1280&q=load+more+content+to+the+listview+flutter&simid=608026035302310471&FORM=IRPRST&ck=5447AECA9855B620EA782F85F521470D&selectedIndex=8&itb=0',
'ekremna yarab'
  ),
    PostItems(
      'Jennifer Lopez',
      'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
'ekremna yarab'
  ),
];


class RisingListing extends StatefulWidget {
  const RisingListing({Key? key}) : super(key: key);
  @override
  State<RisingListing> createState() => RisingListingBuild();
  
}

class RisingListingBuild extends State<RisingListing> {
  
  ScrollController controller=ScrollController();

  void initState() {
    super.initState();
    controller = ScrollController()..addListener(HandleScrolling);
  }

  void HandleScrolling() {
   if (controller.position.maxScrollExtent == controller.offset) {

    print('LOAD MORE');
    // load more data 
  
    setState(() {
      
    });
  }
  }


  @override
  Widget build(BuildContext context) {
  
    return   ListView.builder(itemCount: posts.length,
    controller: controller,
      itemBuilder:(context,index){
        return Post(profileImageUrl: posts[index].profileImage, name: posts[index].name, postContent: posts[index].postContent,postView: posts[index].profileImage,date: posts[index].name,);

      },);  
              
    
  }
}
