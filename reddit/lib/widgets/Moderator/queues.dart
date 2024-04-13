import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/test_files/test_posts_mohy.dart';
import 'package:reddit/widgets/post.dart';

class ModQueues extends StatefulWidget {
  const ModQueues({super.key});

  @override
  State<ModQueues> createState() => _ModQueuesState();
}

class _ModQueuesState extends State<ModQueues> {
  Color greyColor = const Color.fromARGB(255, 247, 247, 247);
  bool isSaved = false;
  bool doneSaved = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingPercentage = 0.1;
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
      backgroundColor: greyColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: ModQueuesBar(screenWidth: screenWidth)),
          Expanded(
            flex: 8,
            child: Container(
              color: greyColor,
              margin: EdgeInsets.symmetric(
                  horizontal: paddingPercentage * screenWidth, vertical: 8),
              child: ListView.builder(
                itemCount: testPosts.length,
                itemBuilder: (context, index) {
                  return Post(
                      id: "$index",
                      isLocked: false,
                      imageUrl: testPosts[index].imageUrl,
                      name: testPosts[index].name,
                      title: testPosts[index].title,
                      postContent: testPosts[index].postContent,
                      date: testPosts[index].date,
                      likes: testPosts[index].likes,
                      commentsCount: testPosts[index].commentsCount,
                      communityName: testPosts[index].communityName);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// The upper bar
class ModQueuesBar extends StatefulWidget {
  const ModQueuesBar({super.key, required this.screenWidth});
  final double screenWidth;

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

  void toggleCheckList(int index) {
    if (communityNames != null) {
      setState(() {
        communityNames![index]['bool'] = !communityNames![index]['bool']!;
      });
    }
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
          });
        },
        'bool': false
      },
    ];
    communityNames = [
      {'badrbeyheb': true},
      {'ModeratorSw': false},
      {'Flutter testing': false},
      {'benhebAbdullah': false}
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: (widget.screenWidth <700)?EdgeInsets.only(left: widget.screenWidth * 0.03):EdgeInsets.only(left: widget.screenWidth * 0.02),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        margin:
                            const EdgeInsets.only(left: 16, top: 16, right: 16),
                        width: widget.screenWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: const Text(
                                    'Filter by community',
                                    style: TextStyle(
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
                            const Divider(
                              thickness: 1,
                              color: Color.fromARGB(255, 213, 213, 213),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: const Text(
                                    'All communities',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: communityNames!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Map<String, dynamic> item =
                                    communityNames![index];
                                final String title = item.keys.first;
                                final bool itemBool = item.values.first;
                                return ListTile(
                                  title: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  trailing: Checkbox(
                                      value: itemBool,
                                      onChanged: (value) {
                                        setState(() {
                                          toggleCheckList(index);
                                        });
                                      }),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.reddit,
                  color: Colors.black,
                ),
                label: const Text(
                  'badrbeyeb',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: greyColor,
                  side: BorderSide(color: greyColor),
                ),
              ),
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
