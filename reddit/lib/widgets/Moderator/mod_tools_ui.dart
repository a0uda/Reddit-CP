import 'package:reddit/widgets/Moderator/approved_users.dart';
import 'package:reddit/widgets/Moderator/banned_user.dart';
import 'package:reddit/widgets/Moderator/change_banner_profile_picture.dart';
import 'package:reddit/widgets/Moderator/community_type.dart';
import 'package:reddit/widgets/Moderator/description.dart';
import 'package:reddit/widgets/Moderator/mod_rules.dart';
import 'package:reddit/widgets/Moderator/moderators.dart';
import 'package:reddit/widgets/Moderator/muted_users.dart';
import 'package:reddit/widgets/Moderator/mod_community_name.dart';
import 'package:reddit/widgets/Moderator/post_types.dart';
import 'package:reddit/widgets/Moderator/queues.dart';
import 'package:reddit/widgets/Moderator/removal_reaosns.dart';
import 'package:reddit/widgets/Moderator/scheduled.dart';

//hena widgetss kol wahdaaa

const bool isMobile = true;



var mobileModTools = [
  const ModCommName(),
  const ModDescription(),
  const ChangeProfilePicture(),
  const CommunityType(),
  const PostTypes(),
  Moderators(),
  const ApprovedUsers(),
  const BannedUsers(),
  const MutedUsers(),
  const ModQueues(),
  const ModRules(),
  const RemovalReasons(),
  const ScheduledPosts(),
];
