import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';
import 'package:reddit/widgets/Moderator/approved_users.dart';

//hena widgetss kol wahdaaa

var desktopModTools = [
  const Text("Community Name"),
  const Text("Description"),
  const Text("Community Type"),
  const Text("Post Types"),
  const Text("Location"),
  const Text("Moderators"),
  const ApprovedUserList(),
  const Text("Banned Users"),
  const Text("Queues")
];

var mobileModTools = [
  const Text("Community Name"),
  const Text("Description"),
  const Text("Community Type"),
  const Text("Post Types"),
  const Text("Location"),
  const Text("Moderators"),
  const ApprovedUsers(),
  const Text("Banned Users"),
  const Text("Queues")
];
