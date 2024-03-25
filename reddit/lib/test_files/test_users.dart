import '../Models/comments.dart';
import '../Models/user_item.dart';
import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';

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
    comments: comments1,
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
    comments: [],
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
    comments: comments2,
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
    comments: comments3,
  ),
];
