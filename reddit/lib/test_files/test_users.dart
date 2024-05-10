import 'package:reddit/Models/account_settings_item.dart';
import 'package:reddit/Models/active_communities.dart';
import 'package:reddit/Models/blocked_users_item.dart';
import 'package:reddit/Models/profile_settings.dart';
import 'package:reddit/Models/safety_settings_item.dart';
import 'package:reddit/Models/social_link_item.dart';
import 'package:reddit/test_files/test_comments.dart';
import 'package:reddit/test_files/test_messages.dart';
import '../Models/user_item.dart';
import '../Models/user_about.dart';
import '../Models/followers_following_item.dart';

final List<UserItem> users = [
  UserItem(
    savedCommentsIds: [],
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
          customUrl: "https://redditech.me/backend/users/signup-google",
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
        gender: 'Male',
      ),
      FollowersFollowingItem(
        id: '1',
        createdAt: '5 March 2024',
        username: 'jane123',
        email: 'rawan7544@gmail.com',
      ),
      FollowersFollowingItem(
        id: '2',
        createdAt: '5 March 2024',
        username: 'Mark_45',
        email: 'rawan7544@gmail.com',
      ),
    ],
    following: [
      FollowersFollowingItem(
        id: '0',
        createdAt: '5 March 2024',
        username: 'johndoe',
        email: 'rawan7544@gmail.com',
        gender: 'Male',
      ),
      FollowersFollowingItem(
        id: '1',
        createdAt: '5 March 2024',
        username: 'jane123',
        email: 'rawan7544@gmail.com',
      ),
    ],
    comments: comments,
    profileSettings: ProfileSettings(
      displayName: 'Rawan Adel',
      about: 'I am a software engineer',
      contentVisibility: false,
      activeCommunity: true,
    ),
    safetySettings: SafetyAndPrivacySettings(
      blockedUsers: [
        // BlockedUsersItem(
        //   username: 'johndoe',
        //   profilePicture: 'images/pp.jpg',
        //   blockedDate: '5 March 2024',
        // ),
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
    usermessages: List.from(userMessages[0]),
  ),
  UserItem(
    savedCommentsIds: [],
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
        about: 'I am john',
      ),
    ],
    following: [
      FollowersFollowingItem(
        id: '0',
        createdAt: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawan7544@gmail.com',
      ),
    ],
    comments: [],
    safetySettings: SafetyAndPrivacySettings(
      blockedUsers: [
        // BlockedUsersItem(
        //   username: 'jane123',
        //   profilePicture: 'images/pp.jpg',
        //   blockedDate: '5 March 2024',
        // ),
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
    usermessages: List.from(userMessages[1]),
  ),
  UserItem(
    savedCommentsIds: ['comment1'],
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
      ),
    ],
    following: [
      FollowersFollowingItem(
        id: '0',
        createdAt: '5 March 2024',
        username: 'Purple-7544',
        email: 'rawn7544@gmail.com',
      ),
    ],
    comments: comments,
    profileSettings: ProfileSettings(
      displayName: 'Jane',
      about: 'I am a software engineer',
      contentVisibility: true,
      activeCommunity: true,
    ),
    safetySettings: SafetyAndPrivacySettings(
      blockedUsers: [
        // BlockedUsersItem(
        //   username: 'johndoe',
        //   profilePicture: 'images/pp.jpg',
        //   blockedDate: '5 March 2024',
        // ),
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
    usermessages: List.from(userMessages[2]),
  ),
  UserItem(
    savedCommentsIds: [],
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
        displayName: 'Rawan Adel',
        bannerPicture: 'images/Greddit.png',
        profilePicture: 'images/pp.jpg',
        gender: 'Female',
      ),
    ],
    // comments: comments3,
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
    usermessages: List.from(userMessages[3]),
  ),
];

List<ActiveCommunities> communities = [
  ActiveCommunities(
    id: '0',
    name: 'Flutter',
    description:
        'Flutter is Google’s UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.',
    title: 'Flutter',
    profilePicture: 'images/Greddit.png',
    bannerPicture: 'images/Greddit.png',
    membersCount: 5000,
  ),
  ActiveCommunities(
    id: '1',
    name: 'Dart',
    description:
        'Dart is a client-optimized language for fast apps on any platform',
    title: 'Dart',
    profilePicture: 'images/Greddit.png',
    bannerPicture: 'images/Greddit.png',
    membersCount: 8000,
  ),
  ActiveCommunities(
    id: '2',
    name: 'Firebase',
    description:
        'Firebase is a platform developed by Google for creating mobile and web applications.',
    title: 'Firebase',
    profilePicture: 'images/Greddit.png',
    bannerPicture: 'images/Greddit.png',
    membersCount: 10000,
  ),
  ActiveCommunities(
    id: '3',
    name: 'Android',
    description:
        'Android is a mobile operating system based on a modified version of the Linux kernel and other open source software.',
    title: 'Android',
    profilePicture: 'images/Greddit.png',
    bannerPicture: 'images/Greddit.png',
    membersCount: 12000,
  ),
];
