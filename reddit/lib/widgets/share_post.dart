import 'package:flutter/material.dart';
import 'package:reddit/widgets/report_question.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:get_it/get_it.dart';

String selectedreport = "";

class ShareOptions extends StatefulWidget {
  final String? postId;
  const ShareOptions({
    required this.postId,
    super.key,
  });

  @override
  ShareOptionsScreen createState() => ShareOptionsScreen();
}

class ShareOptionsScreen extends State<ShareOptions> {
  List<String> shareOptions = [
    
  ];
  var selectedreport = "";
  final postService = GetIt.instance.get<PostService>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;
    bool ismobile = (width < 700) ? true : false;
    return Column(children: [
      
    ]);
  }
}
