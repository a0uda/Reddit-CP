import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/post_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/widgets/delete_post.dart';
import 'package:reddit/widgets/edit_post.dart';
import 'package:reddit/widgets/post.dart';
import 'package:reddit/widgets/report_options.dart';

class Options extends StatefulWidget {
  final String? postId;

  bool saved;
  bool islocked;
  final bool isMyPost;
  final String username;
  final OnSaveChanged onSaveChanged;
  final OnlockChanged onLockChanged;

  OnEditChanged onEditChanged;
  OnDeleteChanged onDeleteChanged;
  Options({
    required this.username,
    required this.postId,
    required this.saved,
    required this.islocked,
    required this.isMyPost,
    required this.onSaveChanged,
    required this.onLockChanged,
    required this.onEditChanged,
    required this.onDeleteChanged,
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
    bool isMyPost = (username == widget.username) ? true : false;
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
                        setState(() {
                          widget.saved = true;
                        }),
                        widget.onSaveChanged(true),
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
                        postController.savePost(widget.postId, username),
                        widget.onSaveChanged(false),
                        setState(() {
                          widget.saved = false;
                        })
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
                    widget.onLockChanged(!widget.islocked);
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

              if (isMyPost)
                PopupMenuItem(
                  value: 4,
                  onTap: () {
                    ///todo edit
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          content: Builder(
                            builder: ((context) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: EditPost(
                                    postId: widget.postId!,
                                    onEditChanged: widget.onEditChanged),
                              );
                            }),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Edit')
                    ],
                  ),
                ),
              if (isMyPost)
                PopupMenuItem(
                    onTap: () {
                      //to do delete
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            content: Builder(
                              builder: ((context) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: DeletePost(
                                    onDeleteChanged: widget.onDeleteChanged,
                                    postId: widget.postId!,
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      );
                    },
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Delete")
                      ],
                    )),
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
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24))),
                        height: heigth * 0.4,
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
                                      return Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(24),
                                                  topRight:
                                                      Radius.circular(24))),
                                          height: heigth * 0.87,
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
                                    onTap: () async {
                                      //todo
                                      await postController.savePost(
                                          widget.postId, username);
                                      Navigator.of(context).pop(true);
                                      setState(() {
                                        widget.saved = true;
                                      });
                                      widget.onSaveChanged(true);
                                    },
                                  )
                                : ListTile(
                                    leading: const Icon(Icons.save),
                                    title: const Text("Unsave"),
                                    onTap: () async {
                                      widget.onSaveChanged(false);

                                      //todo
                                      await postController.savePost(
                                          widget.postId, username);
                                      Navigator.of(context).pop(false);
                                      setState(() {
                                        widget.saved = false;
                                      });
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
                                  Navigator.of(context).pop();
                                  widget.onLockChanged(!widget.islocked);
                                  setState(() {
                                    postLockController.lockPost(widget.postId!);
                                    widget.islocked = !widget.islocked;
                                  });
                                },
                              ),
                            if (isMyPost)
                              ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(24),
                                                  topRight:
                                                      Radius.circular(24))),
                                          height: heigth * 0.8,
                                          width: width,
                                          padding: const EdgeInsets.all(16.0),
                                          child: EditPost(
                                              postId: widget.postId!,
                                              onEditChanged:
                                                  widget.onEditChanged),
                                        );
                                      });
                                },
                              ),

                            if (isMyPost)
                              ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                                onTap: () {
                                  Navigator.of(context).pop();

                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(24),
                                                  topRight:
                                                      Radius.circular(24))),
                                          height: heigth * 0.3,
                                          width: width,
                                          padding: const EdgeInsets.all(16.0),
                                          child: DeletePost(
                                            onDeleteChanged:
                                                widget.onDeleteChanged,
                                            postId: widget.postId!,
                                          ),
                                        );
                                      });
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
