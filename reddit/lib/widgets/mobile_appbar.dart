import 'package:flutter/material.dart';
import 'package:reddit/widgets/search_bar.dart';


class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback logoTapped;
  const MobileAppBar({super.key, required this.logoTapped});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
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
        ),
      ],
    );
  }
}
