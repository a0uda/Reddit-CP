import 'package:flutter/material.dart';

const comments = [
  {
    'person': 'John',
    'subreddit': 'FPGA',
    'time': '2024-03-15 16:34:00',
    'ups': '4',
    'comment': 'This is the first comment'
  },
  {
    'person': 'Jane',
    'subreddit': 'chatgp',
    'time': '2023-05-20 12:00:00',
    'ups': '1',
    'comment': 'This is the second comment'
  },
  {
    'person': 'Mark',
    'subreddit': 'flutter',
    'time': '2024-03-15 15:17:00',
    'ups': '10',
    'comment': 'This is the third comment'
  },
  {
    'person': 'Sue',
    'subreddit': 'dart',
    'time': '2020-03-16 12:00:00',
    'ups': '5',
    'comment': 'This is the fourth comment'
  },
  {
    'person': 'Tom',
    'subreddit': 'FPGA',
    'time': '2023-03-16 12:00:00',
    'ups': '15',
    'comment': 'This is the fifth comment'
  },
  {
    'person': 'Sally',
    'subreddit': 'chatgp',
    'time': '2024-03-10 12:00:00',
    'ups': '20',
    'comment': 'This is the sixth comment'
  },
  {
    'person': 'Bill',
    'subreddit': 'flutter',
    'time': '2024-03-15 12:00:00',
    'ups': '25',
    'comment': 'This is the seventh comment'
  },
  {
    'person': 'Jill',
    'subreddit': 'dart',
    'time': '2023-06-16 12:00:00',
    'ups': '3',
    'comment': 'This is the eighth comment'
  },
];

class TabBarComments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: comments.length,
      itemBuilder: (BuildContext context, int index) {
        var comment = comments[index];
        return ListTile(
          tileColor: Colors.white,
          title: Text(
            comment['person']!,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'r/${comment['subreddit']} • ${getDateTimeDifferenceWithLabel(comment['time']!)} • ${comment['ups']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 156, 156, 156),
                    ),
                  ),
                  Icon(
                    Icons.arrow_upward_outlined,
                    size: 16,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    comment['comment']!,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Color.fromARGB(255, 223, 222, 222),
          height: 1, // Adjust the height of the divider as needed
        );
      },
    );
  }
}

String getDateTimeDifferenceWithLabel(String dateFromDatabaseString) {
  // Parse the string from the database to a DateTime object
  DateTime dateFromDatabase = DateTime.parse(dateFromDatabaseString);

  // Get the current time
  DateTime currentTime = DateTime.now();

  // Calculate the difference between the current time and the database date
  Duration difference = currentTime.difference(dateFromDatabase);

  // Check the difference in years
  if (difference.inDays >= 365) {
    int years = (difference.inDays / 365).floor();
    return '${years}y';
  }

  // Check the difference in days
  else if (difference.inDays > 0) {
    return '${difference.inDays}d';
  }

  // Check the difference in hours
  else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  }

  // Check the difference in minutes
  else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  }

  // Check the difference in seconds
  else if (difference.inSeconds > 0) {
    return '${difference.inSeconds}s';
  }

  // If all differences are 0, return '0 s'
  else {
    return '0s';
  }
}
