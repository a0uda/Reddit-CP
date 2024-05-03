import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/widgets/comments_desktop.dart';
import '../Services/user_service.dart';
import '../Models/user_about.dart';
import '../Models/comments.dart';

class TabBarComments extends StatelessWidget {
  final UserAbout? userData;
  TabBarComments({super.key, required this.userData});

  final userService = GetIt.instance.get<UserService>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GetComments>(
          create: (context) => GetComments(),
        ),
      ],
      child: Consumer<BlockUnblockUser>(
        builder: (context, blockUnblockUser, child) {
          return FutureBuilder<List<Comments>?>(
            future: userService.getcomments(userData!.username),
            builder: (BuildContext context,
                AsyncSnapshot<List<Comments>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.white,
                  child: const SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Comments> comments = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: () async {
                    var myProvider = context.read<GetComments>();
                    comments =
                        await myProvider.getUserComments(userData!.username);
                  },
                  child: Consumer<GetComments>(
                      builder: (context, getUserComments, child) {
                    return comments.isEmpty
                        ? const Center(
                            child: Text('No comments yet!'),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: comments.length,
                            itemBuilder: (BuildContext context, int index) {
                              Comments comment = comments[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CommentsDesktop(
                                        postId: comment.postId ?? '',
                                      ),
                                    ),
                                  );
                                },
                                tileColor: Colors.white,
                                title: Text(
                                  comment.username ?? '',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                subtitle: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'r/${comment.subredditName} • ${getDateTimeDifferenceWithLabel(comment.createdAt ?? '')} • ${comment.upvotesCount == 0 ? '' : comment.upvotesCount}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 156, 156, 156),
                                          ),
                                        ),
                                        comment.upvotesCount != 0
                                            ? const Icon(
                                                Icons.arrow_upward_outlined,
                                                size: 16,
                                              )
                                            : Container(),
                                        Text(
                                          ' ${comment.downvotesCount == 0 ? '' : comment.downvotesCount}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 156, 156, 156),
                                          ),
                                        ),
                                        comment.downvotesCount != 0
                                            ? const Icon(
                                                Icons.arrow_downward_outlined,
                                                size: 16,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          comment.description ?? '',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                color: Color.fromARGB(255, 223, 222, 222),
                                height:
                                    1, // Adjust the height of the divider as needed
                              );
                            },
                          );
                  }),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class GetComments extends ChangeNotifier {
  final userService = GetIt.instance.get<UserService>();
  final userController = GetIt.instance.get<UserController>();
  Future<List<Comments>> getUserComments(String username) async {
    List<Comments>? comments = await userService.getcomments(username);
    notifyListeners();
    return comments!;
  }
}

String getDateTimeDifferenceWithLabel(String dateFromDatabaseString) {
  // Parse the string from the database to a DateTime object
  DateTime dateFromDatabase = DateTime.parse(dateFromDatabaseString);

  // Get the current time
  DateTime currentTime = DateTime.now();

  // Calculate the difference between the current time and the database date
  Duration difference = currentTime.difference(dateFromDatabase);

  // Check the difference in years
  if (difference.inDays >= 365) {
    int years = (difference.inDays / 365).floor();
    return '${years}y';
  }

  // Check the difference in days
  else if (difference.inDays > 0) {
    return '${difference.inDays}d';
  }

  // Check the difference in hours
  else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  }

  // Check the difference in minutes
  else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  }

  // Check the difference in seconds
  else if (difference.inSeconds > 0) {
    return '${difference.inSeconds}s';
  }

  // If all differences are 0, return '0 s'
  else {
    return 'now';
  }
}
