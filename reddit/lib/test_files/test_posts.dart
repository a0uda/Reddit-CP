import 'package:reddit/Models/image_item.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:reddit/test_files/test_users.dart';

final List<PostItem> posts = [
  PostItem(
    id: 1,
    username: users[1].userAbout.username,
    title: 'Mostafa Fouda',
    type: 'type',
    communityId: 0,
    communityName: "Cooking Masters",
    ocFlag: false,
    spoilerFlag: false,
    nsfwFlag: false,
    date: DateTime.now(),
    likes: 0,
    comments: 0,
    commentsList: [],
    profilePic:
        'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
    description: "testing",
  ),
  PostItem(
      id: 1,
      username: users[1].userAbout.username,
      title: 'Mostafa Fouda',
      type: 'type',
      communityId: 0,
      communityName: "Cooking Masters",
      ocFlag: false,
      spoilerFlag: false,
      nsfwFlag: false,
      date: DateTime.now(),
      likes: 0,
      comments: 0,
      commentsList: [],
      profilePic:
          'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
      description: "testing",
      images: [
        ImageItem(
            link:
                'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
            path:
                'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80')
      ]),
];
