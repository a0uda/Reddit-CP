import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Services/user_service.dart';
import 'package:reddit/widgets/Search/block_new_user_list.dart';
import 'package:reddit/widgets/Search/search_bar.dart';

class ManageBlockedAccounts extends StatefulWidget {
  const ManageBlockedAccounts({super.key});

  @override
  State<ManageBlockedAccounts> createState() => _ManageBlockedAccountsState();
}

class _ManageBlockedAccountsState extends State<ManageBlockedAccounts> {
  final UserController userController = GetIt.instance.get<UserController>();
  final UserService userService = GetIt.instance.get<UserService>();
  List<BlockedUsersItem> blockedUsers = [];
  List<BlockedUsersItem> searchResults = [];
  bool undo = false;

  @override
  void initState() {
    super.initState();
    blockedUsers = userController.blockedUsers!;
    searchResults = blockedUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Blocked Accounts'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          userController.blockedUsers = await userService
              .getBlockedUsers(userController.userAbout!.username);
          setState(() {
            blockedUsers = userController.blockedUsers!;
            searchResults = blockedUsers;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  showSearch(context: context, delegate: BlockSearch());
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.grey,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                child: const Row(children: [
                  Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  Text("Block new account")
                ]),
              ),
              Expanded(
                  child: ListView(
                children: searchResults.map((blockedUser) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 15,
                      backgroundImage: (blockedUser.profilePicture != '')
                          ? NetworkImage(blockedUser.profilePicture)
                          : const NetworkImage(
                              "https://static-00.iconduck.com/assets.00/reddit-icon-icon-2048x2048-fdxpdoih.png"),
                    ),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        blockedUser.username,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await userController.unblockUser(
                            userController.userAbout!, blockedUser.username);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('User unblocked. Tap to undo.'),
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.deepOrange[400],
                            action: SnackBarAction(
                              textColor: Colors.white,
                              label: 'Undo',
                              onPressed: () async {
                                // Code to re-block the user
                                undo = true;
                                await userController.blockUser(
                                    userController.userAbout!,
                                    blockedUser.username);
                              },
                            ),
                          ),
                        );
                        Future.delayed(const Duration(seconds: 3), () {
                          if (!undo) {
                            setState(() {});
                          }
                          undo = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 35),
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue[900],
                        shadowColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Colors.blue[900]!,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: const Text("Unblock"),
                    ),
                  );
                }).toList(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
