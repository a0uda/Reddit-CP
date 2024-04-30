//import 'package:media_kit/ffi/ffi.dart';
import 'dart:convert';

import 'package:reddit/Models/image_item.dart';
import 'package:reddit/Models/poll_item.dart';
import 'package:reddit/Models/save.dart';
import 'package:reddit/Models/trending_item.dart';
import 'package:reddit/Models/video_item.dart';
import 'package:reddit/Models/post_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../test_files/test_posts.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Models/report.dart';
import 'package:http/http.dart' as http;

int counter = 0;
bool testing = const bool.fromEnvironment('testing');

class PostService {
  Future<int> addPost(
    String? userId,
    String? username,
    String title,
    String? description,
    String type,
    String? linkUrl,
    List<ImageItem>? images,
    List<VideoItem>? videos,
    PollItem? poll,
    String communityId,
    String communityName,
    bool ocFlag,
    bool spoilerFlag,
    bool nsfwFlag,
    bool postInCommunityFlag,
  ) async {
    if (testing) {
      posts.add(
        PostItem(
          id: (posts.length + 1).toString(),
          userId: userId!,
          username: username!,
          title: title,
          description: description,
          createdAt: DateTime.now(),
          type: type,
          linkUrl: linkUrl,
          images: images,
          videos: videos,
          poll: poll,
          communityId: communityId,
          communityName: communityName,
          commentsCount: 0,
          viewsCount: 0,
          sharesCount: 0,
          upvotesCount: 0,
          downvotesCount: 0,
          ocFlag: ocFlag,
          spoilerFlag: spoilerFlag,
          nsfwFlag: nsfwFlag,
          lockedFlag: false, // Assuming initial locked flag is false
          allowrepliesFlag: true, // Assuming initial allow replies flag is true
          setSuggestedSort: "None",
          vote: 0,
          isReposted: false,
          originalPostID: '',
        ),
      );
      
    } else {
      // add post to database
      final url = Uri.parse('https://redditech.me/backend/posts/new-post');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body: json.encode({
          "title": title,
          "description": description,
          "type": "text",
          "link_url": linkUrl,
          "images": images
              ?.map((image) => {
                    "path": image.path,
                    "caption": image.caption ?? "",
                    "link": image.link
                  })
              .toList(),
          "videos": videos
              ?.map((video) => {
                    "path": video.path,
                    "caption": video.caption ?? "",
                    "link": video.link
                  })
              .toList(),
          "polls": poll != null
              ? [
                  {"options": poll.options}
                ]
              : [],
          "polls_voting_length": poll != null ? poll.votes.length : 0,
          "community_name": "",
          "post_in_community_flag": postInCommunityFlag,
          "oc_flag": ocFlag,
          "spoiler_flag": spoilerFlag,
          "nsfw_flag": nsfwFlag
        }),
      );
  
      // print(json.encode({
      //   "title": title,
      //   "description": description,
      //   "type": type,
      //   "link_url": linkUrl,
      //   "images": images
      //       ?.map((image) => {
      //             "path": image.path,
      //             "caption": image.caption ?? "",
      //             "link": image.link
      //           })
      //       .toList(),
      //   "videos": videos
      //       ?.map((video) => {
      //             "path": video.path,
      //             "caption": video.caption ?? "",
      //             "link": video.link
      //           })
      //       .toList(),
      //   "polls": poll != null
      //       ? [
      //           {"options": poll.options}
      //         ]
      //       : [],
      //   "polls_voting_length": poll != null ? poll.votes.length : 0,
      //   "community_name": communityName,
      //   "post_in_community_flag": postInCommunityFlag,
      //   // "oc_flag": ocFlag,
      //   // "spoiler_flag": spoilerFlag,
      //   // "nsfw_flag": nsfwFlag
      // }));
      // if (response.statusCode >= 400) {
      //   return 400;
      // }
    }
    return 200;
  }

  List<PostItem> fetchPosts() {
    if (testing) {
      return posts;
    } else {
      return posts;
    }
  }

  Future<List<PostItem>> getPosts(String username, String sortingType,int page) async {
    if (testing) {
      final userService = GetIt.instance.get<UserService>();
      final List<FollowersFollowingItem> following =
          await userService.getFollowers(username);
      var usernames = following.map((user) => user.username).toSet();
      // print(usernames);
      var filteredPosts =
          posts.where((post) => usernames.contains(post.username)).toList();
      return filteredPosts;
    } else {
      Map<String,String> queryparams={
        'page':page.toString(),
        'pageSize':'10'
      };
    
  
      var url = Uri.parse('https://redditech.me/backend/listing/posts/best').replace(queryParameters:queryparams);

      if (sortingType == "best") {
       url = Uri.parse('https://redditech.me/backend/listing/posts/best').replace(queryParameters:queryparams);
      } else if (sortingType == "hot") {
       url = Uri.parse('https://redditech.me/backend/listing/posts/hot').replace(queryParameters:queryparams);
      } else if (sortingType == "new") {
       url = Uri.parse('https://redditech.me/backend/listing/posts/new').replace(queryParameters:queryparams);
      } else if (sortingType == "top") {
       url = Uri.parse('https://redditech.me/backend/listing/posts/top').replace(queryParameters:queryparams);
      } else if (sortingType == "random") {
       url = Uri.parse('https://redditech.me/backend/listing/posts/random').replace(queryParameters:queryparams);
  
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        
        
      );
   print(response.body);
      if(response.statusCode==200)
      {
      final List<dynamic> jsonlist = json.decode(response.body)['content'];
      final List<PostItem> postsItem = jsonlist.map((jsonitem) {
        return PostItem.fromJson(jsonitem);
      }).toList();

      return postsItem;
      }
      else
      {
        List<PostItem> nullPost=[];
        return nullPost;
      }
    }
  }

  List<TrendingItem> getTrendingPosts() {
    if (testing) {
      return trendingPosts;
    } else {
      return trendingPosts;
    }
  }

  Future<List<PostItem>> getMyPosts(String username) async {
    if (testing) {
      var filteredPosts =
          posts.where((post) => post.username == username).toList();
      return filteredPosts;
    } else {
   
      final url =
          Uri.parse('https://redditech.me/backend/users/posts/$username');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
      );
  
      final List<dynamic> jsonlist = json.decode(response.body)['content'];
      final List<PostItem> postsItem = jsonlist.map((jsonitem) {
        return PostItem.fromJson(jsonitem);
      }).toList();

      return postsItem;
      //return posts;
    }
  }

  List<PostItem> getPostsById(int id) {
    if (testing) {
      var filteredPosts = posts.where((post) => post.id == id).toList();
      return filteredPosts;
    } else {
      return posts;
    }
  }

  List<PostItem> getPopularPosts() {
    if (testing) {
      return popularPosts;
    } else {
      return popularPosts;
    }
  }

  List<PostItem> getCommunityPosts(int communityId) {
    return posts
        .where((element) => element.communityId == communityId)
        .toList();
  }

  Future<void> upVote(String id) async{
    if (testing) {
      final post = posts.firstWhere((element) => element.id == id);
      post.upvotesCount++;
    } else {

        final url =
          Uri.parse('https://redditech.me/backend/posts-or-comments/vote');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body: json.encode({"id": id,"is_post":true,"vote":"1"}),
      );
      print(response.statusCode);

      // like post in database
    }
  }

 Future<void> downVote(String id) async{
    if (testing) {
      final post = posts.firstWhere((element) => element.id == id);
      post.downvotesCount++;
    } else {
        final url =
          Uri.parse('https://redditech.me/backend/posts-or-comments/vote');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
    
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body: json.encode({"id": id,"is_post":true,"vote":"-1"}),
      );
      print(response.statusCode);

      // dislike post in database
    }
  }

  Future<void> submitReport(String? id, String reason) async{
    if (testing) {
      reportPosts.add(ReportPost(id: id, reason: reason));
      //print(id);
      //print(reason);
      //print(reportPosts);
    } else {
      final url =
          Uri.parse('https://redditech.me/backend/posts/report');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body: json.encode({"id": id}),
      );
      print(response.statusCode);
      

      // dislike post in database
    }
  }

  Future<void> savePost(String? id, String username) async{
    if (testing) {
      savedPosts.add(SaveItem(id: id, username: username));
    } else {
       final url =
          Uri.parse('https://redditech.me/backend/posts-or-comments/save');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body: json.encode({"id": id, "is_post":true,}),
      );
      print(response.statusCode);
      


      // dislike post in database
    }
  }

  void unSavePost(String? id, String username) {
    if (testing) {
      savedPosts.removeWhere(
          (post) => ((post.id == id) && (post.username == username)));
    } else {
      // dislike post in database
    }
  }

  Future <List<PostItem>> getSavePost(String username) async{
    if (testing) {
      var filteredids =
          savedPosts.where((post) => post.username == username).toList();
      var ids = filteredids.map((user) => user.id).toSet();
      //print(ids);
      var filteredPosts = posts.where((post) => ids.contains(post.id)).toList();
      return filteredPosts;
    } else {
      
     {
      final url =
          Uri.parse('https://redditech.me/backend/users/saved-posts-and-comments');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token!},
      );
  print(response.body);
      if (response.statusCode == 200) {
          final List<dynamic> jsonlist = json.decode(response.body)['posts'];
      final List<PostItem> postsItem = jsonlist.map((jsonitem) {
        return PostItem.fromJson(jsonitem);
      }).toList();

      return postsItem;
      } else {
        throw Exception('Failed to load post');
      }
    }
      // dislike post in database
    }
  }

  void updatePoll(String id, int index, String username) {
    //print('id is : $id');
    if (testing) {
      final post = posts.firstWhere((element) => element.id == id);
      if (post.poll == null) {
        //print('no poll found');
        return;
      }
      post.poll!.votes[index]++;
      if (index == 0) {
        post.poll!.option1Votes.add(username);
      } else {
        post.poll!.option2Votes.add(username);
      }
    } else {
      // update poll in database
    }
  }

  Future<PostItem?> getPostById(String postId) async {
    if (testing) {
      return posts.firstWhere((element) => element.id == postId);
    } else {
      print(postId);
      final url =
          Uri.parse('https://redditech.me/backend/posts/get-post?id=$postId');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token!},
      );
      //rint('post');
      print(response.body);
      //print(json.decode(response.body)['post']);

      if (response.statusCode == 200) {
        return PostItem.fromJson(json.decode(response.body)['content']);
      } else {
        throw Exception('Failed to load post');
      }
    }
  }

  Future<void> lockUnlockPost(String id) async {
    if (testing) {
      final post = posts.firstWhere((element) => element.id == id);
      post.lockedFlag = !post.lockedFlag;
    } else {
      // lock/unlock post in database
      final url = Uri.parse(
          'https://redditech.me/backend/posts-or-comments/lock-unlock');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token!},
        body: json.encode({"is_post": true, "id": id}),
      );
      //print('lock');
      //print(response.statusCode);
    }
  }

  bool isMyPost(String postId, String username) {
    if (testing) {
      final post = posts.firstWhere((element) => element.id == postId);
      return post.username == username;
    } else {
      // final post = await getPostById(postId);
      // return post!.username == username;
      return false;
    }
  }

  Future <List<PostItem>> getHistoryPost(String username) async{
    if (testing) {
      
      return posts;
    } else {
      
     {
      final url =
          Uri.parse('https://redditech.me/backend/users/history-posts');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': token!},
      );
  print(response.body);
      if (response.statusCode == 200) {
          final List<dynamic> jsonlist = json.decode(response.body)['content'];
      final List<PostItem> postsItem = jsonlist.map((jsonitem) {
        return PostItem.fromJson(jsonitem);
      }).toList();

      return postsItem;
      } else {
        throw Exception('Failed to load post');
      }
    }
      // dislike post in database
    }
  }

Future<void> SharePost(String id,String comName,String caption,bool flag)async{
    if (testing) {
      
    } else {
      print(id);
         print(comName);
            print(caption);
               print(flag);
        final url =
          Uri.parse('https://redditech.me/backend/posts/share-post');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
    
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body: json.encode({"id": id,"community_name":comName,"caption":caption,"post_in_community_flag":flag}),
      );
      print(response.body);

      // dislike post in database
    }
  }


Future<void> EditPost(String id,String caption)async{
    if (testing) {
      
    } else {
 
        final url =
          Uri.parse('https://redditech.me/backend/posts-or-comments/edit-text');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
    
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body: json.encode({"id": id,"edited_text":caption,"is_post":true}),
      );
      print(response.body);

      // dislike post in database
    }
  }


Future<void> DeletePost(String id)async{
    if (testing) {
      
    } else {
 
        final url =
          Uri.parse('https://redditech.me/backend/posts/remove');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
    
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString()
        },
        body: json.encode({"id": id,}),
      );
      print(response.body);


    }
  }




}




// '''
// New_Post:
//       type: object
//       required:
//         - title
//         - community-name
//       properties:
//         title:
//           type: string
//         description:
//           type: string
//         type:
//           type: string
//           enum:
//             - image_and_videos
//             - polls
//             - url
//             - text
//             - hybrid
//         link_url:
//           type: string
//         images:
//           type: array
//           items:
//             type: object
//             properties:
//               path:
//                 type: string
//               caption:
//                 type: string
//               link:
//                 type: string
//             additionalProperties: false
//         videos:
//           type: array
//           items:
//             type: object
//             properties:
//               path:
//                 type: string
//               caption:
//                 type: string
//               link:
//                 type: string
//             additionalProperties: false
//         poll:
//           type: object
//           properties:
//             options:
//               type: array
//               items:
//                 type: string
//             votes:
//               type: array
//               items:
//                 type: number
//           additionalProperties: false
//         community_id:
//           type: string
//           format: objectId
//         community-name:
//           type: string
//         oc_flag:
//           type: boolean
//         spoiler_flag:
//           type: boolean
//         nsfw_flag:
//           type: boolean
// '''
