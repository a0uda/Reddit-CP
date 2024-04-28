import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:reddit/Controllers/user_controller.dart';
import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/communtiy_backend.dart';
import 'package:reddit/Models/notifications_settings_item.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/community_item.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/social_link_item.dart';
import 'package:reddit/Services/comments_service.dart';
import 'package:reddit/widgets/notifications_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/user_item.dart';
import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';
import '../Models/comments.dart';
import '../test_files/test_users.dart';
import 'package:http/http.dart' as http;

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

      print(response.statusCode);
      print(jsonDecode(response.body)['content']['moderatedCommunities']);
      print(UserAbout.fromJson(jsonDecode(response.body)['content']).moderatedCommunities);
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
      final url =
          Uri.parse('https://redditech.me/backend/users/follow-unfollow-user');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'other_username': username,
        }),
      );
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
      final url =
          Uri.parse('https://redditech.me/backend/users/follow-unfollow-user');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'other_username': username,
        }),
      );
      print(response.body);
    }
  }

  Future<int> getFollowersCount(String username) async {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .followers!
          .length;
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
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .followers!;
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
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .following!
          .length;
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
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .following!;
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
      print(response.statusCode);
      List<dynamic> body = jsonDecode(response.body)['content'];
      print(body);
      return Future.wait(body
          .map((dynamic item) async => FollowersFollowingItem.fromJson(item)));
    }
  }

  Future<List<Comments>?> getcomments(String username) async {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .comments!;
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
      print("In get profile settings");
      print(response.statusCode);
      print(response.body);
      print(jsonDecode(response.body)['content']);
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
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .socialLinks!
          .removeWhere((element) => element.id == id);
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
      var socialLink = users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .socialLinks!
          .firstWhere((element) => element.id == id);
      socialLink.displayText = displayText;
      socialLink.username = displayText;
      socialLink.customUrl = customUrl;
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<CommunityItem>?> getActiveCommunities(String username) async {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .activecommunities!;
    } else {
      //todo: get active communities from database
      return users
          .firstWhere((element) => element.userAbout.username == 'Purple-7544')
          .activecommunities!;
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
      List<dynamic> decoded = jsonDecode(response.body)['content'];
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
        return 200;
      } else {
        return 400;
      }
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  int availableUsername(String username) {
    return users.any((user) => user.userAbout.username == username) ? 400 : 200;
  }

  int availableEmail(String email) {
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
      final url = Uri.parse('https://redditech.me/backend/users/blocked-users');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );

      if (response.statusCode == 200) {
        print('get block success');
        var data = jsonDecode(response.body);
        Map<String, dynamic> blockedUsersJson = data['blocked_users'];
        return Future.wait(blockedUsersJson.values
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
          'Content': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode({
          'blocked_username': blockedUsername,
        }),
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

  Future<bool> changePassword(String username, String currentPassword,
      String newPassword, String verifiedNewPassword) async {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .password = newPassword;
      return true;
    } else {
      var url = Uri.parse('http://redditech.me//backend/users/change-password');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token!,
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'verified_new_password': verifiedNewPassword,
        }),
      );
      print(token);
      print(response.statusCode);
      print(
        jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
          'verified_new_password': verifiedNewPassword,
        }),
      );
      return response.isRedirect;
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
          'http://redditech.me/backend/users/change-account-settings');

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
      if (response.isRedirect) {
        print('successfull');
      } else {
        print('failed');
      }

      return response.isRedirect;
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
          'http://redditech.me/backend/users/change-account-settings');

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

  void connectToGoogle(String username) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .accountSettings
          ?.connectedGoogle = true;
    } else {
      // toggle connect to google in db
    }
  }

  void disconnectFromGoogle(String username) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .accountSettings
          ?.connectedGoogle = false;
    } else {
      // toggle disconnect from google in db
    }
  }

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
        List<dynamic> body = jsonDecode(response.body)['comments'];
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
}
