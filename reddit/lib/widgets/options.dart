import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/widgets/report_options.dart';

class Options extends StatefulWidget {
  final String? postId;
  final bool saved;
  bool islocked;
  final bool isMyPost;
  Options({
    required this.postId,
    required this.saved,
    required this.islocked,
    required this.isMyPost,
    super.key,
  });

  @override
  Postoptions createState() => Postoptions();
}

final userController = GetIt.instance.get<UserController>();
final postService = GetIt.instance.get<PostService>();

class Postoptions extends State<Options> {
  @override
  Widget build(BuildContext context) {
    var postController = context.read<SavePost>();
    String username = userController.userAbout!.username;
    bool isMyPost = widget.isMyPost;
    var heigth = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool ismobile = (width < 700) ? true : false;
    var postLockController = context.read<LockPost>();
    return (!ismobile)
        ? PopupMenuButton<int>(
            icon: const Icon(Icons.more_horiz),
            itemBuilder: (context) => [
              (!widget.saved)
                  ? PopupMenuItem(
                      value: 1,
                      onTap: () => {
                        //save todo
                        postService.savePost(widget.postId, username),
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.save),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Save")
                        ],
                      ),
                    )
                  : PopupMenuItem(
                      value: 1,
                      onTap: () => {
                        //save todo
                        postController.unSavePost(widget.postId, username),
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.save),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Unsave")
                        ],
                      ),
                    ),
              // PopupMenuItem 2
              const PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.hide_image),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Hide")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                onTap: () => {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        scrollable: true,
                        title: const Text('Submit a report'),
                        content: Builder(
                          builder: ((context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                children: [
                                  const Text(
                                      "Thanks for looking out for yourself and your fellow redditors by reporting things that break the rules. Let us know what's happening, and we'll look into it"),
                                  ReportOptions(
                                    postId: widget.postId,
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  )
                },
                child: const Row(
                  children: [
                    Icon(Icons.report),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Report")
                  ],
                ),
              ),
              if (isMyPost)
                PopupMenuItem(
                  value: 4,
                  onTap: () {
                    postLockController.lockPost(widget.postId!);
                    setState(
                        () {}); // Call setState to rebuild the widget with new values
                  },
                  child: Row(
                    children: [
                      Icon(widget.islocked
                          ? Icons.lock_open
                          : Icons.lock_outline),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                          widget.islocked ? "Unlock Comments" : "Lock Comments")
                    ],
                  ),
                ),
            ],
            offset: const Offset(0, 25),
            color: Colors.white,
            elevation: 2,
            // on selected we show the dialog box
          )
        : IconButton(
            onPressed: () => {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Container(
                        height: heigth * 0.3,
                        width: width,
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.report,
                                color: Colors.red,
                              ),
                              title: const Text("Report"),
                              onTap: () => {
                                Navigator.of(context).pop(),
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                          height: heigth * 0.9,
                                          width: width,
                                          child: Column(children: [
                                            const ListTile(
                                              leading: Text(
                                                "Submit report",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            const ListTile(
                                              leading: Text(
                                                  "Thanks for looking out for yourself"),
                                            ),
                                            ReportOptions(
                                              postId: widget.postId,
                                            )
                                          ]));
                                    })
                              },
                            ),
                            (!widget.saved)
                                ? ListTile(
                                    leading: const Icon(Icons.save),
                                    title: const Text("Save"),
                                    onTap: () => {
                                      //todo
                                      postService.savePost(
                                          widget.postId, username),
                                      Navigator.of(context).pop(),
                                    },
                                  )
                                : ListTile(
                                    leading: const Icon(Icons.save),
                                    title: const Text("Unsave"),
                                    onTap: () => {
                                      //todo
                                      postController.unSavePost(
                                          widget.postId, username),

                                      Navigator.of(context).pop(),
                                    },
                                  ),
                            if (isMyPost)
                              ListTile(
                                leading: Icon(widget.islocked
                                    ? Icons.lock_open
                                    : Icons.lock),
                                title: Text(widget.islocked
                                    ? "Unlock Comments"
                                    : "Lock Comments"),
                                onTap: () {
                                  setState(() {
                                    postLockController.lockPost(widget.postId!);
                                    widget.islocked = !widget.islocked;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            //
                          ],
                        ),
                      );
                    },
                  ),
                },
            icon: const Icon(Icons.more_horiz));
  }
}
