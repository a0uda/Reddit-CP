import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';
import 'package:reddit/widgets/Moderator/approved_users.dart';
import 'package:reddit/widgets/Moderator/banned_user.dart';
import 'package:reddit/widgets/Moderator/banned_user_list.dart';
import 'package:reddit/widgets/Moderator/moderators.dart';
import 'package:reddit/widgets/Moderator/moderators_list.dart';
import 'package:reddit/widgets/Moderator/muted_users.dart';
import 'package:reddit/widgets/Moderator/muted_users_list.dart';

//hena widgetss kol wahdaaa

var desktopModTools = [
  const Text("Community Name"),
  const Text("Description"),
  const Text("Community Type"),
  const Text("Post Types"),
  const Text("Location"),
  const ModeratorsList(),
  const ApprovedUserList(),
  const BannedUsersList(),
  const MutedUsersList(),
  const Text("Queues")
];

var mobileModTools = [
  const Text("Community Name"),
  const Text("Description"),
  const Text("Community Type"),
  const Text("Post Types"),
  const Text("Location"),
  const Moderators(),
  const ApprovedUsers(),
  const BannedUsers(),
  const MutedUsers(),
  const Text("Queues")
];
