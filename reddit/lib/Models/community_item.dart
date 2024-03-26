import 'package:flutter/material.dart';
import 'package:reddit/Models/rules_item.dart';

class CommunityItem {
  CommunityItem({
    required this.communityID,
    required this.communityName,
    required this.communityMembersNo,
    required this.communityRules,
    required this.communityProfilePicturePath,
    required this.communityDescription,
  });

  final int communityID;
  final String communityName;
  final int communityMembersNo;
  final List<RulesItem> communityRules;
  final String communityProfilePicturePath; 
  final String communityDescription;
}



