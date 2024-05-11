import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/user_about.dart';
import 'package:reddit/Services/moderator_service.dart';
import 'package:reddit/Services/post_service.dart';
import 'package:reddit/Services/search_service.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/Search/post_ui.dart';

class PostSearch extends StatefulWidget {
  final String searchFor;
  final bool inCommunity;
  final String communityName;
  const PostSearch(
      {super.key,
      required this.searchFor,
      required this.inCommunity,
      this.communityName = ""});

  @override
  State<PostSearch> createState() => _CommentsSearchState();
}

class _CommentsSearchState extends State<PostSearch> {
  final UserController userController = GetIt.instance.get<UserController>();
  final SearchService searchService = GetIt.instance.get<SearchService>();
  final UserService userService = GetIt.instance.get<UserService>();
  final ModeratorMockService moderatorService =
      GetIt.instance.get<ModeratorMockService>();
  PostService postService = GetIt.instance.get<PostService>();
  List<Map<String, dynamic>> foundPosts = [];
  List<Map<String, dynamic>> temp = [];
  String searchFor = "";
  String selectedOption = "relevance";
  String selectedTimeOption = "allTime";
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

  Future<void> getExtraData(Map<String, dynamic> post) async {
    {
      print("POSTAYAAAA");
      print(post["title"]);
      print(post["community_name"]);
      print(post["username"]);
      print(post["created_at"]);
      print(post["nsfw_flag"]);
      print(post["type"]);
      if (!post.containsKey("is_reposted_flag")) {
        post["is_reposted_flag"] = false;
      }
      if (post.containsKey("post_in_community_flag") &&
          post["post_in_community_flag"]) {
        Map<String, dynamic> comm = await moderatorService.getCommunityInfo(
            communityName: post["community_name"]);
        post["community_profile_picture"] = comm["communityProfilePicture"];
      } else {
        UserAbout? userInPost =
            await userService.getUserAbout(post["username"]);
        if (userInPost != null) {
          post["community_profile_picture"] = userInPost.profilePicture!;
        }
      }
      if (post["is_reposted_flag"]) {
        PostItem? ogPost =
            await postService.getPostById(post["reposted"]["original_post_id"]);
        if (ogPost != null && ogPost.inCommunityFlag!) {
          Map<String, dynamic> ogcomm = await moderatorService.getCommunityInfo(
              communityName: ogPost.communityName);
          ogPost.profilePicture = ogcomm["communityProfilePicture"];
        } else {
          UserAbout? userInPost =
              await userService.getUserAbout(ogPost!.username);
          if (userInPost != null) {
            ogPost.profilePicture = userInPost.profilePicture!;
          }
        }
        post["ogPost"] = ogPost;
        print("REPSTEDDDD");
        print(ogPost.communityName);
        print(ogPost.profilePicture);
        // print(ogPost.createdAt);
        // print(ogPost.title);
      }
    }
  }

  Future<void> fetchPosts() async {
    searchFor = widget.searchFor;
    setState(() {
      isLoading = true;
    });
    if (widget.inCommunity) {
      temp = await searchService.getPostInCommunity(searchFor, page,
          selectedOption, selectedTimeOption, widget.communityName);
    } else {
      temp = await searchService.getSearchPosts(
          searchFor, page, selectedOption, selectedTimeOption);
    }

    List<Future<void>> futures =
        temp.map((post) => getExtraData(post)).toList();
    await Future.wait(futures);

    foundPosts.addAll(temp);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchFor = widget.searchFor;
    fetchPosts();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      page++;
      fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (foundPosts.isNotEmpty) {
      return ListView.builder(
        controller: scrollController,
        itemCount: foundPosts.length + (isLoading ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index < foundPosts.length) {
            final item = foundPosts[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showModalSort();
                              },
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.grey[300],
                                  surfaceTintColor: Colors.grey[300]),
                              child: const Text(
                                "Sort",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  showModalTime();
                                },
                                style: ElevatedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.grey[300],
                                    surfaceTintColor: Colors.grey[300]),
                                child: const Text(
                                  "Time",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: PostUI(post: item),
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 2,
                )
              ],
            );
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalSort();
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[300],
                      surfaceTintColor: Colors.grey[300]),
                  child: const Text(
                    "Sort",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalTime();
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey[300],
                        surfaceTintColor: Colors.grey[300]),
                    child: const Text(
                      "Time",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void showModalTime() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.all(13),
                child: Column(
                  children: [
                    const ListTile(
                      title: Text('Filter by time'),
                    ),
                    RadioListTile(
                      title: const Text('All time'),
                      value: 'allTime',
                      activeColor: Colors.black,
                      groupValue: selectedTimeOption,
                      onChanged: (value) {
                        selectedTimeOption = value!;
                        setState(() {
                          selectedTimeOption = value!;
                        });
                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                        //fetch tany
                      },
                    ),
                    RadioListTile(
                      title: const Text('Past year'),
                      value: 'pastYear',
                      activeColor: Colors.black,
                      groupValue: selectedTimeOption,
                      onChanged: (value) {
                        selectedTimeOption = value!;
                        setState(() {
                          selectedTimeOption = value!;
                        });
                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                        //fetch tany
                      },
                    ),
                    RadioListTile(
                      title: const Text('Past Month'),
                      value: 'pastMonth',
                      groupValue: selectedTimeOption,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        selectedTimeOption = value!;
                        setState(() {
                          selectedTimeOption = value!;
                        });
                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                      },
                    ),
                    RadioListTile(
                      title: const Text('Past week'),
                      value: 'pastWeek',
                      groupValue: selectedTimeOption,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        selectedTimeOption = value!;
                        setState(() {
                          selectedTimeOption = value!;
                        });
                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                      },
                    ),
                    RadioListTile(
                      title: const Text('Past 24 hours'),
                      value: 'past24Hours',
                      groupValue: selectedTimeOption,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          selectedTimeOption = value!;
                        });
                        selectedTimeOption = value!;
                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                      },
                    ),
                    RadioListTile(
                      title: const Text('Past hour'),
                      value: 'pastHour',
                      groupValue: selectedTimeOption,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        selectedTimeOption = value!;
                        setState(() {
                          selectedTimeOption = value!;
                        });

                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showModalSort() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              //color: Colors.white,
              padding: const EdgeInsets.all(13),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const ListTile(
                      title: Text('Sort by'),
                    ),
                    RadioListTile(
                      title: const Text('Most relevant'),
                      value: 'relevance',
                      activeColor: Colors.black,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        selectedOption = value!;
                        setState(() {
                          selectedOption = value;
                        });
                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                        //fetch tany
                      },
                    ),
                    RadioListTile(
                      title: const Text('Hot'),
                      value: 'hot',
                      activeColor: Colors.black,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        selectedOption = value!;
                        setState(() {
                          selectedOption = value;
                        });
                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                        //fetch tany
                      },
                    ),
                    RadioListTile(
                      title: const Text('New'),
                      value: 'new',
                      groupValue: selectedOption,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        selectedOption = value!;
                        setState(() {
                          selectedOption = value;
                        });
                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                      },
                    ),
                    RadioListTile(
                      title: const Text('Top'),
                      value: 'top',
                      groupValue: selectedOption,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        selectedOption = value!;
                        setState(() {
                          selectedOption = value;
                        });
                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                      },
                    ),
                    RadioListTile(
                      title: const Text('Comment count'),
                      value: 'mostcomments',
                      groupValue: selectedOption,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        selectedOption = value!;
                        setState(() {
                          selectedOption = value;
                        });
                        Navigator.of(context).pop();
                        foundPosts = [];
                        fetchPosts();
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

List<Map<String, dynamic>> originalposts = [
  {
    "_id": "6633921be1b754c2c9163cad",
    "title":
        "saciubqwibcewevufvukevvasjbviebjhadbvksberhjvblebrugabbcvkerjhablueabvhjbrwbvshbvabejhvrblasbvrhjvbbalebvrebrvjhbvbrjhb",
    "description":
        "jdhsvhbdsjbiewsdkjnsjnxjns dwkcnsdjkb s dvbweknvsdkjbkdj \n cdsbjd zk \n",
    "community_profile_picture":
        "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w600/2023/10/free-images.jpg",
    "created_at": "2024-05-02T13:16:12.804Z",
    "type": "url",
    "link_url": "https://www.youtuddbej.com",
    "images": [
      "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w600/2023/10/free-images.jpg",
    ],
    "polls": [],
    "polls_voting_length": 3,
    "polls_voting_is_expired_flag": false,
    "post_in_community_flag": true,
    "community_name": "malaktest2",
    "comments_count": 0,
    "upvotes_count": 1,
    "spoiler_flag": false,
    "nsfw_flag": false,
    "is_reposted_flag": false,
    "community_id": "6631dd3e6c674a78abcebbc3",
    "user_id": "662516de07f00cce3c42352a",
    "username": "malak",
  },
  {
    "_id": "6633921be1b754c2c9163cad",
    "title":
        "saciubqwibcewevufvukevvasjbviebjhadbvksberhjvblebrugabbcvkerjhablueabvhjbrwbvshbvabejhvrblasbvrhjvbbalebvrebrvjhbvbrjhb",
    "description":
        "jdhsvhbdsjbiewsdkjnsjnxjns dwkcnsdjkb s dvbweknvsdkjbkdj \n cdsbjd zk \n",
    "community_profile_picture":
        "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w600/2023/10/free-images.jpg",
    "created_at": "2024-05-02T13:16:12.804Z",
    "type": "url",
    "link_url": "https://www.youtuddbej.com",
    "images": [
      "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w600/2023/10/free-images.jpg",
    ],
    "polls": [],
    "polls_voting_length": 3,
    "polls_voting_is_expired_flag": false,
    "post_in_community_flag": true,
    "community_name": "malaktest2",
    "comments_count": 0,
    "upvotes_count": 1,
    "spoiler_flag": false,
    "nsfw_flag": true,
    "is_reposted_flag": false,
    "community_id": "6631dd3e6c674a78abcebbc3",
    "user_id": "662516de07f00cce3c42352a",
    "username": "malak",
  },
  {
    "_id": "6633921be1b754c2c9163cad",
    "title":
        "saciubqwibcewevufvukevvasjbviebjhadbvksberhjvblebrugabbcvkerjhablueabvhjbrwbvshbvabejhvrblasbvrhjvbbalebvrebrvjhbvbrjhb",
    "description":
        "jdhsvhbdsjbiewsdkjnsjnxjns dwkcnsdjkb s dvbweknvsdkjbkdj \n cdsbjd zk \n",
    "community_profile_picture":
        "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w600/2023/10/free-images.jpg",
    "created_at": "2024-05-02T13:16:12.804Z",
    "type": "url",
    "link_url": "https://www.youtuddbej.com",
    "images": [
      "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w600/2023/10/free-images.jpg",
    ],
    "polls": [],
    "polls_voting_length": 3,
    "polls_voting_is_expired_flag": false,
    "post_in_community_flag": true,
    "community_name": "malaktest2",
    "comments_count": 0,
    "upvotes_count": 1,
    "spoiler_flag": false,
    "nsfw_flag": true,
    "is_reposted_flag": true,
    "community_id": "6631dd3e6c674a78abcebbc3",
    "user_id": "662516de07f00cce3c42352a",
    "username": "malak",
  },
];
