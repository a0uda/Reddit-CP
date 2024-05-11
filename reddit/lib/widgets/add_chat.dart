import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reddit/Controllers/moderator_controller.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/Models/followers_following_item.dart';
import 'package:reddit/Services/user_service.dart';

import 'package:reddit/widgets/add_text_share.dart';
import 'package:reddit/widgets/chat_screen.dart';
import 'package:reddit/widgets/follower_list.dart';

class AddChat extends StatefulWidget {

 AddChat({super.key});

  @override
  State<AddChat> createState() => _AddChatState();
}

class _AddChatState extends State<AddChat> {
  List<FollowersFollowingItem>? foundFollowing ;
  List<FollowersFollowingItem>? Following =[];
  final TextEditingController usernameController = TextEditingController();
  bool followFetched = false;
  final UserService userController = GetIt.instance.get<UserService>();
  final UserController user = GetIt.instance.get<UserController>();
  Future<void> fetchUserFollow() async {
    if (!followFetched) {
    
        foundFollowing = await userController.getFollowing(user.userAbout!.username);
      Following=foundFollowing!;
      usernameController.text = "";
      setState(() {
        followFetched = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void searchFollow(String search) {
    setState(() {
      followFetched = true;
      foundFollowing = Following!.where((com) {
        final name = com.username.toLowerCase();
        return name.contains(search.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double heigth = MediaQuery.of(context).size.height;
    bool ismobile = (screenWidth < 700) ? true : false;

      return Scaffold(
        appBar:AppBar(
          centerTitle: true,
          title: const Text('New chat'),
           titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 244, 87, 3),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),   leading: GestureDetector(
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: Color.fromARGB(255, 244, 87, 3),
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),  ),
     
        ),
        
      body:  Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: RefreshIndicator(
          onRefresh: () async {
            followFetched = false;
            await fetchUserFollow();
          },
          child: Column(
            children: [
              TextField(
                onChanged: searchFollow,
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
              FutureBuilder<void>(
                future: fetchUserFollow(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text('none');
                    case ConnectionState.waiting:
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: foundFollowing!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = foundFollowing![index];
                            return InkWell(
                              onTap: () => {
                                  Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatPage(name: item.username,image: item.profilePicture!,), 
            ),
          )


                               
                              },
                              child: Card(
                                elevation: 0,
                                margin: const EdgeInsets.only(bottom: 1),
                                color: Colors.white,
                                child: ListTile(
                                  tileColor: Colors.white,
                                  leading: (item.profilePicture != null &&
                                        item.profilePicture! != "")
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            item.profilePicture!),
                                        radius: 15,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            AssetImage("images/Greddit.png"),
                                        radius: 15,
                                      ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item.username}",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    default:
                      return const Text('badr');
                  }
                },
              ),
            ],
          ),
        ),
      ),);

    
  }
}
