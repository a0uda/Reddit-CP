import 'package:flutter/material.dart';



void navigateToCommunity(Widget communityPage, BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => (communityPage)));
}

class DrawerTile extends StatefulWidget {
  final List<Map<String, dynamic>> lists;
  final String tileTitle;
  const DrawerTile({super.key, required this.tileTitle, required this.lists});

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: Colors.black,
          ),
          title: Text(
            widget.tileTitle,
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        Visibility(
          visible: isExpanded,
          child: Column(
            children: [
              ListTile(
                  leading: const Icon(Icons.add, color: Colors.black),
                  title: const Text("Create Community"),
                  onTap: () {
                    //navigate to Create Community Page
                  },
                ),
              AnimatedOpacity(
                opacity: isExpanded ? 1.0 : 0.0,
                duration: const Duration(seconds: 0),
                curve: Curves.bounceInOut,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.lists.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = widget.lists[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("images/logo-mobile.png"),
                        radius: 10,
                      ),
                      title: Text(item['name']),
                      onTap: () {
                        // Call the function to navigate to the community page
                        navigateToCommunity(item['communityPage'], context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
