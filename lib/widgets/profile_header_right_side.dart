import 'package:flutter/material.dart';

class ProfileHeaderRightSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (1 / 4) * MediaQuery.of(context).size.width,
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
                print('Button pressed');
              },
              child: Container(
                child: Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
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
        ],
      ),
    );
  }
}
