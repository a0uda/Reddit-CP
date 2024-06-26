import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/widgets/post.dart';

class EditPost extends StatefulWidget {
  String postId;
  OnEditChanged onEditChanged;
  EditPost({required this.postId, required this.onEditChanged});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final postService = GetIt.instance.get<PostService>();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController bodyController = TextEditingController();
    var postController = context.read<Edit>();
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Edit post',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
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
                    Navigator.of(context).pop();
                    postController.EditPost(widget.postId, bodyController.text);
                    postController.shouldRefresh = true;
                    widget.onEditChanged(bodyController.text);
                  },
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
