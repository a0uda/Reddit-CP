import 'package:reddit/Models/image_item.dart';

class TrendingItem {
  String? title;
  String? picture;

  TrendingItem({
    this.title,
    this.picture,
  });

  factory TrendingItem.fromJson(Map<String, dynamic> json) {
    print(json['images']);

    final List<dynamic> jsonlist = json['images'] ?? [];
    final List<ImageItem> imagelist = jsonlist.map((jsonitem) {
      return ImageItem.fromJson(jsonitem);
    }).toList();

    return TrendingItem(

        ///todo

        picture: imagelist.isEmpty ? "" : imagelist[0].path,
        title: json['title'] ?? "");
  }
}

// List<TrendingItem> trendingPosts = [
//   TrendingItem(
//     title: 'Ramadan kareem',
//     picture: ImageItem(
//       path:
//           'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
//       link:
//           'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
//     ),
//   ),
//   TrendingItem(
//     title: 'lakers vs gsw',
//     picture: ImageItem(
//       path:
//           'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
//       link:
//           'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
//     ),
//   ),
//   TrendingItem(
//     title: 'lakers vs gsw',
//     picture: ImageItem(
//       path:
//           'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
//       link:
//           'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
//     ),
//   ),
//   TrendingItem(
//     title: 'lakers vs gsw',
//     picture: ImageItem(
//       path:
//           'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
//       link:
//           'https://images.unsplash.com/photo-1557053910-d9eadeed1c58?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
//     ),
//   )
// ];
