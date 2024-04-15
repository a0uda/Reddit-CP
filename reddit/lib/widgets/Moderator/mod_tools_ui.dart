import 'package:flutter/material.dart';
import 'package:reddit/widgets/Moderator/approved_user_list.dart';
import 'package:reddit/widgets/Moderator/approved_users.dart';
import 'package:reddit/widgets/Moderator/banned_user.dart';
import 'package:reddit/widgets/Moderator/banned_user_list.dart';
import 'package:reddit/widgets/Moderator/community_type.dart';
import 'package:reddit/widgets/Moderator/description.dart';
import 'package:reddit/widgets/Moderator/mobile_post_types.dart';
import 'package:reddit/widgets/Moderator/mod_rules.dart';
import 'package:reddit/widgets/Moderator/mod_rules_list.dart';
import 'package:reddit/widgets/Moderator/moderators.dart';
import 'package:reddit/widgets/Moderator/moderators_list.dart';
import 'package:reddit/widgets/Moderator/muted_users.dart';
import 'package:reddit/widgets/Moderator/muted_users_list.dart';
import 'package:reddit/widgets/Moderator/mod_community_name.dart';
import 'package:reddit/widgets/Moderator/post_types.dart';
import 'package:reddit/widgets/Moderator/queues.dart';

//hena widgetss kol wahdaaa

const bool isMobile = true;

var desktopModTools = [
  const ModCommName(),
  const ModDescription(),
  const CommunityType(),
  const PostTypes(),
  const Text("Location"),
  const ModeratorsList(),
  const ApprovedUserList(),
  const BannedUsersList(),
  const MutedUsersList(),
  const ModQueues(),
  const ModRulesList(isEditMode: false,),
];

var mobileModTools = [
  const ModCommName(),
  const ModDescription(),
  const CommunityType(),
  const MobilePostTypes(),
  const Text("Location"),
  const Moderators(),
  const ApprovedUsers(),
  const BannedUsers(),
  const MutedUsers(),
  const ModQueues(),
  const ModRules(),
];
