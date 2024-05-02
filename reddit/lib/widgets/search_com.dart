import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/add_approved_user.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';


class SearchCommunity extends StatefulWidget {
  const SearchCommunity({super.key});

  @override
  State<SearchCommunity> createState() => _SearchCommunityState();
}

class _SearchCommunityState extends State<SearchCommunity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Center(child: Text("Approved Users")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddApprovedUser(),
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.add)),
          ) //implement add in mock badrrrr
        ],
      ),
      body: Container(color: Colors.grey[200], child: const ApprovedUserList()),
    );
  }
}
