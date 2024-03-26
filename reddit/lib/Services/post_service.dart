import 'package:reddit/Models/image_item.dart';
import 'package:reddit/Models/poll_item.dart';
import 'package:reddit/Models/video_item.dart';
import 'package:reddit/Models/post_item.dart';

int counter = 0;
bool testing = true;

class PostService {
  void addPost(
    // int id,
    String username,
    String title,
    String type,
    int communityId,
    String communityName,
    bool ocFlag,
    bool spoilerFlag,
    bool nsfwFlag,
    int likes,
    int comments,
    List<String> commentsList,
    DateTime date, {
    String? profilePic,
    String? description,
    String? linkUrl,
    List<ImageItem>? images,
    List<VideoItem>? videos,
    PollItem? poll,
  }) {
    if (testing) {
      posts.add(
        PostItem(
          id: counter++,
          username: username,
          profilePic: profilePic,
          title: title,
          description: description,
          type: type,
          linkUrl: linkUrl,
          images: images,
          videos: videos,
          poll: poll,
          communityId: communityId,
          communityName: communityName,
          ocFlag: ocFlag,
          spoilerFlag: spoilerFlag,
          nsfwFlag: nsfwFlag,
          likes: likes,
          comments: comments,
          commentsList: commentsList,
          date: date,
        ),
      );
    } else {
      // add post to database
    }
  }

  List<PostItem> getPosts() {
    return posts;
  }

  List<PostItem> getCommunityPosts(int communityId) {
    return posts
        .where((element) => element.communityId == communityId)
        .toList();
  }

  void upVote(int id) {
    if (testing) {
      final post = posts.firstWhere((element) => element.id == id);
      post.likes++;
    } else {
      // like post in database
    }
  }

  void downVote(int id) {
    if (testing) {
      final post = posts.firstWhere((element) => element.id == id);
      post.likes--;
    } else {
      // dislike post in database
    }
  }

  void updatePoll(int id, int index, String username) {
    print('id is : $id');
    if (testing) {
      final post = posts.firstWhere((element) => element.id == id);
      if (post.poll == null) {
        print('no poll found');
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