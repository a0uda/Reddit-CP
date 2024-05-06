import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/active_communities.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/Models/notifications_settings_item.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/social_link_item.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/user_item.dart';
import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';
import '../Models/comments.dart';
import '../Models/message_item.dart';
import '../test_files/test_users.dart';
import '../test_files/test_messages.dart';
import 'package:http/http.dart' as http;

import 'package:google_sign_in/google_sign_in.dart';

bool testing = const bool.fromEnvironment('testing');

class UserService {
  void addUser() {
    if (testing) {
      //to be implemented
    } else {
      // add post to database
    }
  }

  Future<UserAbout>? getUserAbout(String username) async {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/about/$username');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('in get user about');
      print('username');
      print(username);

      print(response.body);
      print(jsonDecode(response.body)['content']['moderatedCommunities']);
      print(UserAbout.fromJson(jsonDecode(response.body)['content'])
          .moderatedCommunities);
      return UserAbout.fromJson(jsonDecode(response.body)['content']);
    }
  }

  Future<void> addSocialLink(String username, String displayText, String type,
      String customUrl) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .socialLinks!
          .add(SocialLlinkItem(
            id: (int.parse(users
                        .firstWhere(
                            (element) => element.userAbout.username == username)
                        .userAbout
                        .socialLinks![users
                                .firstWhere((element) =>
                                    element.userAbout.username == username)
                                .userAbout
                                .socialLinks!
                                .length -
                            1]
                        .id) +
                    1)
                .toString(),
            username: displayText,
            displayText: displayText,
            type: type,
            customUrl: customUrl,
          ));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/add-social-link');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          "username": displayText,
          "display_text": displayText,
          "custom_url": customUrl,
          "type": type.toLowerCase(),
        }),
      );
      print('in add social link');
      print(response.body);
    }
  }

  Future<void> followUser(String username, String follower) async {
    if (testing) {
      //add myself to the user being followed followers list
      users
          .firstWhere((element) => element.userAbout.username == username)
          .followers!
          .add(FollowersFollowingItem(
            username: follower,
          ));
      //add user being followed to my following list
      users
          .firstWhere((element) => element.userAbout.username == follower)
          .following!
          .add(FollowersFollowingItem(
            username: username,
          ));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/follow-unfollow-user');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          "other_username": username,
        }),
      );
      print('fi follow user');
      print(response.body);
    }
  }

  Future<void> unfollowUser(String username, String follower) async {
    if (testing) {
      //remove myself from the user being followed followers list
      users
          .firstWhere((element) => element.userAbout.username == username)
          .followers!
          .removeWhere((element) => element.username == follower);
      //remove user being followed from my following list
      users
          .firstWhere((element) => element.userAbout.username == follower)
          .following!
          .removeWhere((element) => element.username == username);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/follow-unfollow-user');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'other_username': username,
        }),
      );
      print('in unfollow user');
      print(response.body);
    }
  }

  Future<int> getFollowersCount(String username) async {
    if (testing) {
      List<FollowersFollowingItem> followers = users
          .firstWhere((element) => element.userAbout.username == username)
          .followers!;
      List<BlockedUsersItem> blockedUsers = users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers;
      followers.removeWhere((element) => blockedUsers
          .any((blockedUser) => blockedUser.username == element.username));
      return followers.length;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/followers-count');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('in get followers count');
      print(response.statusCode);
      print(response.body);
      print(jsonDecode(response.body)['content']);
      return jsonDecode(response.body)['content'];
    }
  }

  Future<List<FollowersFollowingItem>> getFollowers(String username) async {
    if (testing) {
      List<FollowersFollowingItem> followers = users
          .firstWhere((element) => element.userAbout.username == username)
          .followers!;
      List<BlockedUsersItem> blockedUsers = users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers;
      followers.removeWhere((element) => blockedUsers
          .any((blockedUser) => blockedUser.username == element.username));
      return followers;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse('https://redditech.me/backend/users/followers');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('in get followers');
      print(response.statusCode);
      print(response.body);
      List<dynamic> body = jsonDecode(response.body)['content'];
      print(body);
      return Future.wait(body
          .map((dynamic item) async => FollowersFollowingItem.fromJson(item)));
    }
  }

  Future<int> getFollowingCount(String username) async {
    if (testing) {
      List<FollowersFollowingItem> following = users
          .firstWhere((element) => element.userAbout.username == username)
          .following!;
      List<BlockedUsersItem> blockedUsers = users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers;
      following.removeWhere((element) => blockedUsers
          .any((blockedUser) => blockedUser.username == element.username));
      return following.length;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/following-count');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('in get following count');
      print(response.statusCode);
      print(response.body);
      print(jsonDecode(response.body)['content']);
      return jsonDecode(response.body)['content'];
    }
  }

  Future<List<FollowersFollowingItem>> getFollowing(String username) async {
    if (testing) {
      List<FollowersFollowingItem> following = users
          .firstWhere((element) => element.userAbout.username == username)
          .following!;
      List<BlockedUsersItem> blockedUsers = users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers;
      following.removeWhere((element) => blockedUsers
          .any((blockedUser) => blockedUser.username == element.username));
      return following;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse('https://redditech.me/backend/users/following');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print("in get following");
      print(response.body);
      List<dynamic> body = jsonDecode(response.body)['content'];
      List<FollowersFollowingItem> following = await Future.wait(body
          .map((dynamic item) async => FollowersFollowingItem.fromJson(item)));
      print(following);
      return following;
    }
  }

  Future<List<Comments>?> getcomments(String username) async {
    if (testing) {
      List<Comments> comments = users
          .firstWhere((element) => element.userAbout.username == username)
          .comments!;
      List<BlockedUsersItem> blockedUsers = users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers;
      comments.removeWhere((element) => blockedUsers
          .any((blockedUser) => blockedUser.username == element.username));
      return comments;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/comments/$username');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('in get following user comments');
      print(response.statusCode);
      print(response.body);
      List<dynamic> body = jsonDecode(response.body)['content'];
      print(body);
      return Future.wait(
          body.map((dynamic item) async => Comments.fromJson(item)));
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<ProfileSettings?> getProfileSettings(String username) async {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .profileSettings;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/profile-settings');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      // print("In get profile settings");
      // print(response.statusCode);
      // print(response.body);
      // print(jsonDecode(response.body)['content']);
      return ProfileSettings.fromJson(jsonDecode(response.body)['content']);
    }
  }

  Future<void> updateProfileSettings(
      String username,
      String displayName,
      String about,
      bool? nsfwFlag,
      bool? allowFollowers,
      bool contentVisibility,
      bool activeCommunity) async {
    if (testing) {
      var user =
          users.firstWhere((element) => element.userAbout.username == username);
      user.userAbout.displayName = displayName;
      user.userAbout.about = about;
      nsfwFlag != null ? user.profileSettings?.nsfwFlag = nsfwFlag : null;
      allowFollowers != null
          ? user.profileSettings?.allowFollowers = allowFollowers
          : null;
      user.profileSettings?.contentVisibility = contentVisibility;
      user.profileSettings?.activeCommunity = activeCommunity;
    } else {
      final url = Uri.parse(
          'https://redditech.me/backend/users/change-profile-settings');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'profile_settings': {
            'display_name': displayName,
            'about': about,
            'nsfw_flag': nsfwFlag,
            'allow_followers': allowFollowers,
            'content_visibility': contentVisibility,
            'active_communities_visibility': activeCommunity,
          }
        }),
      );
      print("in update profile settings");
      print(response.body);
    }
  }

  Future<void> updateAllowFollowers(bool allowFollowers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url =
        Uri.parse('https://redditech.me/backend/users/change-profile-settings');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
      body: json.encode({
        'profile_settings': {
          'allow_followers': allowFollowers,
        }
      }),
    );
    if (response.statusCode == 200) {
      print('updated allow followers flag');
    }
    print(response.body);
  }

  Future<void> addBannerPicture(String username, String bannerPicture) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .bannerPicture = bannerPicture;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/add-banner-picture');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'banner_picture': bannerPicture,
        }),
      );
      print("in add banner picture");
      print(bannerPicture);
      print(response.body);
    }
  }

  Future<void> addProfilePicture(String username, String profilePicture) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .profilePicture = profilePicture;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/add-profile-picture');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          'profile_picture': profilePicture,
        }),
      );
      print(response.body);
    }
  }

  Future<void> removeBannerPicture(String username) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .bannerPicture = null;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/delete-banner-picture');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print(response.body);
    }
  }

  Future<void> removeProfilePicture(String username) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .profilePicture = null;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/users/delete-profile-picture');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print(response.body);
    }
  }

  Future<void> deleteSocialLink(String username, String id) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .socialLinks!
          .removeWhere((element) => element.id == id);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/delete-social-link');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({"id": id}),
      );
      print('in edit social link');
      print(response.body);
    }
  }

  Future<void> editSocialLink(
      String username, String id, String displayText, String customUrl) async {
    if (testing) {
      var socialLink = users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .socialLinks!
          .firstWhere((element) => element.id == id);
      socialLink.displayText = displayText;
      socialLink.username = displayText;
      socialLink.customUrl = customUrl;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/edit-social-link');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          "username": displayText,
          "display_text": displayText,
          "custom_url": customUrl,
          "id": id
        }),
      );
      print('in edit social link');
      print(response.body);
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<Messages>?> getMessages(String username) async {
    if (testing) {
      List<Messages> messages = List.from(users
          .firstWhere((element) => element.userAbout.username == username)
          .usermessages!);
      List<BlockedUsersItem> blockedUsers = users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers;
      messages.removeWhere((element) => blockedUsers.any((blockedUser) =>
          blockedUser.username == element.senderUsername ||
          blockedUser.username == element.receiverUsername));
      return messages;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/messages/read-all-messages');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('in get messages');
      print(response.body);
      List<dynamic> body = jsonDecode(response.body)['messages'];
      List<Messages>? messages = await Future.wait(
        body
            .where((item) => item != null)
            .map((dynamic item) async => Messages.fromJson(item)),
      );
      return messages;
    }
  }

  Future<int> getUnreadMessagesCount(String username) async {
    if (testing) {
      List<Messages> messages = List.from(users
          .firstWhere((element) => element.userAbout.username == username)
          .usermessages!);
      int count = 0;
      count = messages.where((element) => element.unreadFlag == true).length;
      return count;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/messages/unread-count');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('in get unread messages count');
      print(jsonDecode(response.body));
      return jsonDecode(response.body)['count'];
    }
  }

  Future<bool> replyMessage(
      String parentid,
      String senderUsername,
      String receiverUsername,
      String receiverType,
      String senderType,
      String? senderVia,
      String message,
      String subject) async {
    if (testing) {
      List<Messages>? userMessages = users
          .firstWhere((element) => element.userAbout.username == senderUsername)
          .usermessages;
      userMessages?.add(Messages(
        id: (int.parse(userMessages[userMessages.length - 1].id) + 1)
            .toString(),
        senderUsername: senderUsername,
        senderType: senderType,
        receiverUsername: receiverUsername,
        receiverType: receiverType,
        senderVia: senderVia,
        message: message,
        createdAt: DateTime.now().toString(),
        unreadFlag: false,
        isSent: true,
        isReply: false,
        parentMessageId: parentid,
        subject: null,
        isInvitation: false,
      ));
      return true;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse('https://redditech.me/backend/messages/reply');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          "data": {
            "sender_type": senderType,
            "receiver_username": receiverUsername,
            "receiver_type": receiverType,
            "subject": subject,
            "message": message,
            "senderVia": senderVia,
            "parent_message_id": parentid
          }
        }),
      );
      print(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> sendNewMessage(String senderUsername, String receiverUsername,
      String message, String subject) async {
    if (testing) {
      List<BlockedUsersItem> blockedUsers = users
          .firstWhere((element) => element.userAbout.username == senderUsername)
          .safetySettings!
          .blockedUsers;
      if (users.any((element) =>
                  element.userAbout.username == receiverUsername) ==
              false ||
          (blockedUsers
                  .any((element) => element.username == receiverUsername) ==
              true)) {
        return false;
      } else {
        List<Messages>? userMessages = users
            .firstWhere(
                (element) => element.userAbout.username == senderUsername)
            .usermessages;
        userMessages?.add(Messages(
          id: (int.parse(userMessages[userMessages.length - 1].id) + 1)
              .toString(),
          senderUsername: senderUsername,
          senderType: 'user',
          receiverUsername: receiverUsername,
          receiverType: 'user',
          senderVia: null,
          message: message,
          createdAt: DateTime.now().toString(),
          unreadFlag: true,
          isSent: true,
          isReply: false,
          parentMessageId: null,
          subject: subject,
          isInvitation: false,
        ));
        return true;
      }
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse('https://redditech.me/backend/messages/compose');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          "data": {
            "sender_type": "user",
            "receiver_username": receiverUsername,
            "receiver_type": "user",
            "subject": subject,
            "message": message
          }
        }),
      );
      print("in send new message");
      print(senderUsername);
      print(receiverUsername);
      print(message);
      print(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> markoneMessageRead(String username, List<String> msgId) async {
    if (testing) {
      List<Messages>? userMessages = users
          .firstWhere((element) => element.userAbout.username == username)
          .usermessages;
      userMessages?.forEach((message) {
        if (msgId.contains(message.id)) {
          message.unreadFlag = false;
        }
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/messages/mark-as-read');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: json.encode({
          "Messages": [
            for (var id in msgId) {"_id": id}
          ]
        }),
      );
      print('in mark one message read');
      print(response.body);
    }
  }

  Future<void> markAllMessagesRead(String username) async {
    if (testing) {
      List<Messages>? userMessages = users
          .firstWhere((element) => element.userAbout.username == username)
          .usermessages;
      for (var msg in userMessages!) {
        msg.unreadFlag = false;
      }
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/messages/mark-all-as-read');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('in mark all messages as read');
      print(response.body);
    }
  }

  Future<void> reportUser(String username, String reason) async {
    if (testing) {
      //to be implemented
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse('https://redditech.me/backend/users/report-user');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          "reported_username": username,
        }),
      );
      print('in report user');
      print(response.body);
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<ActiveCommunitiesResult> getActiveCommunities(String username) async {
    if (testing) {
      ActiveCommunitiesResult activeCommunitiesResult = ActiveCommunitiesResult(
        activeCommunities: users
            .firstWhere((element) => element.userAbout.username == username)
            .activecommunities!,
        showActiveCommunities: users
            .firstWhere((element) => element.userAbout.username == username)
            .profileSettings!
            .activeCommunity,
      );
     return activeCommunitiesResult;
    }
  else {
      final url =
          Uri.parse('https://redditech.me/backend/users/active-communities?username=$username');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('in get active communities');
      print(response.statusCode);
      print(response.body);
      return ActiveCommunitiesResult.fromJson(jsonDecode(response.body)['content']);
    }
  }

  Future<List<CommunityBackend>?> getUserCommunities() async {
    if (testing) {
      return [];
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse('https://redditech.me/backend/users/communities');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      List<dynamic> decoded = jsonDecode(response.body)['content'] ?? [];
      print(response.body);
      return List<CommunityBackend>.from(
          decoded.map((community) => CommunityBackend.fromJson(community)));
    }
  }

  Future<List<CommunityBackend>?> getUserModerated() async {
    if (testing) {
      return [];
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/moderated-communities');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      List<dynamic> decoded = jsonDecode(response.body)['content'] ?? [];
      print(response.body);
      return List<CommunityBackend>.from(
          decoded.map((community) => CommunityBackend.fromJson(community)));
    }
  }

  Future<int> forgetPassword(String email, String username) async {
    if (testing) {
      return 200;
    } else {
      final url =
          Uri.parse('https://redditech.me/backend/users/forget-password');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
        }),
      );
      print(response.body);
      return response.statusCode;
    }
  }

  Future<int> forgetUsername(
    String email,
  ) async {
    if (testing) {
      return 200;
    } else {
      final url =
          Uri.parse('https://redditech.me/backend/users/forget-username');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
        }),
      );
      print(response.body);
      return response.statusCode;
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<int> userSignup(
      String username, String password, String email, String gender) async {
    if (testing) {
      if (password.length < 8) {
        return 400;
      }

      if (username == password) {
        return 400;
      }

      if (!_isValidEmail(email)) {
        return 400;
      }

      if (availableUsername(username) == 400) {
        return 400;
      }

      if (availableEmail(email) == 400) {
        return 400;
      }

      UserAbout newUserAbout = UserAbout(
        username: username,
        email: email,
        verifiedEmailFlag: false,
        gender: gender,
      );

      UserItem newUserItem = UserItem(
        userAbout: newUserAbout,
        password: password,
        followers: [],
        following: [],
      );

      users.add(newUserItem);

      return 200;
    } else {
      final url = Uri.parse('https://redditech.me/backend/users/signup');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'gender': gender,
          'password': password,
        }),
      );
      print(response.body);

      // i want to check if response.message == 'Username already exists, choose another' to return 0
      var responseBody = jsonDecode(response.body);
      print(response.statusCode);
      if (response.statusCode == 201) {
        return 200;
      } else {
        if (responseBody['error']['message'] ==
            'Username already exists, choose another') {
          return 0;
        } else if (responseBody['error']['message'] ==
            'Email already exists, choose another') {
          return 2;
        }
      }
      return response.statusCode;
    }
  }

  Future<int> userLogin(String username, String password) async {
    print("herree");
    if (testing) {
      if (users.any((user) =>
          user.userAbout.username == username && user.password == password)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        return 200;
      } else {
        return 400;
      }
    } else {
      final url = Uri.parse('https://redditech.me/backend/users/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      final token = response.headers['authorization'];
      print(response.body);
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token!);
        prefs.setString('username', username);
        prefs.setBool('googleLogin', false);
        return 200;
      } else {
        return 400;
      }
    }
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('https://redditech.me/backend/users/logout');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
    );
    prefs.remove('token');
    prefs.remove('username');
    if (prefs.getBool('googleLogin') == true) {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      prefs.remove('googleLogin');
    }
    return true;
  }

  Future<bool> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      // The access token can be used to authenticate with your backend
      var accessToken = googleSignInAuthentication!.accessToken;

      if (accessToken != null) {
        print('Google login auth success');
        print(accessToken);

        final url =
            Uri.parse('https://redditech.me/backend/users/signup-google');

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'access_token': accessToken,
          }),
        );

        final token = response.headers['authorization'];
        print(response.body);
        print(token);
        print(response.statusCode);
        if (response.statusCode == 200) {
          print('google login status 200');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token!);
          prefs.setBool('googleLogin', true);
          String username = jsonDecode(response.body)['username'];
          prefs.setString('username', username);
          final userController = GetIt.instance.get<UserController>();
          await userController.getUser(username);
          return true;
        } else {
          return false;
        }
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<int> availableUsername(String username) async {
    return users.any((user) => user.userAbout.username == username) ? 400 : 200;
  }

  Future<int> availableEmail(String email) async {
    return users.any((user) => user.userAbout.email == email) ? 400 : 200;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<BlockedUsersItem>> getBlockedUsers(String username) async {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print('in blocked');
      print(token);
      final url = Uri.parse('https://redditech.me/backend/users/blocked-users');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('in get blocked users');
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('get blocked success');
        var data = jsonDecode(response.body);
        List<dynamic> blockedUsersJson = data['content'];
        return Future.wait(blockedUsersJson
            .map((json) => BlockedUsersItem.fromJson(json))
            .toList());
      } else {
        throw Exception('Failed to load blocked users');
      }
    }
  }

  Future<void> blockUser(String username, String blockedUsername) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers
          .add(BlockedUsersItem(
            username: blockedUsername,
            profilePicture: users
                    .firstWhere((element) =>
                        element.userAbout.username == blockedUsername)
                    .userAbout
                    .profilePicture ??
                'images/Greddit.png',
            blockedDate: DateTime.now().toString(),
          ));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/block-unblock-user');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          'blocked_username': blockedUsername,
        }),
      );

      if (response.statusCode == 200) {
        print('block success');
      } else {
        throw Exception('Failed to block user.');
      }
    }
  }

  Future<void> unblockUser(String username, String blockedUsername) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers
          .removeWhere((element) => element.username == blockedUsername);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/block-unblock-user');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({'blocked_username': blockedUsername}),
      );

      if (response.statusCode == 200) {
        print('User unblocked successfully.');
      } else {
        throw Exception('Failed to unblock user.');
      }
    }
  }

  Future<AccountSettings>? getAccountSettings(String username) async {
    if (testing) {
      return users
              .firstWhere((element) => element.userAbout.username == username)
              .accountSettings ??
          AccountSettings(
            email: '',
            verifiedEmailFlag: false,
            country: '',
            gender: '',
            gmail: '',
            connectedGoogle: false,
          );
    } else {
      // get account settings from database
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/users/account-settings');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('in get account settings');
      print(response.statusCode);
      print(response.body);
      return AccountSettings.fromJson(jsonDecode(response.body)['content']);
    }
  }

  Future<bool> changeEmail(
      String username, String newEmail, String password) async {
    if (testing) {
      if (availableEmail(newEmail) == 400) {
        return false;
      }
      if (password !=
          users
              .firstWhere((element) => element.userAbout.username == username)
              .password) {
        return false;
      }
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .email = newEmail;
      users
          .firstWhere((element) => element.userAbout.username == username)
          .accountSettings!
          .email = newEmail;
      return true;
    } else {
      // change email in database
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse('https://redditech.me/backend/users/change-email');

      final response = await http.patch(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token!,
          },
          body: jsonEncode({
            'new_email': newEmail,
            'password': password,
          }));
      print(json.encode({
        'new_email': newEmail,
        'password': password,
      }));

      print("in change email");
      print(response.statusCode);

      return response.statusCode == 200 ? true : false;
    }
  }

  Future<bool> addPassword(
      String username, String newPassword, String verifiedNewPassword) async {
    if (testing) {
      return true;
    } else {
      var url = Uri.parse('https://redditech.me/backend/users/reset-password');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token!,
        },
        body: jsonEncode({
          "new_password": newPassword,
          "verified_password": verifiedNewPassword,
        }),
      );

      print(response.body);
      print(response.statusCode);

      return response.statusCode == 200;
    }
  }

  Future<bool> changePassword(String username, String currentPassword,
      String newPassword, String verifiedNewPassword) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .password = newPassword;
      return true;
    } else {
      var url = Uri.parse('https://redditech.me/backend/users/change-password');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token!,
        },
        body: jsonEncode({
          "current_password": currentPassword,
          "new_password": newPassword,
          "verified_new_password": verifiedNewPassword,
        }),
      );
      return response.statusCode == 200;
    }
  }

  Future<bool> changeGender(String username, String gender) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .accountSettings
          ?.gender = gender;
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .gender = gender;
      return true;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final UserController userController =
          GetIt.instance.get<UserController>();
      String country = userController.userAbout?.country ?? '';

      final url = Uri.parse(
          'https://redditech.me/backend/users/change-account-settings');

      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          "account_settings": {
            "country": country,
            "gender": gender,
          },
        }),
      );
      print('ana fe change gender');
      print(token);
      print(jsonEncode({
        'account_settings': {
          'gender': gender,
          'country': country,
        },
      }));
      print(response.statusCode);
      print(response.body);

      return response.statusCode == 200 ? true : false;
    }
  }

  Future<void> changeCountry(String username, String country) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .accountSettings
          ?.country = country;

      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .country = country;
    } else {
      // change country in db
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final UserController userController =
          GetIt.instance.get<UserController>();
      String gender = userController.userAbout?.gender ?? '';

      final url = Uri.parse(
          'https://redditech.me/backend/users/change-account-settings');

      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          "account_settings": {
            "country": country,
            "gender": gender,
          },
        }),
      );
      print('ana fe change country');
      print(response.statusCode);
      print(
        jsonEncode({
          "account_settings": {
            "country": country,
            "gender": gender,
          },
        }),
      );
    }
  }

  Future<bool> connectToGoogle(String username) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .accountSettings
          ?.connectedGoogle = true;
      return true;
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      try {
        await googleSignIn.signOut();
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();
        final GoogleSignInAuthentication? googleSignInAuthentication =
            await googleSignInAccount?.authentication;

        // The access token can be used to authenticate with your backend
        var accessToken = googleSignInAuthentication!.accessToken;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        final url =
            Uri.parse('https://redditech.me/backend/users/connect-to-google');

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token!,
          },
          body: jsonEncode({
            'access_token': accessToken,
          }),
        );
        await googleSignIn.signOut();
        print(response.body);
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } catch (error) {
        print(error);
        return false;
      }
    }
  }

  Future<int> disconnectFromGoogle(String username, String password) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .accountSettings
          ?.connectedGoogle = false;
      return 200;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url =
          Uri.parse('https://redditech.me/backend/users/disconnect-google');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          'password': password,
        }),
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        return 200;
      } else {
        var responseBody = jsonDecode(response.body);
        if (responseBody['error']['message'] ==
            'User must set his password first') {
          return 2;
        }
        return response.statusCode;
      }
    }
  }

  // toggle disconnect from google in db

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> saveComment(String username, String commentId) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .savedCommentsIds!
          .add(commentId);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/posts-or-comments/save');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          'is_post': false,
          'id': commentId,
        }),
      );

      if (response.statusCode == 200) {
        print('Comment saved successfully.');
      } else {
        throw Exception('Failed to save comment.');
      }
    }
  }

  Future<void> unsaveComment(String username, String commentId) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .savedCommentsIds!
          .remove(commentId);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url =
          Uri.parse('https://redditech.me/backend/posts-or-comments/save');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          'is_post': false,
          'id': commentId,
        }),
      );
      if (response.statusCode == 200) {
        print('Comment unsaved successfully.');
      } else {
        throw Exception('Failed to unsave comment.');
      }
    }
  }

  Future<List<Comments>> getSavedComments(String username) async {
    if (testing) {
      List<Comments> savedComments = [];
      final user =
          users.firstWhere((element) => element.userAbout.username == username);
      final commentService = GetIt.instance.get<CommentsService>();

      for (var commentId in user.savedCommentsIds!) {
        final comment = commentService.getCommentById(commentId);
        if (comment != null) {
          savedComments.add(comment);
        }
      }

      return savedComments;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/users/saved-posts-and-comments');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );
      print('comments');
      print(response.statusCode);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body)['content']['comments'];
        print(body);
        return Future.wait(
            body.map((dynamic item) async => Comments.fromJson(item)));
      } else {
        throw Exception('Failed to load comments.');
      }
    }
  }

  Future<NotificationsSettingsItem>? getNotificationsSettings(
      String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url =
        Uri.parse('https://redditech.me/backend/users/notification-settings');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
    );
    print(response.statusCode);
    print(response.body);
    return NotificationsSettingsItem.fromJson(
        jsonDecode(response.body)['content']);
  }

  Future<void> updateNotificationSettings(String username,
      NotificationsSettingsItem notificationsSettingsItem) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .notificationsSettings = notificationsSettingsItem;
    } else {
      // update notification settings in db
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/users/change-notification-settings');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          'notifications_settings': {
            'mentions': notificationsSettingsItem.mentions,
            'comments': notificationsSettingsItem.comments,
            'upvotes_posts': notificationsSettingsItem.upvotesPosts,
            'upvotes_comments': notificationsSettingsItem.upvotesComments,
            'replies': notificationsSettingsItem.replies,
            'new_followers': notificationsSettingsItem.newFollowers,
            'invitations': notificationsSettingsItem.invitations,
            'posts': notificationsSettingsItem.posts,
            'private_messages': notificationsSettingsItem.privateMessages,
            'chat_messages': notificationsSettingsItem.chatMessages,
            'chat_requests': notificationsSettingsItem.chatRequests,
          }
        }),
      );
      print(
        jsonEncode({
          'notification_settings': {
            'mentions': notificationsSettingsItem.mentions,
            'comments': notificationsSettingsItem.comments,
            'upvotes_posts': notificationsSettingsItem.upvotesPosts,
            'upvotes_comments': notificationsSettingsItem.upvotesComments,
            'replies': notificationsSettingsItem.replies,
            'new_followers': notificationsSettingsItem.newFollowers,
            'invitations': notificationsSettingsItem.invitations,
            'posts': notificationsSettingsItem.posts,
            'private_messages': notificationsSettingsItem.privateMessages,
            'chat_messages': notificationsSettingsItem.chatMessages,
            'chat_requests': notificationsSettingsItem.chatRequests,
          }
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print('notification settings updated successfully');
      } else {
        print('failed to update notification settings');
      }
    }
  }

  Future<void> updateSingleNotificationSetting(
      String username, String notificationType, bool value) async {
    if (testing) {
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final url = Uri.parse(
          'https://redditech.me/backend/users/change-notification-settings');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          'notifications_settings': {
            notificationType: value,
          }
        }),
      );
      print(token);
      print(
        jsonEncode({
          'notifications_settings': {
            notificationType: value,
          }
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print('notification settings updated successfully');
      } else {
        print('failed to update notification settings');
      }
    }
  }
}


