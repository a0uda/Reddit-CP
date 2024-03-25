class PostItem {
  final int id;
  final String username;
  final String? profilePic;
  final String title;
  final String? description;
  final String type;
  final String? linkUrl;
  final List<ImageItem>? images;
  final List<VideoItem>? videos;
  PollItem? poll;
  final int communityId;
  final String communityName;
  final bool ocFlag;
  final bool spoilerFlag;
  final bool nsfwFlag;
  final DateTime date;
  int likes;
  final int comments;
  final List<String> commentsList;
  PostItem({
    required this.id,
    required this.username,
    this.profilePic,
    required this.title,
    this.description,
    required this.type,
    this.linkUrl,
    this.images,
    this.videos,
    this.poll,
    required this.communityId,
    required this.communityName,
    required this.ocFlag,
    required this.spoilerFlag,
    required this.nsfwFlag,
    required this.date,
    required this.likes,
    required this.comments,
    required this.commentsList,
  });
}

class ImageItem {
  final String path;
  final String link;

  ImageItem({
    required this.path,
    required this.link,
  });
}

class VideoItem {
  final String path;
  final String link;

  VideoItem({
    required this.path,
    required this.link,
  });
}

class PollItem {
  final String question;
  final List<String> options;
  List<int> votes;
  List<String> option1Votes;
  List<String> option2Votes;

  PollItem({
    required this.question,
    required this.options,
    required this.votes,
    required this.option1Votes,
    required this.option2Votes,
  });
}

final List<PostItem> posts = [];
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

  void likePost(int id) {
    if (testing) {
      final post = posts.firstWhere((element) => element.id == id);
      post.likes++;
    } else {
      // like post in database
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
      if (index == 0)
        post.poll!.option1Votes.add(username);
      else
        post.poll!.option2Votes.add(username);
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