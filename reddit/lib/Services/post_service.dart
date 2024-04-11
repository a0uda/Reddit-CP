//import 'package:media_kit/ffi/ffi.dart';
import 'package:reddit/Models/image_item.dart';
import 'package:reddit/Models/poll_item.dart';
import 'package:reddit/Models/video_item.dart';
import 'package:reddit/Models/post_item.dart';
import '../test_files/test_posts.dart';

int counter = 0;
bool testing = true;

class PostService {
  void addPost(
    String userId,
    String username,
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
  ) {
    if (testing) {
      posts.add(
        PostItem(
          id: (posts.length + 1).toString(),
          userId: userId,
          username: username,
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
        ),
      );
    } else {
      // add post to database
    }
  }

  List<PostItem> getPosts() {
    return posts;
  }

  List<PostItem> getCommunityPosts(String communityId) {
    return posts
        .where((element) => element.communityId == communityId)
        .toList();
  }

  void upVote(String id) {
    if (testing) {
      final post = posts.firstWhere((element) => element.id == id);
      post.upvotesCount++;
    } else {
      // like post in database
    }
  }

  void downVote(String id) {
    if (testing) {
      final post = posts.firstWhere((element) => element.id == id);
      post.downvotesCount++;
    } else {
      // dislike post in database
    }
  }

  void updatePoll(String id, int index, String username) {
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

  PostItem getPostById(String id) {
    return posts.firstWhere((element) => element.id == id);
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