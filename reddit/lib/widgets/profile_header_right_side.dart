import 'package:flutter/material.dart';

class ProfileHeaderRightSide extends StatefulWidget {
  String userType;
  var userData;
  ProfileHeaderRightSide({Key? key, this.userData, required this.userType})
      : super(key: key);

  @override
  _ProfileHeaderRightSideState createState() =>
      _ProfileHeaderRightSideState(userData: userData, userType: userType);
}

class _ProfileHeaderRightSideState extends State<ProfileHeaderRightSide> {
  String
      userType; //if user type is 'me' then show edit button, else show message and follow button
  var userData;
  _ProfileHeaderRightSideState(
      {required this.userData, required this.userType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (1 / 3) * MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 30),
            child: IconButton(
              icon: Icon(Icons.share, color: Colors.white, size: 40),
              onPressed: () {
                // todo: Handle share action
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 30),
            child: TextButton(
              onPressed: () {
                if (userType == 'me') {
                  print('Button pressed ${userData} & ${userType}');
                } else {
                  setState(() {
                    if (userData['following'] == 'yes') {
                      userData['following'] = 'no';
                    } else {
                      userData['following'] = 'yes';
                    }
                  });
                }
              },
              child: userType == 'me'
                  ? Container(
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: userData['following'] == 'yes'
                          ? [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              Flexible(
                                child: Text(
                                  'Following',
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ]
                          : [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Follow',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                    ),
              style: TextButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(0, 68, 70, 71), // example background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          userType != 'me'
              ? Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15),
                  child: IconButton(
                    icon: Icon(Icons.message, color: Colors.white, size: 30),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(0, 68, 70, 71),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ))
              : Container(),
        ],
      ),
    );
  }
}
