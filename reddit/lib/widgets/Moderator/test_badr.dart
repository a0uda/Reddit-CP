import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/post_mod_queue.dart';

class BadrTestPostItem {
  final String profileImage;
  final String username;
  final String postTime;
  bool? notSafeForWork;
  bool? spoilerFlag;

  final String postTitle;
  String? postDescription;
  String? postContentImage;

  String? reportReason;

  BadrTestPostItem(
      {required this.profileImage,
      required this.postTitle,
      this.postDescription,
      required this.username,
      required this.postTime,
      this.notSafeForWork,
      this.reportReason,
      this.spoilerFlag,
      this.postContentImage});
}

List<BadrTestPostItem> modQueueTestPosts = [
  BadrTestPostItem(
    postTime: "10m",
    profileImage: "images/Greddit.png",
    username: "badr",
    spoilerFlag: true,
    notSafeForWork: true,
    postTitle: "Link from normal user",
    postDescription: "Test test",
    reportReason: "Ayy kalam",
    postContentImage: "images/pp.jpg",
  ),
  BadrTestPostItem(
    postTime: "10m",
    profileImage: "images/Greddit.png",
    username: "badr",
    spoilerFlag: true,
    notSafeForWork: true,
    postTitle: "Link from normal user",
    postDescription: "Test test",
    reportReason: "Ayy kalam",
  ),
  BadrTestPostItem(
    postTime: "10m",
    profileImage: "images/Greddit.png",
    username: "badr",
    spoilerFlag: true,
    notSafeForWork: true,
    postTitle: "Link from normal user",
    postDescription: "Test test",
    //postContentImage: "images/pp.jpg",
  ),
  BadrTestPostItem(
    postTime: "10m",
    profileImage: "images/Greddit.png",
    username: "badr",
    notSafeForWork: true,
    postTitle: "Link from normal user",
    postContentImage: "images/pp.jpg",
  ),
  BadrTestPostItem(
    postTime: "10m",
    profileImage: "images/Greddit.png",
    username: "badr",
    postTitle: "Link from normal user",
    postDescription: "Test test",
    reportReason: "Ayy kalam",
  ),
];

class Testingggg extends StatelessWidget {
  const Testingggg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: modQueueTestPosts.length,
        itemBuilder: (BuildContext context, int index) {
          final item = modQueueTestPosts[index];
          return PostModQueue(
            post: item,
          );
        },
      ),
    );
  }
}
