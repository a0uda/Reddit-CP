import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/safety_settings_item.dart';
import 'package:reddit/test_files/test_safety_settings.dart';

import '../Models/user_item.dart';
import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';
import '../Models/comments.dart';
import '../test_files/test_users.dart';

bool testing = true;

class UserService {
  final List<String> usedPasswords = [
    'rawan1234',
    'john1234',
    'jane1234',
    'mark1234',
  ];

  void addUser() {
    if (testing) {
      //to be implemented
    } else {
      // add post to database
    }
  }

  UserAbout? getUserAbout(String Username) {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == Username)
          .userAbout;
    } else {
      //to be fetched from database
    }
    return null;
  }

  void addSocialLink(
      String username, String displayText, String type, String customUrl) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .socialLinks!
          .add(SocialLlinkItem(
            username: displayText,
            displayText: displayText,
            type: type,
            customUrl: customUrl,
          ));
    } else {
      // add social link to database
    }
  }

  void deleteSocialLinkService(String username, String id) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .socialLinks!
          .removeWhere((element) => element.id == id);
    } else {
      // delete social link from database
    }
  }

  void followUser(String username, String follower) {
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
      // follow user in database
    }
  }

  void unfollowUser(String username, String follower) {
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
      // unfollow user in database
    }
  }

  int? getFollowersCount(String username) {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .followers!
          .length;
    } else {
      // get followers count from database
    }
    return null;
  }

  List<FollowersFollowingItem>? getFollowers(String username) {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .followers!;
    } else {
      // get followers from database
    }
    return null;
  }

  int? getFollowingCount(String username) {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .following!
          .length;
    } else {
      // get following count from database
    }
    return null;
  }

  List<FollowersFollowingItem>? getFollowing(String username) {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .following!;
    } else {
      // get following from database
    }
    return null;
  }

  List<Comments>? getcomments(String username) {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .comments!;
    } else {
      // get comments from database
    }
    return null;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  int userSignup(
      String username, String password, String email, String gender) {
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
    usedPasswords.add(password);

    return 200;
  }

  int userLogin(String username, String password) {
    if (users.any((user) =>
        user.userAbout.username == username && user.password == password)) {
      return 200;
    } else {
      return 400;
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
  List<BlockedUsersItem> getBlockedUsers() {
    if (testing) {
      return safetySettings.blockedUsers;
    } else {
      // get safety settings from database
    }
    return safetySettings.blockedUsers;
  }

  void blockUser(String username) {
    if (testing) {
      safetySettings.blockedUsers.add(BlockedUsersItem(
        id: safetySettings.blockedUsers.length.toString(),
        username: username,
        profilePicture: 'images/pp.jpg',
        blockedDate: '5 March 2024',
      ));
    } else {
      // block user in database
    }
  }

  void unblockUser(String username) {
    if (testing) {
      safetySettings.blockedUsers
          .removeWhere((element) => element.username == username);
    } else {
      // unblock user in database
    }
  }
}
