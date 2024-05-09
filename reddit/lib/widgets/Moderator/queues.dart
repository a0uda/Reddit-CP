import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/widgets/Moderator/post_mod_queue.dart';

class ModQueues extends StatefulWidget {
  const ModQueues({super.key});

  @override
  State<ModQueues> createState() => _ModQueuesState();
}

class _ModQueuesState extends State<ModQueues> {
  final moderatorController = GetIt.instance.get<ModeratorController>();

  String needReviewTitle = 'unmoderated';
  String postsAndCommentsTitle = 'posts and comments';
  String newestFirstTitle = 'Newest First';

  Color greyColor = const Color.fromARGB(255, 247, 247, 247);

  bool isReportedFetched = false;
  bool isRemovedFetched = false;
  bool isUnmoderatedFetched = false;

  void refreshData() async {
    setState(() {
      isReportedFetched = false;
      isRemovedFetched = false;
      isUnmoderatedFetched = false;
    });
    await fetchQueuePosts(
      timeFilter: newestFirstTitle,
      postsOrComments: postsAndCommentsTitle,
      queueType: needReviewTitle,
    );
  }

  Future<void> fetchQueuePosts(
      {required String timeFilter,
      required String postsOrComments,
      required String queueType}) async {
    print('Ana gowa el fetch function');
    print(moderatorController.communityName);
    print(needReviewTitle);
    print(postsAndCommentsTitle);
    print(newestFirstTitle);
    await moderatorController.getQueueItems(
        communityName: moderatorController.communityName,
        timeFilter: timeFilter,
        postsOrComments: postsOrComments,
        queueType: queueType);

    List<Future<void>> futures = moderatorController.queuePosts
        .map((post) => post.getProfilePicture(
            post.username, moderatorController.communityName)
            )
        .toList();
    await Future.wait(futures);
  }

  // Msh helw khales el kalam ely ana 3amlo da
  void changeNeedsToReviewText(String text) {
    setState(() {
      needReviewTitle = text;
    });
    // print('Mohy betest 1');
    // print(needReviewTitle);
  }

  void changePostsAndCommentsText(String text) {
    setState(() {
      postsAndCommentsTitle = text;
    });
    // print('mohy betest 2');
    // print(postsAndCommentsTitle);
  }

  void changeNewestFirstText(String text) {
    setState(() {
      newestFirstTitle = text;
    });
    // print('mohy betest 3');
    // print(newestFirstTitle);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'Queues',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(onPressed: refreshData, icon: const Icon(Icons.refresh))
        ],
        leading: (screenWidth < 700)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })
            : null,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: ModQueuesBar(
                  screenWidth: screenWidth,
                  changeNeedsToReviewText: changeNeedsToReviewText,
                  changePostsAndCommentsText: changePostsAndCommentsText,
                  changeNewestFirstText: changeNewestFirstText)),
          Expanded(
            flex: 8,
            child: needReviewTitle == "unmoderated"
                ? FutureBuilder(
                    future: fetchQueuePosts(
                      timeFilter: newestFirstTitle,
                      postsOrComments: postsAndCommentsTitle,
                      queueType: needReviewTitle,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.twoRotatingArc(
                              color: const Color.fromARGB(255, 172, 172, 172),
                              size: 30),
                        );
                      } else {
                        print('Mohy beyshoof el unmoderated');
                        print(moderatorController.queuePosts);
                        return ListView.builder(
                          itemCount: moderatorController.queuePosts.length,
                          itemBuilder: (context, index) {
                            final item = moderatorController.queuePosts[index];
                            return item.commentInCommunityFlag
                                ? PostModQueue(
                                    post: item,
                                    queueType: needReviewTitle,
                                  )
                                : CommentsModQueue(
                                    post: item,
                                    queueType: needReviewTitle,
                                  );
                          },
                        );
                      }
                    },
                  )
                : needReviewTitle == "removed"
                    ? FutureBuilder(
                        future: fetchQueuePosts(
                          timeFilter: newestFirstTitle,
                          postsOrComments: postsAndCommentsTitle,
                          queueType: needReviewTitle,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: LoadingAnimationWidget.twoRotatingArc(
                                  color:
                                      const Color.fromARGB(255, 172, 172, 172),
                                  size: 30),
                            );
                          } else {
                            print('Mohy beyshoof el removed posts');
                            print(moderatorController.queuePosts);
                            return ListView.builder(
                              itemCount: moderatorController.queuePosts.length,
                              itemBuilder: (context, index) {
                                final item =
                                    moderatorController.queuePosts[index];
                                return item.commentInCommunityFlag
                                    ? PostModQueue(
                                        post: item,
                                        queueType: needReviewTitle,
                                      )
                                    : CommentsModQueue(
                                        post: item,
                                        queueType: needReviewTitle,
                                      );
                              },
                            );
                          }
                        },
                      )
                    : needReviewTitle == "reported"
                        ? FutureBuilder(
                            future: fetchQueuePosts(
                              timeFilter: newestFirstTitle,
                              postsOrComments: postsAndCommentsTitle,
                              queueType: needReviewTitle,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: LoadingAnimationWidget.twoRotatingArc(
                                      color: const Color.fromARGB(
                                          255, 172, 172, 172),
                                      size: 30),
                                );
                              } else {
                                print('Mohy beyshoof el reported');
                                print(moderatorController.queuePosts);
                                return ListView.builder(
                                  itemCount:
                                      moderatorController.queuePosts.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        moderatorController.queuePosts[index];
                                    return item.postInCommunityFlag
                                        ? PostModQueue(
                                            post: item,
                                            queueType: needReviewTitle,
                                          )
                                        : CommentsModQueue(
                                            post: item,
                                            queueType: needReviewTitle,
                                          );
                                  },
                                );
                              }
                            },
                          )
                        : needReviewTitle == "edited"
                            ? FutureBuilder(
                                future: fetchQueuePosts(
                                  timeFilter: newestFirstTitle,
                                  postsOrComments: postsAndCommentsTitle,
                                  queueType: needReviewTitle,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child:
                                          LoadingAnimationWidget.twoRotatingArc(
                                              color: const Color.fromARGB(
                                                  255, 172, 172, 172),
                                              size: 30),
                                    );
                                  } else {
                                    print('Mohy beyshoof el reported');
                                    print(moderatorController.queuePosts);
                                    return ListView.builder(
                                      itemCount:
                                          moderatorController.queuePosts.length,
                                      itemBuilder: (context, index) {
                                        final item = moderatorController
                                            .queuePosts[index];
                                        return item.postInCommunityFlag
                                            ? PostModQueue(
                                                post: item,
                                                queueType: needReviewTitle,
                                              )
                                            : CommentsModQueue(
                                                post: item,
                                                queueType: needReviewTitle,
                                              );
                                      },
                                    );
                                  }
                                },
                              )
                            : const SizedBox(),
          )
        ],
      ),
    );
  }
}

// The upper bar
class ModQueuesBar extends StatefulWidget {
  const ModQueuesBar(
      {super.key,
      required this.screenWidth,
      required this.changeNeedsToReviewText,
      required this.changePostsAndCommentsText,
      required this.changeNewestFirstText});
  final double screenWidth;
  final Function(String) changeNeedsToReviewText;
  final Function(String) changePostsAndCommentsText;
  final Function(String) changeNewestFirstText;

  @override
  State<ModQueuesBar> createState() => _ModQueuesBarState();
}

class _ModQueuesBarState extends State<ModQueuesBar> {
  Color greyColor = const Color.fromARGB(255, 237, 237, 237);

  String needReviewTitle = 'Queues';
  String postsAndCommentsTitle = 'Filter by content';
  String newestFirstTitle = 'Sort by';

  String needReviewDisplay = 'Unmoderated';
  String postsAndCommentsDisplay = 'Posts and Comments';
  String newestFirstDisplay = 'Newest First';

  List<Map<String, dynamic>>? needReviewItems;
  List<Map<String, dynamic>>? postsCommentsItems;
  List<Map<String, dynamic>>? newestFirstItems;
  List<Map<String, bool>>? communityNames; //to be fetched from the database

  void toggleBool(int index, int length, List<Map<String, dynamic>> itemList,
      void Function(String) updateDisplay) {
    setState(() {
      for (int i = 0; i < length; i++) {
        if (index == i) {
          if (!itemList[index]['bool']) {
            itemList[index]['bool'] = !itemList[index]['bool'];
            updateDisplay(itemList[index].keys.first);
          }
        } else {
          itemList[i]['bool'] = false;
        }
      }
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    needReviewItems = [
      {
        'Unmoderated': () {
          // Function for Unmoderated action
          toggleBool(0, needReviewItems!.length, needReviewItems!, (value) {
            setState(() {
              needReviewDisplay = value;
            });
            widget.changeNeedsToReviewText('unmoderated');
          });
        },
        'bool': true
      },
      {
        'Removed': () {
          // Function for Removed action
          toggleBool(1, needReviewItems!.length, needReviewItems!, (value) {
            setState(() {
              needReviewDisplay = value;
            });
            widget.changeNeedsToReviewText('removed');
          });
        },
        'bool': false
      },
      {
        'Reported': () {
          // Function for Reported action
          toggleBool(2, needReviewItems!.length, needReviewItems!, (value) {
            setState(() {
              needReviewDisplay = value;
            });
            widget.changeNeedsToReviewText('reported');
          });
        },
        'bool': false
      },
      {
        'Edited': () {
          // Function for Edited action
          toggleBool(3, needReviewItems!.length, needReviewItems!, (value) {
            setState(() {
              needReviewDisplay = value;
            });

            widget.changeNeedsToReviewText('edited');
          });
        },
        'bool': false
      },
    ];
    postsCommentsItems = [
      {
        'Posts and Comments': () {
          // Function for Posts and Comments action
          toggleBool(0, postsCommentsItems!.length, postsCommentsItems!,
              (value) {
            setState(() {
              postsAndCommentsDisplay = value;
            });
            widget.changePostsAndCommentsText("posts and comments");
          });
        },
        'bool': true
      },
      {
        'Posts Only': () {
          // Function for Posts Only action
          toggleBool(1, postsCommentsItems!.length, postsCommentsItems!,
              (value) {
            setState(() {
              postsAndCommentsDisplay = value;
            });
            widget.changePostsAndCommentsText('posts');
          });
        },
        'bool': false
      },
      {
        'Comments Only': () {
          // Function for Posts Only action
          toggleBool(2, postsCommentsItems!.length, postsCommentsItems!,
              (value) {
            setState(() {
              postsAndCommentsDisplay = value;
            });
            widget.changePostsAndCommentsText('comments');
          });
        },
        'bool': false
      },
    ];
    newestFirstItems = [
      {
        'Newest First': () {
          // Function for Newest First action
          toggleBool(0, newestFirstItems!.length, newestFirstItems!, (value) {
            setState(() {
              newestFirstDisplay = value;
            });
            widget.changeNewestFirstText('Newest First');
          });
        },
        'bool': true
      },
      {
        'Oldest First': () {
          // Function for Oldest First action
          toggleBool(1, newestFirstItems!.length, newestFirstItems!, (value) {
            setState(() {
              newestFirstDisplay = value;
            });
            widget.changeNewestFirstText('Oldest First');
          });
        },
        'bool': false
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: (widget.screenWidth < 700)
          ? EdgeInsets.only(left: widget.screenWidth * 0.03)
          : EdgeInsets.only(left: widget.screenWidth * 0.02),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: [
              OutlinedButtonClass(
                buttonText: needReviewDisplay,
                items: needReviewItems,
                tileTitle: needReviewTitle,
                screenWidth: widget.screenWidth,
              ),
              OutlinedButtonClass(
                buttonText: postsAndCommentsDisplay,
                items: postsCommentsItems,
                tileTitle: postsAndCommentsTitle,
                screenWidth: widget.screenWidth,
              ),
              OutlinedButtonClass(
                buttonText: newestFirstDisplay,
                items: newestFirstItems,
                tileTitle: newestFirstTitle,
                screenWidth: widget.screenWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OutlinedButtonClass extends StatefulWidget {
  const OutlinedButtonClass({
    super.key,
    required this.buttonText,
    required this.items,
    required this.tileTitle,
    required this.screenWidth,
  });

  final String buttonText;
  final List<Map<String, dynamic>>? items;
  final double screenWidth;
  final String tileTitle;

  @override
  State<OutlinedButtonClass> createState() => _OutlinedButtonClassState();
}

class _OutlinedButtonClassState extends State<OutlinedButtonClass> {
  Color greyColor = const Color.fromARGB(255, 237, 237, 237);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton.icon(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                width: widget.screenWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              widget.tileTitle,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close))
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.items!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> item = widget.items![index];
                        final String title = item.keys.first;
                        final Function() onTapFunction = item.values.first;
                        return ListTile(
                          title: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          trailing: item.values.last
                              ? const Icon(
                                  Icons.check,
                                  color: Color.fromARGB(255, 169, 100, 75),
                                )
                              : const SizedBox(),
                          onTap: onTapFunction,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        icon: Text(
          widget.buttonText,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        label: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color.fromARGB(255, 98, 98, 98),
          size: 20,
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: greyColor,
          side: BorderSide(color: greyColor),
          padding:
              const EdgeInsets.only(left: 20, right: 16, top: 16, bottom: 16),
        ),
      ),
    );
  }
}
