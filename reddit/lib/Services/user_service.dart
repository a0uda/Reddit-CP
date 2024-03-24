import 'dart:developer';

class SocialLlinkItem {
  final String? id;
  final String username;
  final String displayText;
  final String type;
  final String customUrl;

  SocialLlinkItem({
    this.id,
    required this.username,
    required this.displayText,
    required this.type,
    required this.customUrl,
  });
}

class FollowersFollowingItem {
  final String? id;
  final String? createdAt;
  final String username;
  final String? email;
  final bool? verifiedEmailFlag;
  final FollowersProfileSettings? profileSettings;
  final String? country;
  final String? gender;

  FollowersFollowingItem({
    this.id,
    this.createdAt,
    required this.username,
    this.email,
    this.verifiedEmailFlag,
    this.profileSettings,
    this.country,
    this.gender,
  });
}

class FollowersProfileSettings {
  final String? display_name;
  final String? about;
  final String? profile_picture;
  final String? banner_picture;

  FollowersProfileSettings({
    this.display_name,
    this.about,
    this.profile_picture,
    this.banner_picture,
  });
}

class UserAbout {
  final String? id;
  final String? createdAt;
  final String username;
  final String? email;
  final bool? verifiedEmailFlag;
  final String? gmail;
  final String? facebook_email;
  final String? display_name;
  final String? about;
  final List<SocialLlinkItem>? social_links;
  final String? profile_picture;
  final String? banner_picture;
  final String? country;
  final String? gender;
  final bool? connected_google;

  UserAbout({
    this.id,
    this.createdAt,
    required this.username,
    this.email,
    this.verifiedEmailFlag,
    this.gmail,
    this.facebook_email,
    this.display_name,
    this.about,
    this.social_links,
    this.profile_picture,
    this.banner_picture,
    this.country,
    this.gender,
    this.connected_google,
  });
}

class UserItem {
  final UserAbout userAbout;
  final String? password;
  final List<FollowersFollowingItem>? followers;
  final List<FollowersFollowingItem>? following;

  UserItem({
    required this.userAbout,
    this.password,
    this.followers,
    this.following,
  });
}

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

  UserAbout? getUserAbout(String username) {
    if (testing) {
      return users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout;
    } else {
      //to be fetched from database
    }
  }

  void addSocialLink(
      String username, String displayText, String type, String customUrl) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .social_links!
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
          .social_links!
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

    if (availablePassword(password) == 400) {
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

  int availablePassword(String password) {
    return usedPasswords.contains(password) ? 400 : 200;
  }
}

final List<UserItem> users = [
  UserItem(
    userAbout: UserAbout(
      id: '0',
      createdAt: '5 March 2024',
      username: 'Purple-7544',
      email: 'rawan7544@gmail.com',
      verifiedEmailFlag: true,
      display_name: 'Rawan Adel',
      about: 'I am a software engineer',
      profile_picture: 'images/pp.jpg',
      social_links: [
        SocialLlinkItem(
          id: '0',
          username: 'rawan_adel165',
          displayText: 'rawan_adel165',
          type: 'instagram',
          customUrl:
              'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        ),
        SocialLlinkItem(
          id: '1',
          username: 'rawan adel',
          displayText: 'rawan adel',
          type: 'facebook',
          customUrl:
              'https://www.facebook.com/rawan.adel.359778?mibextid=LQQJ4d',
        ),
        SocialLlinkItem(
          id: '2',
          username: 'rawan7544',
          displayText: 'rawan7544',
          type: 'twitter',
          customUrl:
              'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        ),
      ],
    ),
    password: 'rawan1234',
    followers: [
      FollowersFollowingItem(
        id: '0',
        createdAt: '5 March 2024',
        username: 'johndoe',
        email: 'rawan7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          display_name: 'John',
          about: 'I am a software engineer',
          profile_picture: 'images/pp.jpg',
        ),
        country: 'Egypt',
        gender: 'Male',
      ),
      FollowersFollowingItem(
        id: '1',
        createdAt: '5 March 2024',
        username: 'jane123',
        email: 'rawan7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          about: 'I am a software engineer',
        ),
      ),
      FollowersFollowingItem(
        id: '2',
        createdAt: '5 March 2024',
        username: 'Mark_45',
        email: 'rawan7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          display_name: 'Mark',
          about: 'I am a software engineer',
          profile_picture: 'images/pp.jpg',
        ),
      ),
    ],
    following: [
      FollowersFollowingItem(
        id: '0',
        createdAt: '5 March 2024',
        username: 'johndoe',
        email: 'rawan7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          display_name: 'John',
          about: 'I am a software engineer',
          profile_picture: 'images/pp.jpg',
        ),
        country: 'Egypt',
        gender: 'Male',
      ),
      FollowersFollowingItem(
        id: '1',
        createdAt: '5 March 2024',
        username: 'jane123',
        email: 'rawan7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          about: 'I am a software engineer',
          profile_picture: 'images/pp.jpg',
        ),
      ),
    ],
  ),
  UserItem(
    userAbout: UserAbout(
      id: '1',
      createdAt: '5 March 2024',
      username: 'johndoe',
      email: 'rawan7544@gmail.com',
      verifiedEmailFlag: true,
      display_name: 'John',
      about: 'I am a software engineer',
      profile_picture: 'images/pp.jpg',
      social_links: [
        SocialLlinkItem(
          id: '0',
          username: 'john_doe',
          displayText: 'john_doe',
          type: 'instagram',
          customUrl:
              'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        ),
        SocialLlinkItem(
          id: '1',
          username: 'john_doe',
          displayText: 'john_doe',
          type: 'facebook',
          customUrl:
              'https://www.facebook.com/rawan.adel.359778?mibextid=LQQJ4d',
        ),
      ],
    ),
    password: 'john1234',
    followers: [
      FollowersFollowingItem(
        id: '0',
        createdAt: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawan7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          display_name: 'Rawan Adel',
          about: 'I am a software engineer',
          profile_picture: 'images/pp.jpg',
        ),
      ),
    ],
    following: [
      FollowersFollowingItem(
        id: '0',
        createdAt: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawan7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          display_name: 'Rawan Adel',
          about: 'I am a software engineer',
          profile_picture: 'images/pp.jpg',
        ),
      ),
    ],
  ),
  UserItem(
    userAbout: UserAbout(
      id: '2',
      createdAt: '5 March 2024',
      username: 'jane123',
      email: 'rawan7544@gmail.com',
      verifiedEmailFlag: true,
      display_name: 'Jane',
      about: 'I am a software engineer',
      social_links: [
        SocialLlinkItem(
          id: '0',
          username: 'jane_123',
          displayText: 'jane_123',
          type: 'instagram',
          customUrl:
              'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        ),
      ],
    ),
    password: 'jane1234',
    followers: [
      FollowersFollowingItem(
        id: '0',
        createdAt: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawn7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          display_name: 'Rawan Adel',
          about: 'I am a software engineer',
          profile_picture: 'images/pp.jpg',
        ),
      ),
    ],
    following: [
      FollowersFollowingItem(
        id: '0',
        createdAt: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawn7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          display_name: 'Rawan Adel',
          about: 'I am a software engineer',
          profile_picture: 'images/pp.jpg',
        ),
      ),
    ],
  ),
  UserItem(
    userAbout: UserAbout(
      id: '3',
      createdAt: '5 March 2024',
      username: 'Mark_45',
      email: 'rawan7544@gmail.com',
      verifiedEmailFlag: true,
      display_name: 'Mark',
      about: 'I am a software engineer',
      profile_picture: 'images/Greddit.png',
      social_links: [
        SocialLlinkItem(
          id: '0',
          username: 'mark_45',
          displayText: 'mark_45',
          type: 'instagram',
          customUrl:
              'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        ),
        SocialLlinkItem(
          id: '1',
          username: 'mark_45',
          displayText: 'mark_45',
          type: 'facebook',
          customUrl:
              'https://www.facebook.com/rawan.adel.359778?mibextid=LQQJ4d',
        ),
      ],
    ),
    password: 'mark1234',
    followers: [],
    following: [
      FollowersFollowingItem(
        id: '0',
        createdAt: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawan7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          display_name: 'Rawan Adel',
          about: 'I am a software engineer',
          profile_picture: 'images/pp.jpg',
        ),
      ),
    ],
  ),
];
