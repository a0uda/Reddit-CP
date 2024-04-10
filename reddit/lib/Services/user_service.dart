import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/social_link_item.dart';
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
      // add social link to database
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
  ProfileSettings? getProfileSettings(String username) {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .profileSettings;
    } else {
      // get profile settings from database
    }
    return null;
  }

  void updateProfileSettings(
      String username,
      String displayName,
      String about,
      bool? nsfwFlag,
      bool? allowFollowers,
      bool contentVisibility,
      bool activeCommunity) {
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
      // update profile settings in database
    }
  }

  void addBannerPicture(String username, String bannerPicture) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .bannerPicture = bannerPicture;
    } else {
      // add banner picture to database
    }
  }

  void addProfilePicture(String username, String profilePicture) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .profilePicture = profilePicture;
    } else {
      // add profile picture to database
    }
  }

  void removeBannerPicture(String username) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .bannerPicture = null;
    } else {
      // remove banner picture from database
    }
  }

  void removeProfilePicture(String username) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .profilePicture = null;
    } else {
      // remove profile picture from database
    }
  }

  void deleteSocialLink(String username, String id) {
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

  void editSocialLink(
      String username, String id, String displayText, String customUrl) {
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
      // edit social link in database
    }
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
  List<BlockedUsersItem> getBlockedUsers(String username) {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers;
    } else {
      // get safety settings from database
    }
    return [];
  }

  void blockUser(String username, String blockedUsername) {
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
      // block user in database
    }
  }

  void unblockUser(String username, String blockedUsername) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .safetySettings!
          .blockedUsers
          .removeWhere((element) => element.username == blockedUsername);
    } else {
      // unblock user in database
    }
  }
}
