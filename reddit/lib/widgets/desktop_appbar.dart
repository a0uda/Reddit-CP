import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reddit/Pages/create_post.dart';
import 'package:reddit/widgets/search_bar.dart';

class DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback logoTapped;
  const DesktopAppBar({super.key, required this.logoTapped});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 0,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 75.0),
            child: GestureDetector(
              child: Image.asset(
                "images/desktop-logo.jpg",
                fit: BoxFit.contain,
                height: kToolbarHeight * (3 / 4),
              ),
              onTap: () {
                logoTapped();
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
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * (1 / 50)),
          child: IconButton(
            onPressed: () {
              //Navigate to chattt
            },
            icon: const Icon(CupertinoIcons.chat_bubble_text),
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.white,
              padding: const EdgeInsets.all(7),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              //Navigate to create post -> jomana
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreatePost(),
              ));
            },
            child: const Row(
              children: [Icon(Icons.add), Text("Create")],
            )),
        IconButton(
          onPressed: () {
            //Navigate to Inbox
          },
          icon: const Icon(CupertinoIcons.bell),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 5),
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
        ),
      ],
    );
  }
}
