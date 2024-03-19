import 'package:flutter/material.dart';
import 'follower_list.dart';

class ProfileHeaderLeftSide extends StatelessWidget {
  var userData;
  String
      userType; //if user type is 'me' then can show followers, else if others profile then don't show follow button
  ProfileHeaderLeftSide(this.userData, this.userType);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (2 / 3) * MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: ClipOval(
              child: Image(
                image: AssetImage('images/Greddit.png'),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              userData['username'].toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, bottom: 20),
            title: userType == 'me'
                ? Row(
                    children: <Widget>[
                      Text(
                        '${userData['followers'].toString()} followers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => followerList(),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        color: Colors.white,
                        iconSize: 15,
                      )
                    ],
                  )
                : Text(
                    'u/${userData['username'].toString()} - ${userData['karma'].toString()} karma - ${userData['date'].toString()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
            subtitle: userType == 'me'
                ? Text(
                    'u/${userData['username'].toString()} - ${userData['karma'].toString()} karma - ${userData['date'].toString()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
