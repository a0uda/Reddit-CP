class PostItem {
  final int id;
  final String title;
  final String text;
  final DateTime date;
  final String? url;
  final String? imageUrl;
  final String? videoUrl;

  PostItem({
    required this.id,
    required this.title,
    required this.text,
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
  final List<Map<String, double>> options;

  PollItem({
    required this.question,
    required this.options,
  });
}

final List<PostItem> posts = [];
bool Testing = true;

class PostService {
  void addPost(int id, String title, String text, DateTime date, String? url,
      String? imageUrl, String? videoUrl) {
    if (Testing) {
      posts.add(PostItem(
        id: id,
        title: title,
        text: text,
        date: date,
        url: url,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
      ));
    } else {
      // add post to database
    }
  }

  List<PostItem> getPosts() {
    return posts;
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
