import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Services/search_service.dart';

class SuggestUsers extends StatefulWidget {
  final String search;
  const SuggestUsers({super.key, required this.search});

  @override
  State<SuggestUsers> createState() => _SuggestUsersState();
}

class _SuggestUsersState extends State<SuggestUsers> {
  List<Map<String, dynamic>> communities = [];
  List<Map<String, dynamic>> foundUsers = [];
  final SearchService searchService = GetIt.instance.get<SearchService>();
  final UserController userController = GetIt.instance.get<UserController>();
  final ModeratorController moderatorController =
      GetIt.instance.get<ModeratorController>();

  Future<void> fetchCommunities() async {
    if (widget.search != "") {
      print(widget.search.length);
      foundUsers = await searchService.getSearchUsers(widget.search);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchCommunities(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('none');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...foundUsers.map(
                  (user) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ListTile(
                      leading: (user.containsKey("profile_picture") &&
                              user["profile_picture"] != "")
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user["profile_picture"]),
                              radius: 13,
                            )
                          : const CircleAvatar(
                              backgroundImage:
                                  AssetImage("images/default_reddit.png"),
                              radius: 13,
                            ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "u/${user["username"]}",
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await userController.unblockUser(
                              userController.userAbout!, user['username']);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('User blocked successfully!'),
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.deepOrange[400],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(50, 35),
                          elevation: 0,
                          backgroundColor: Colors.blue[900],
                          foregroundColor: Colors.white,
                          shadowColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              color: Colors.blue[900]!,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: const Text("Block"),
                      ),
                    ),
                  ),
                ),
              ],
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
