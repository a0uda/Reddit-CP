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

  String needReviewTitle = 'Unmoderated';
  String postsAndCommentsTitle = 'Posts and Comments';
  String newestFirstTitle = 'Newest First';

  Color greyColor = const Color.fromARGB(255, 247, 247, 247);

  bool isReportedFetched = false;
  bool isRemovedFetched = false;
  bool isUnmoderatedFetched = false;

  Future<void> fetchRemovedPosts(
      String timeFilter, String postsOrComments) async {
    // await moderatorController.getRemovedItems(
    //     communityName: moderatorController.communityName,
    //     timeFilter: timeFilter,
    //     postsOrComments: postsOrComments);
  }

  Future<void> fetchReportedPosts(
      String timeFilter, String postsOrComments) async {
    // await moderatorController.getReportedItems(
    //     communityName: moderatorController.communityName,
    //     timeFilter: timeFilter,
    //     postsOrComments: postsOrComments);
  }

  Future<void> fetchUnmoderatedPosts(
      String timeFilter, String postsOrComments) async {
    print('Ana gowa el fetch function');
    print(timeFilter);
    print(postsOrComments);
    await moderatorController.getUnmoderatedItems(
        communityName: moderatorController.communityName,
        timeFilter: timeFilter,
        postsOrComments: postsOrComments);

    List<Future<void>> futures =
        moderatorController.unmoderatedPosts.map((post) => post.getProfilePicture(post.username, moderatorController.communityName)).toList();
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
    print('mohy betest 2');
    print(postsAndCommentsTitle);
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
          IconButton(
              onPressed: () {/*to re-fetch posts again*/},
              icon: const Icon(Icons.refresh))
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
            child: needReviewTitle == "Unmoderated"
                ? FutureBuilder(
                    future: fetchUnmoderatedPosts(
                        newestFirstTitle, postsAndCommentsTitle),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.twoRotatingArc(
                              color: const Color.fromARGB(255, 172, 172, 172),
                              size: 30),
                        );
                      } else {
                        print('Mohy beyshoof el unmoderated');
                        print(moderatorController.unmoderatedPosts);
                        return ListView.builder(
                          itemCount:
                              moderatorController.unmoderatedPosts.length,
                          itemBuilder: (context, index) {
                            final item =
                                moderatorController.unmoderatedPosts[index];
                            return PostModQueue(
                              post: item,
                            );
                          },
                        );
                      }
                    },
                  )
                : needReviewTitle == "Removed"
                    ? FutureBuilder(
                        future: fetchRemovedPosts(
                            newestFirstTitle, postsAndCommentsTitle),
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
                            print(moderatorController.removedPosts);
                            return ListView.builder(
                              itemCount:
                                  moderatorController.removedPosts.length,
                              itemBuilder: (context, index) {
                                final item =
                                    moderatorController.removedPosts[index];
                                return PostModQueue(
                                  post: item,
                                );
                              },
                            );
                          }
                        },
                      )
                    : needReviewTitle == "Reported"
                        ? FutureBuilder(
                            future: fetchReportedPosts(
                                newestFirstTitle, postsAndCommentsTitle),
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
                                print(moderatorController.reportedPosts);
                                return ListView.builder(
                                  itemCount:
                                      moderatorController.reportedPosts.length,
                                  itemBuilder: (context, index) {
                                    final item = moderatorController
                                        .reportedPosts[index];
                                    return PostModQueue(
                                      post: item,
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
            widget.changeNeedsToReviewText(value);
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
            widget.changeNeedsToReviewText(value);
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
            widget.changeNeedsToReviewText(value);
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

            widget.changeNeedsToReviewText(value);
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
            widget.changePostsAndCommentsText(value);
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
            widget.changePostsAndCommentsText(value);
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
            widget.changeNewestFirstText(value);
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
            widget.changeNewestFirstText(value);
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
