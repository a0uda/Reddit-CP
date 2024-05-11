import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/post_service.dart';

class AddtextShare extends StatefulWidget {
  String comName;
  String postId;
  AddtextShare({required this.comName, required this.postId});

  @override
  _AddtextShareState createState() => _AddtextShareState();
}

class _AddtextShareState extends State<AddtextShare> {
  final postService = GetIt.instance.get<PostService>();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController bodyController = TextEditingController();
    String name = widget.comName;
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Share to ...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                 (name!="")? Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '$name',
                      style: TextStyle(),
                    ),
                  ): Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'your profile',
                      style: TextStyle(),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: bodyController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Add your Text...',
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 55, 146)),
                  onPressed: () {

                    if (widget.comName != "") {
                      postService.SharePost(widget.postId, name, bodyController.text, true);
                    } else {
                      postService.SharePost(widget.postId, name, bodyController.text, false);


                    }
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.file_upload_outlined, color: Colors.white),
                  label: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
