import 'package:flutter/material.dart';
import '../test_files/test_arrays.dart';

class ProfileHeaderLeftSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (3 / 4) * MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: ClipOval(
              child: Image(
                image: AssetImage('assets/images/Greddit.png'),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              user_data['username'].toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, bottom: 20),
            title: Row(
              children: <Widget>[
                Text(
                  '${user_data['followers'].toString()} followers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print("hello from icon button");
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                  color: Colors.white,
                  iconSize: 15,
                ),
              ],
            ),
            subtitle: Text(
              'u/${user_data['username'].toString()} - ${user_data['karma'].toString()} karma - ${user_data['date'].toString()}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
