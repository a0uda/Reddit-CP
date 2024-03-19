import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../test_files/test_arrays.dart';
import '../Pages/profile_screen.dart';

class followerList extends StatefulWidget {
  const followerList({Key? key}) : super(key: key);

  @override
  _followerListState createState() => _followerListState();
}

class _followerListState extends State<followerList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Followers'),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: (user_data['followersList'] as List).length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/Greddit.png'),
                ),
                title: Text(
                    (user_data['followersList'] as List)[index]['username']),
                subtitle: Text(
                    'u/${(user_data['followersList'] as List)[index]['username']}·${(user_data['followersList'] as List)[index]['Karma']} Karma'),
                trailing: TextButton(
                  onPressed: () {
                    setState(() {
                      if ((user_data['followersList'] as List)[index]
                              ['Following'] ==
                          'yes') {
                        (user_data['followersList'] as List)[index]
                            ['Following'] = 'no';
                      } else {
                        (user_data['followersList'] as List)[index]
                            ['Following'] = 'yes';
                      }
                    });
                  },
                  child: Text(
                    (user_data['followersList'] as List)[index]['Following'] ==
                            'yes'
                        ? 'Following'
                        : 'Follow',
                    style: TextStyle(
                      color: (user_data['followersList'] as List)[index]
                                  ['Following'] ==
                              'yes'
                          ? const Color.fromARGB(255, 110, 110, 110)
                          : Colors.blue,
                    ),
                  ),
                ),
                onTap: () {
                  var username =
                      (user_data['followersList'] as List)[index]['username'];
                  var otherUserData;
                  for (var userData in otherUsersData) {
                    if (userData['username'] == username) {
                      otherUserData = userData;
                    }
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(otherUserData, 'other'),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
