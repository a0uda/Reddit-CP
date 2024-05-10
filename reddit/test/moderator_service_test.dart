import 'package:flutter_test/flutter_test.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/rules_item.dart';
import 'package:reddit/Services/moderator_service.dart';
import 'package:reddit/test_files/test_communities.dart';

void main() {
  group('ModeratorService', () {
    final moderatorService = ModeratorMockService();

    test('getRules returns list of rules for the given community name',
        () async {
      final communityName = 'Hyatt___Tillman';

      final rules = await moderatorService.getRules(communityName);

      expect(rules, isNotNull);
      expect(rules, isA<List<RulesItem>>());
      expect(
          rules,
          equals(communities
              .firstWhere(
                  (community) => community.communityName == communityName)
              .communityRules));
    });

    test(
        'editRules updates rule with the given id in the community with the given name',
        () async {
      final id = '1';
      final communityName = 'Hyatt___Tillman';
      final ruleTitle = 'testRuleTitle';
      final appliesTo = 'testAppliesTo';
      final reportReason = 'testReportReason';
      final ruleDescription = 'testRuleDescription';

      await moderatorService.editRules(
        id: id,
        communityName: communityName,
        ruleTitle: ruleTitle,
        appliesTo: appliesTo,
        reportReason: reportReason,
        ruleDescription: ruleDescription,
      );

      final rule = communities
          .firstWhere((community) => community.communityName == communityName)
          .communityRules
          .firstWhere((rule) => rule.id == id);

      expect(rule.ruleTitle, equals(ruleTitle));
      expect(rule.appliesTo, equals(appliesTo));
      expect(rule.reportReason, equals(reportReason));
      expect(rule.ruleDescription, equals(ruleDescription));
    });

    test(
        'getApprovedUsers returns list of approved users for the given community name',
        () async {
      final communityName = 'Hyatt___Tillman';

      final approvedUsers =
          await moderatorService.getApprovedUsers(communityName);

      expect(approvedUsers, isNotNull);
      expect(approvedUsers, isA<List<Map<String, dynamic>>>());
      expect(
          approvedUsers,
          equals(communities
              .firstWhere(
                  (community) => community.communityName == communityName)
              .approvedUsers));
    });
    test(
        'addApprovedUsers adds user with the given username to the approved users in the community with the given name',
        () async {
      final username = 'badr';
      final communityName = 'Hyatt___Tillman';

      await moderatorService.addApprovedUsers(username, communityName);

      final user = communities
          .firstWhere((community) => community.communityName == communityName)
          .approvedUsers
          .firstWhere((user) => user['username'] == username);

      expect(user, isNotNull);
      expect(user['username'], equals(username));
    });

    test(
        'setPostTypeAndOptions updates post types and options in the community with the given name',
        () async {
      final allowImages = true;
      final allowVideos = true;
      final allowPolls = true;
      final communityName = 'Hyatt___Tillman';
      final postTypes = 'testPostTypes';

      await moderatorService.setPostTypeAndOptions(
        allowImages: allowImages,
        allowVideos: allowVideos,
        allowPolls: allowPolls,
        communityName: communityName,
        postTypes: postTypes,
      );

      final community = communities
          .firstWhere((community) => community.communityName == communityName);

      expect(community.postTypes, equals(postTypes));
      expect(community.allowImage, equals(allowImages));
      expect(community.allowPolls, equals(allowPolls));
      expect(community.allowVideos, equals(allowVideos));
    });
    test(
        'postGeneralSettings updates general settings in the community with the given name',
        () async {
      final settings = GeneralSettings(
        communityID: 'testCommunityID',
        communityTitle: 'testCommunityTitle',
        communityDescription: 'testCommunityDescription',
        communityType: 'testCommunityType',
        nsfwFlag: true,
      );
      final communityName = 'Hyatt___Tillman';

      await moderatorService.postGeneralSettings(
        settings: settings,
        communityName: communityName,
      );

      final community = communities
          .firstWhere((community) => community.communityName == communityName);

      expect(community.general.communityID, equals(settings.communityID));
      expect(community.general.communityTitle, equals(settings.communityTitle));
      expect(community.general.communityDescription,
          equals(settings.communityDescription));
      expect(community.general.communityType, equals(settings.communityType));
      expect(community.general.nsfwFlag, equals(settings.nsfwFlag));
    });
    test(
        'getCommunityGeneralSettings returns general settings of the community with the given name',
        () async {
      final communityName = 'Hyatt___Tillman';

      final generalSettings =
          await moderatorService.getCommunityGeneralSettings(communityName);

      final expectedGeneralSettings = communities
          .firstWhere((community) => community.communityName == communityName)
          .general;

      expect(generalSettings, equals(expectedGeneralSettings));
    });

    test(
        'getPostTypesAndOptions returns post types and options of the community with the given name',
        () async {
      final communityName = 'Hyatt___Tillman';

      final postTypesAndOptions =
          await moderatorService.getPostTypesAndOptions(communityName);

      final expectedPostTypesAndOptions = {
        "postTypes": communities
            .firstWhere((community) => community.communityName == communityName)
            .postTypes,
        "allowImages": communities
            .firstWhere((community) => community.communityName == communityName)
            .allowImage,
        "allowPolls": communities
            .firstWhere((community) => community.communityName == communityName)
            .allowPolls,
        "allowVideo": communities
            .firstWhere((community) => community.communityName == communityName)
            .allowVideos,
      };

      expect(postTypesAndOptions, equals(expectedPostTypesAndOptions));
    });

    test(
        'addModUser adds user with the given username as a moderator in the community with the given name',
        () async {
      final username = 'badr';
      final profilePicture = 'testProfilePicture';
      final communityName = 'Hyatt___Tillman';
      final msgId = 'testMsgId';

      await moderatorService.addModUser(
          username, profilePicture, communityName, msgId);

      final user = communities
          .firstWhere((community) => community.communityName == communityName)
          .moderators
          .firstWhere((user) => user['username'] == username);

      expect(user, isNotNull);
      expect(user['username'], equals(username));
      expect(user['profile_picture'], equals(profilePicture));
    });

    test(
        'getMembersCount returns the number of members in the community with the given name',
        () async {
      final communityName = 'Hyatt___Tillman';

      final membersCount =
          await moderatorService.getMembersCount(communityName);

      expect(membersCount, isNotNull);
      expect(membersCount, isA<String>());
      expect(
          membersCount,
          equals(communities
              .firstWhere(
                  (community) => community.communityName == communityName)
              .communityMembersNo));
    });
    test(
        'removeAsMod removes user with the given username as a moderator in the community with the given name',
        () async {
      final username = 'Billie_Purdy';
      final communityName = 'Hyatt___Tillman';

      await moderatorService.removeAsMod(username, communityName);

      final user = communities
          .firstWhere((community) => community.communityName == communityName)
          .moderators
          .firstWhere((user) => user['username'] == username,
              orElse: () => <String, dynamic>{});

      expect(user, isEmpty);
    });
    test(
        'removeApprovedUsers removes user with the given username from the approved users in the community with the given name',
        () async {
      final username = 'badr';
      final communityName = 'Hyatt___Tillman';

      await moderatorService.removeApprovedUsers(username, communityName);
      final user = communities
          .firstWhere((community) => community.communityName == communityName)
          .approvedUsers
          .firstWhere((user) => user['username'] == username,
              orElse: () => <String, dynamic>{});
      expect(user, isEmpty);
    });

    test(
        'getBannedUsers returns the list of banned users in the community with the given name',
        () async {
      final communityName = 'Hyatt___Tillman';

      final bannedUsers = await moderatorService.getBannedUsers(communityName);

      expect(bannedUsers, isNotNull);
      expect(bannedUsers, isA<List<Map<String, dynamic>>>());
      expect(
          bannedUsers,
          equals(communities
              .firstWhere(
                  (community) => community.communityName == communityName)
              .bannedUsers));
    });
    test(
        'addBannedUsers adds user with the given username to the banned users in the community with the given name',
        () async {
      final username = 'testUsername';
      final communityName = 'Hyatt___Tillman';
      final permanentFlag = true;
      final reasonForBan = 'testReasonForBan';

      await moderatorService.addBannedUsers(
        username: username,
        communityName: communityName,
        permanentFlag: permanentFlag,
        reasonForBan: reasonForBan,
      );

      final user = communities
          .firstWhere((community) => community.communityName == communityName)
          .bannedUsers
          .firstWhere((user) => user['username'] == username);

      expect(user, isNotNull);
      expect(user['username'], equals(username));
      expect(user['reason_for_ban'], equals(reasonForBan));
      expect(user['permanent_flag'], equals(permanentFlag));
    });
    test(
        'updateBannedUser updates the details of the banned user with the given username in the community with the given name',
        () async {
      final username = 'Frances_Kunde39';
      final communityName = 'Hyatt___Tillman';
      final permanentFlag = true;
      final reasonForBan = 'testReasonForBan';
      final bannedUntil = 'testBannedUntil';
      final noteForBanMessage = 'testNoteForBanMessage';
      final modNote = 'testModNote';

      await moderatorService.updateBannedUser(
        username: username,
        communityName: communityName,
        permanentFlag: permanentFlag,
        reasonForBan: reasonForBan,
        bannedUntil: bannedUntil,
        noteForBanMessage: noteForBanMessage,
        modNote: modNote,
      );

      final user = communities
          .firstWhere((community) => community.communityName == communityName)
          .bannedUsers
          .firstWhere((user) => user['username'] == username);

      expect(user, isNotNull);
      expect(user['reason_for_ban'], equals(reasonForBan));
      expect(user['mod_note'], equals(modNote));
      expect(user['permanent_flag'], equals(permanentFlag));
      expect(user['banned_until'], equals(bannedUntil));
      expect(user['note_for_ban_message'], equals(noteForBanMessage));
    });
    test(
        'unBanUser removes the user with the given username from the banned users in the community with the given name',
        () async {
      final username = 'Frances_Kunde39';
      final communityName = 'Hyatt___Tillman';

      await moderatorService.unBanUser(username, communityName);

      final user = communities
          .firstWhere((community) => community.communityName == communityName)
          .bannedUsers
          .firstWhere((user) => user['username'] == username,
              orElse: () => <String, dynamic>{});

      expect(user, isEmpty);
    });

    test(
        'getMutedUsers returns the list of muted users in the community with the given name',
        () async {
      final communityName = 'Hyatt___Tillman';

      final mutedUsers = await moderatorService.getMutedUsers(communityName);

      expect(mutedUsers, isNotNull);
      expect(mutedUsers, isA<List<Map<String, dynamic>>>());
      expect(
          mutedUsers,
          equals(communities
              .firstWhere(
                  (community) => community.communityName == communityName)
              .mutedUsers));
    });
    test(
        'addMutedUsers adds user with the given username to the muted users in the community with the given name',
        () async {
      final username = 'jomana';
      final communityName = 'Hyatt___Tillman';

      await moderatorService.addMutedUsers(username, communityName);

      final user = communities
          .firstWhere((community) => community.communityName == communityName)
          .mutedUsers
          .firstWhere((user) => user['username'] == username);

      expect(user, isNotNull);
      expect(user['username'], equals(username));
    });

    test(
        'unMuteUser removes the user with the given username from the muted users in the community with the given name',
        () async {
      final username = 'Frances_Kunde39';
      final communityName = 'Hyatt___Tillman';

      await moderatorService.unMuteUser(username, communityName);

      final user = communities
          .firstWhere((community) => community.communityName == communityName)
          .mutedUsers
          .firstWhere((user) => user['username'] == username,
              orElse: () => <String, dynamic>{});

      expect(user, isEmpty);
    });

    test(
        'getModerators returns the list of moderators in the community with the given name',
        () async {
      final communityName = 'Hyatt___Tillman';

      final moderators = await moderatorService.getModerators(communityName);

      expect(moderators, isNotNull);
      expect(moderators, isA<List<Map<String, dynamic>>>());
      expect(
          moderators,
          equals(communities
              .firstWhere(
                  (community) => community.communityName == communityName)
              .moderators));
    });
    test(
        'inviteModerator adds a user with the given username and permissions to the moderators in the community with the given name',
        () async {
      final username = 'Frances_Kunde39';
      final communityName = 'Hyatt___Tillman';
      final everything = true;
      final manageUsers = true;
      final manageSettings = true;
      final managePostsAndComments = true;

      await moderatorService.inviteModerator(
        communityName: communityName,
        username: username,
        everything: everything,
        manageUsers: manageUsers,
        manageSettings: manageSettings,
        managePostsAndComments: managePostsAndComments,
      );

      final user = communities
          .firstWhere((community) => community.communityName == communityName)
          .moderators
          .firstWhere((user) => user['username'] == username);

      expect(user, isNotNull);
      expect(user['username'], equals(username));
      expect(user['everything'], equals(everything));
      expect(user['manage_users'], equals(manageUsers));
      expect(user['manage_settings'], equals(manageSettings));
      expect(user['manage_posts_and_comments'], equals(managePostsAndComments));
    });
    //  test('deleteRule removes rule with the given id in the community with the given name', () async {
    //   final id = '1';
    //   final communityName = 'Hyatt___Tillman';

    //   await moderatorService.deleteRule(communityName, id);

    //   final rule = communities
    //       .firstWhere((community) => community.communityName == communityName)
    //       .communityRules
    //       .firstWhere((rule) => rule.id == id, orElse: () => RulesItem(appliesTo: "",ruleTitle: ""));

    //   expect(rule, RulesItem(appliesTo: "",ruleTitle: ""));
    // });
  });
}
