import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/safety_settings_item.dart';
import 'package:reddit/Models/social_link_item.dart';

import '../Models/comments.dart';
import '../Models/user_item.dart';
import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';
import 'test_communities.dart';

final List<UserItem> users = [
  UserItem(
    userAbout: UserAbout(
      id: '0',
      createdAt: '5 March 2024',
      username: 'Purple-7544',
      email: 'rawan7544@gmail.com',
      verifiedEmailFlag: true,
      gmail: null,
      facebookEmail: null,
      displayName: 'Rawan Adel',
      about: 'I am a software engineer',
      profilePicture: 'images/pp.jpg',
      bannerPicture: null,
      country: 'Egypt',
      gender: 'Female',
      socialLinks: [
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
          username: 'rawan',
          displayText: 'rawan',
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
          displayName: 'John',
          about: 'I am a software engineer',
          profilePicture: 'images/pp.jpg',
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
            bannerPicture: 'images/Greddit.png'),
      ),
      FollowersFollowingItem(
        id: '2',
        createdAt: '5 March 2024',
        username: 'Mark_45',
        email: 'rawan7544@gmail.com',
        verifiedEmailFlag: true,
        profileSettings: FollowersProfileSettings(
          displayName: 'Mark',
          about: 'I am a software engineer',
          profilePicture: 'images/pp.jpg',
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
          displayName: 'John',
          about: 'I am a software engineer',
          profilePicture: 'images/pp.jpg',
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
          profilePicture: 'images/pp.jpg',
        ),
      ),
    ],
    comments: comments1,
    profileSettings: ProfileSettings(
      displayName: 'Rawan Adel',
      about: 'I am a software engineer',
      contentVisibility: false,
      activeCommunity: true,
    ),
    safetySettings: SafetyAndPrivacySettings(
      blockedUsers: [
        BlockedUsersItem(
          username: 'johndoe',
          profilePicture: 'images/pp.jpg',
          blockedDate: '5 March 2024',
        ),
        BlockedUsersItem(
          username: 'jane123',
          profilePicture: 'images/pp.jpg',
          blockedDate: '5 March 2024',
        ),
      ],
      mutedCommunities: [
        MutedCommunity(
          id: '0',
          communityName: 'Flutter',
          profilePicture: 'images/Greddit.png',
          mutedDate: '5 March 2024',
        ),
        MutedCommunity(
          id: '1',
          communityName: 'Dart',
          profilePicture: 'images/Greddit.png',
          mutedDate: '5 March 2024',
        ),
      ],
    ),
    accountSettings: AccountSettings(
      email: 'rawan7544@gmail.com',
      verifiedEmailFlag: false,
      country: 'Egypt',
      gender: 'Female',
      gmail: 'rawan7544@gmail.com',
      connectedGoogle: true,
    ),
    activecommunities: [
      communities[0],
      communities[1],
      communities[2],
    ],
  ),
  UserItem(
    userAbout: UserAbout(
      id: '1',
      createdAt: '5 March 2024',
      username: 'johndoe',
      email: 'rawan7544@gmail.com',
      verifiedEmailFlag: true,
      displayName: 'John',
      gender: 'Male',
      about: '',
      profilePicture: 'images/pp.jpg',
      socialLinks: [
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
          displayName: 'Rawan Adel',
          about: 'I am a software engineer',
          profilePicture: 'images/pp.jpg',
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
          displayName: 'Rawan Adel',
          about: 'I am a software engineer',
          profilePicture: 'images/pp.jpg',
        ),
      ),
    ],
    comments: [],
    safetySettings: SafetyAndPrivacySettings(
      blockedUsers: [
        BlockedUsersItem(
          username: 'jane123',
          profilePicture: 'images/pp.jpg',
          blockedDate: '5 March 2024',
        ),
      ],
      mutedCommunities: [
        MutedCommunity(
          id: '0',
          communityName: 'Flutter',
          profilePicture: 'images/Greddit.png',
          mutedDate: '5 March 2024',
        ),
      ],
    ),
    profileSettings: ProfileSettings(
      displayName: 'John',
      about: 'I am a software engineer',
      contentVisibility: true,
      activeCommunity: true,
    ),
    accountSettings: AccountSettings(
      email: 'rawan7544@gmail.com',
      verifiedEmailFlag: true,
      country: 'Egypt',
      gender: 'Male',
      gmail: 'rawan7544@gmail.com',
      connectedGoogle: true,
    ),
    activecommunities: [
      communities[0],
      communities[1],
      communities[2],
    ],
  ),
  UserItem(
    userAbout: UserAbout(
      id: '2',
      createdAt: '5 March 2024',
      username: 'jane123',
      gender: 'Female',
      email: 'rawan7544@gmail.com',
      profilePicture: null,
      bannerPicture: 'images/Greddit.png',
      verifiedEmailFlag: true,
      displayName: 'Jane',
      about: 'I am a software engineer',
      socialLinks: [
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
          displayName: 'Rawan Adel',
          about: 'I am a software engineer',
          profilePicture: 'images/pp.jpg',
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
          displayName: 'Rawan Adel',
          about: 'I am a software engineer',
          profilePicture: 'images/pp.jpg',
        ),
      ),
    ],
    comments: comments2,
    profileSettings: ProfileSettings(
      displayName: 'Jane',
      about: 'I am a software engineer',
      contentVisibility: true,
      activeCommunity: true,
    ),
    safetySettings: SafetyAndPrivacySettings(
      blockedUsers: [
        BlockedUsersItem(
          username: 'johndoe',
          profilePicture: 'images/pp.jpg',
          blockedDate: '5 March 2024',
        ),
      ],
      mutedCommunities: [
        MutedCommunity(
          id: '0',
          communityName: 'Flutter',
          profilePicture: 'images/Greddit.png',
          mutedDate: '5 March 2024',
        ),
      ],
    ),
    activecommunities: [
      communities[2],
      communities[3],
    ],
  ),
  UserItem(
    userAbout: UserAbout(
      id: '3',
      createdAt: '5 March 2024',
      username: 'Mark_45',
      gender: 'Male',
      email: 'rawan7544@gmail.com',
      verifiedEmailFlag: true,
      displayName: 'Mark',
      about: 'I am a software engineer',
      profilePicture: 'images/Greddit.png',
      socialLinks: [
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
          displayName: 'Rawan Adel',
          about: 'I am a software engineer',
          profilePicture: 'images/pp.jpg',
        ),
      ),
    ],
    comments: comments3,
    profileSettings: ProfileSettings(
      displayName: 'Mark',
      about: 'I am a software engineer',
      contentVisibility: true,
      activeCommunity: true,
    ),
    activecommunities: [
      communities[0],
      communities[1],
      communities[2],
      communities[3],
    ],
  ),
];
