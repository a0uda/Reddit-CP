import '../Models/user_item.dart';
import '../Models/user_about.dart';
import '../Models/followers_following_item.dart'; 

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
    if (testing)
      return users
          .firstWhere((element) => element.userAbout.username == Username)
          .userAbout;
    else {
      //to be fetched from database
    }
  }

  void addSocialLink(
      String username, String display_text, String type, String custom_url) {
    if (testing) {
      users
          .firstWhere((element) => element.userAbout.username == username)
          .userAbout
          .social_links!
          .add(SocialLlinkItem(
            username: display_text,
            display_text: display_text,
            type: type,
            custom_url: custom_url,
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
      verified_email_flag: false,
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
      created_at: '5 March 2024',
      username: 'Purple-7544',
      email: 'rawan7544@gmail.com',
      verified_email_flag: true,
      display_name: 'Rawan Adel',
      about: 'I am a software engineer',
      profile_picture: 'images/pp.jpg',
      social_links: [
        SocialLlinkItem(
          id: '0',
          username: 'rawan_adel165',
          display_text: 'rawan_adel165',
          type: 'instagram',
          custom_url:
              'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        ),
        SocialLlinkItem(
          id: '1',
          username: 'rawan adel',
          display_text: 'rawan adel',
          type: 'facebook',
          custom_url:
              'https://www.facebook.com/rawan.adel.359778?mibextid=LQQJ4d',
        ),
        SocialLlinkItem(
          id: '2',
          username: 'rawan7544',
          display_text: 'rawan7544',
          type: 'twitter',
          custom_url:
              'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        ),
      ],
    ),
    password: 'rawan1234',
    followers: [
      FollowersFollowingItem(
        id: '0',
        created_at: '5 March 2024',
        username: 'johndoe',
        email: 'rawan7544@gmail.com',
        verified_email_flag: true,
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
        created_at: '5 March 2024',
        username: 'jane123',
        email: 'rawan7544@gmail.com',
        verified_email_flag: true,
        profileSettings: FollowersProfileSettings(
          about: 'I am a software engineer',
        ),
      ),
      FollowersFollowingItem(
        id: '2',
        created_at: '5 March 2024',
        username: 'Mark_45',
        email: 'rawan7544@gmail.com',
        verified_email_flag: true,
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
        created_at: '5 March 2024',
        username: 'johndoe',
        email: 'rawan7544@gmail.com',
        verified_email_flag: true,
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
        created_at: '5 March 2024',
        username: 'jane123',
        email: 'rawan7544@gmail.com',
        verified_email_flag: true,
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
      created_at: '5 March 2024',
      username: 'johndoe',
      email: 'rawan7544@gmail.com',
      verified_email_flag: true,
      display_name: 'John',
      about: '',
      profile_picture: 'images/pp.jpg',
      social_links: [
        SocialLlinkItem(
          id: '0',
          username: 'john_doe',
          display_text: 'john_doe',
          type: 'instagram',
          custom_url:
              'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        ),
        SocialLlinkItem(
          id: '1',
          username: 'john_doe',
          display_text: 'john_doe',
          type: 'facebook',
          custom_url:
              'https://www.facebook.com/rawan.adel.359778?mibextid=LQQJ4d',
        ),
      ],
    ),
    password: 'john1234',
    followers: [
      FollowersFollowingItem(
        id: '0',
        created_at: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawan7544@gmail.com',
        verified_email_flag: true,
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
        created_at: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawan7544@gmail.com',
        verified_email_flag: true,
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
      created_at: '5 March 2024',
      username: 'jane123',
      email: 'rawan7544@gmail.com',
      verified_email_flag: true,
      display_name: 'Jane',
      about: 'I am a software engineer',
      social_links: [
        SocialLlinkItem(
          id: '0',
          username: 'jane_123',
          display_text: 'jane_123',
          type: 'instagram',
          custom_url:
              'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        ),
      ],
    ),
    password: 'jane1234',
    followers: [
      FollowersFollowingItem(
        id: '0',
        created_at: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawn7544@gmail.com',
        verified_email_flag: true,
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
        created_at: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawn7544@gmail.com',
        verified_email_flag: true,
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
      created_at: '5 March 2024',
      username: 'Mark_45',
      email: 'rawan7544@gmail.com',
      verified_email_flag: true,
      display_name: 'Mark',
      about: 'I am a software engineer',
      profile_picture: 'images/Greddit.png',
      social_links: [
        SocialLlinkItem(
          id: '0',
          username: 'mark_45',
          display_text: 'mark_45',
          type: 'instagram',
          custom_url:
              'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        ),
        SocialLlinkItem(
          id: '1',
          username: 'mark_45',
          display_text: 'mark_45',
          type: 'facebook',
          custom_url:
              'https://www.facebook.com/rawan.adel.359778?mibextid=LQQJ4d',
        ),
      ],
    ),
    password: 'mark1234',
    followers: [],
    following: [
      FollowersFollowingItem(
        id: '0',
        created_at: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawan7544@gmail.com',
        verified_email_flag: true,
        profileSettings: FollowersProfileSettings(
          display_name: 'Rawan Adel',
          about: 'I am a software engineer',
          profile_picture: 'images/pp.jpg',
        ),
      ),
    ],
  ),
];
