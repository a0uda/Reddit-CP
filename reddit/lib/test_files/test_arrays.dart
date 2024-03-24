import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var user_data = {
  'username': 'Purple-7544',
  'followers': '0',
  'karma': '1',
  'date': '5 March 2024',
  'socialLinks': [
    {
      'icon': FontAwesomeIcons.instagram,
      'link':
          'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
      'iconColor': '#E1306C',
      'placeholder': 'rawan_adel165'
    },
    {
      'icon': FontAwesomeIcons.facebook,
      'link': 'https://www.facebook.com/rawan.adel.359778?mibextid=LQQJ4d',
      'iconColor': '#3b5998',
      'placeholder': 'rawan adel'
    },
    {
      'icon': FontAwesomeIcons.twitter,
      'link':
          'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
      'iconColor': '#1DA1F2',
      'placeholder': 'rawan7544'
    },
  ],
  'followersList': [
    {'username': 'johndoe', 'Karma': '1', 'Following': 'yes'},
    {'username': 'jane123', 'Karma': '3', 'Following': 'yes'},
    {'username': 'Mark_45', 'Karma': '5', 'Following': 'no'},
    {'username': 'rawan_7544', 'Karma': '1', 'Following': 'no'},
    {'username': 'mary', 'Karma': '2', 'Following': 'yes'}
  ],
};

var otherUsersData = [
  {
    'username': 'johndoe',
    'karma': '1',
    'date': '5 March 2024',
    'following': 'no',
    'socialLinks': [
      {
        'icon': FontAwesomeIcons.instagram,
        'link':
            'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        'iconColor': '#E1306C',
        'placeholder': 'rawan_adel165'
      },
      {
        'icon': FontAwesomeIcons.facebook,
        'link': 'https://www.facebook.com/rawan.adel.359778?mibextid=LQQJ4d',
        'iconColor': '#3b5998',
        'placeholder': 'rawan adel'
      },
      {
        'icon': FontAwesomeIcons.twitter,
        'link':
            'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        'iconColor': '#1DA1F2',
        'placeholder': 'rawan7544'
      },
    ],
  },
  {
    'username': 'jane123',
    'karma': '3',
    'date': '5 March 2024',
    'following': 'yes',
    'socialLinks': [
      {
        'icon': FontAwesomeIcons.instagram,
        'link':
            'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        'iconColor': '#E1306C',
        'placeholder': 'rawan_adel165'
      },
      {
        'icon': FontAwesomeIcons.facebook,
        'link': 'https://www.facebook.com/rawan.adel.359778?mibextid=LQQJ4d',
        'iconColor': '#3b5998',
        'placeholder': 'rawan adel'
      },
      {
        'icon': FontAwesomeIcons.twitter,
        'link':
            'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        'iconColor': '#1DA1F2',
        'placeholder': 'rawan7544'
      },
    ],
  },
  {
    'username': 'Mark_45',
    'karma': '5',
    'date': '5 March 2024',
    'following': 'no',
    'socialLinks': [
      {
        'icon': FontAwesomeIcons.instagram,
        'link':
            'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        'iconColor': '#E1306C',
        'placeholder': 'rawan_adel165'
      },
      {
        'icon': FontAwesomeIcons.facebook,
        'link': 'https://www.facebook.com/rawan.adel.359778?mibextid=LQQJ4d',
        'iconColor': '#3b5998',
        'placeholder': 'rawan adel'
      },
    ],
  },
  {
    'username': 'rawan_7544',
    'karma': '1',
    'date': '5 March 2024',
    'following': 'yes',
    'socialLinks': [
      {
        'icon': FontAwesomeIcons.instagram,
        'link':
            'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        'iconColor': '#E1306C',
        'placeholder': 'rawan_adel165'
      },
    ],
  },
  {
    'username': 'mary',
    'karma': '2',
    'date': '5 March 2024',
    'following': 'no',
    'socialLinks': [
      {
        'icon': FontAwesomeIcons.twitter,
        'link':
            'https://www.instagram.com/rawan_adel165/?igsh=Z3lxMmhpcW82NmR3&utm_source=qr',
        'iconColor': '#1DA1F2',
        'placeholder': 'rawan7544'
      },
      {
        'icon': FontAwesomeIcons.linkedin,
        'link':
            'https://www.linkedin.com/in/rawan-adel-7b3b3b1b3/?originalSubdomain=eg',
        'iconColor': '#0e76a8',
        'placeholder': 'rawan adel'
      },
    ],
  },
];

const socialMediaButtons = [
  {'name': 'Reddit', 'icon': FontAwesomeIcons.reddit, 'color': '#FF3300'},
  {'name': 'Facebook', 'icon': FontAwesomeIcons.facebook, 'color': '#3b5998'},
  {'name': 'Twitter', 'icon': FontAwesomeIcons.twitter, 'color': '#1DA1F2'},
  {'name': 'Instagram', 'icon': FontAwesomeIcons.instagram, 'color': '#E1306C'},
  {'name': 'LinkedIn', 'icon': FontAwesomeIcons.linkedin, 'color': '#0A66C2'},
  {'name': 'YouTube', 'icon': FontAwesomeIcons.youtube, 'color': '#FF0000'},
  {'name': 'Pinterest', 'icon': FontAwesomeIcons.pinterest, 'color': '#BD081C'},
  {'name': 'Snapchat', 'icon': FontAwesomeIcons.snapchat, 'color': '#FFFC00'},
  {'name': 'TikTok', 'icon': FontAwesomeIcons.tiktok, 'color': '#000000'},
  {'name': 'WhatsApp', 'icon': FontAwesomeIcons.whatsapp, 'color': '#25D366'},
  {'name': 'Telegram', 'icon': FontAwesomeIcons.telegram, 'color': '#0088cc'},
  {'name': 'Skype', 'icon': FontAwesomeIcons.skype, 'color': '#00AFF0'},
  {'name': 'Renren', 'icon': FontAwesomeIcons.renren, 'color': '#217DC6'},
  {'name': 'Flickr', 'icon': FontAwesomeIcons.flickr, 'color': '#0063DC'},
  {'name': 'Twitch', 'icon': FontAwesomeIcons.twitch, 'color': '#6441A5'},
  {'name': 'GitHub', 'icon': FontAwesomeIcons.github, 'color': '#181717'},
  {
    'name': 'Stack Overflow',
    'icon': FontAwesomeIcons.stackOverflow,
    'color': '#F48024'
  },
  {'name': 'PayPal', 'icon': FontAwesomeIcons.paypal, 'color': '#00457C'},
  {'name': 'Etsy', 'icon': FontAwesomeIcons.etsy, 'color': '#F2581E'},
  {'name': 'Shopify', 'icon': FontAwesomeIcons.shopify, 'color': '#96BF48'},
];
