import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/widgets/post.dart';

class DeletePost extends StatefulWidget {
  String postId;
  OnDeleteChanged onDeleteChanged;
  DeletePost({required this.postId, required this.onDeleteChanged});

  @override
  _DeletePostState createState() => _DeletePostState();
}

class _DeletePostState extends State<DeletePost> {
  final postService = GetIt.instance.get<PostService>();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var postController = context.read<Edit>();
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Delete post',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Align(
              alignment: Alignment.center,
              child:
                  Text('Are you sure you want to delete?', style: TextStyle()),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Align(
              alignment: Alignment.bottomCenter,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Align(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 242, 243, 245),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close,
                        color: const Color.fromARGB(255, 109, 109, 110)),
                    label: Text(
                      'No',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 109, 109, 110)),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(15)),
                Align(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 240, 6, 6)),
                    onPressed: () {
                      postController.DeletePost(widget.postId);
                      postController.shouldRefresh = true;
                      widget.onDeleteChanged(true);
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.delete, color: Colors.white),
                    label: Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }
}
