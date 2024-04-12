import 'package:reddit/Models/image_item.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/Models/save.dart';
import 'package:reddit/test_files/test_users.dart';
import 'package:reddit/Models/report.dart';


final List<PostItem> posts = [
  PostItem(
    id: "1",
    userId: users[1].userAbout.id!,
    username: users[1].userAbout.username,
    title: 'Mostafa Fouda',
    type: 'type',
    communityId: "0",
    communityName: "r/Flutter",
    ocFlag: false,
    spoilerFlag: false,
    nsfwFlag: false,
    createdAt: DateTime.now(),
    editedAt: null,
    deletedAt: null,
    description: "testing",
    linkUrl: null,
    images: null,
    videos: null,
    poll: null,
    commentsCount: 0,
    viewsCount: 0,
    sharesCount: 0,
    upvotesCount: 0,
    downvotesCount: 0,
    lockedFlag: false,
    allowrepliesFlag: true,
    setSuggestedSort: "None (Recommended)",
    moderatorDetails: null,
    userDetails: null,
  ),
  PostItem(
    id: "2",
    userId: users[1].userAbout.id!,
    username: users[1].userAbout.username,
    title: 'A pic example',
    type: 'type',
    communityId: "0",
    communityName: "r/Photography",
    ocFlag: false,
    spoilerFlag: false,
    nsfwFlag: false,
    createdAt: DateTime.now(),
    editedAt: null,
    deletedAt: null,
    description: "A subreddit for photography enthusiasts.",
    linkUrl: null,
    images: [
      ImageItem(
        path:
            'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
        link:
            'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
      )
    ],
    videos: null,
    poll: null,
    commentsCount: 0,
    viewsCount: 0,
    sharesCount: 0,
    upvotesCount: 0,
    downvotesCount: 0,
    lockedFlag: false,
    allowrepliesFlag: true,
    setSuggestedSort: "None (Recommended)",
    moderatorDetails: null,
    userDetails: null,
  ),
];








final List<PostItem> popularPosts = [
  PostItem(
    id: "2",
    userId: users[1].userAbout.id!,
    username: users[1].userAbout.username,
    title: 'sabahoooo',
    type: 'type',
    communityId: "0",
    communityName: "r/Photography",
    ocFlag: false,
    spoilerFlag: false,
    nsfwFlag: false,
    createdAt: DateTime.now(),
    editedAt: null,
    deletedAt: null,
    description: "A subreddit for photography enthusiasts.",
    linkUrl: null,
    images: [
      ImageItem(
        path:
            'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
        link:
            'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
      )
    ],
    videos: null,
    poll: null,
    commentsCount: 0,
    viewsCount: 0,
    sharesCount: 0,
    upvotesCount: 0,
    downvotesCount: 0,
    lockedFlag: false,
    allowrepliesFlag: true,
    setSuggestedSort: "None (Recommended)",
    moderatorDetails: null,
    userDetails: null,
  ),
    PostItem(
    id: "2",
    userId: users[1].userAbout.id!,
    username: users[1].userAbout.username,
    title: 'sabahooo',
    type: 'type',
    communityId: "0",
    communityName: "r/Photography",
    ocFlag: false,
    spoilerFlag: false,
    nsfwFlag: false,
    createdAt: DateTime.now(),
    editedAt: null,
    deletedAt: null,
    description: "A subreddit for photography enthusiasts.",
    linkUrl: null,
    images: [
      ImageItem(
        path:
            'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
        link:
            'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
      )
    ],
    videos: null,
    poll: null,
    commentsCount: 0,
    viewsCount: 0,
    sharesCount: 0,
    upvotesCount: 0,
    downvotesCount: 0,
    lockedFlag: false,
    allowrepliesFlag: true,
    setSuggestedSort: "None (Recommended)",
    moderatorDetails: null,
    userDetails: null,
  ),
];
final List <ReportPost> reportPosts=[];
final List <SaveItem> savedPosts=[];


