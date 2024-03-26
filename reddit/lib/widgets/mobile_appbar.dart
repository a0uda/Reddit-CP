import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Pages/login.dart';
import 'package:reddit/widgets/search_bar.dart';

class MobileAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback logoTapped;
  const MobileAppBar({super.key, required this.logoTapped});

  @override
  State<MobileAppBar> createState() => _MobileAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MobileAppBarState extends State<MobileAppBar> {
  final userController = GetIt.instance.get<UserController>();

  @override
  Widget build(BuildContext context) {
    final bool userLoggedIn = userController.userAbout != null;
    return AppBar(
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: GestureDetector(
              child: const CircleAvatar(
                backgroundImage: AssetImage(
                  "images/logo-mobile.png",
                ),
                radius: 18,
              ),
              onTap: () {
                widget.logoTapped();
              },
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchBarClass());
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
                Text("Search...")
              ]),
            ),
          ),
        ],
      ),
      actions: [
        userLoggedIn
            ? Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: const CircleAvatar(
                    backgroundImage: AssetImage(
                      "images/pp.jpg",
                    ),
                    radius: 16,
                  ),
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(3.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginPage()));
                  },
                  style: TextButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.orange[900],
                    shadowColor: Colors.white,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Log In"),
                ),
              )
      ],
    );
  }
}
