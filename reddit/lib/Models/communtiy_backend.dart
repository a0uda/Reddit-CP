
class CommunityBackend{
  String id;
  String name;
  String profilePictureURL;
  bool favoriteFlag;
  int membersCount;
  bool? joined;

  CommunityBackend({
    required this.id,
    required this.favoriteFlag,
    this.joined,
    required this.name,
    required this.membersCount,
    required this.profilePictureURL,
  });

  static fromJson(community) {
    return CommunityBackend(
      id: community['id'],
      name: community['name'],
      profilePictureURL: community['profile_picture'],
      favoriteFlag: community['favorite_flag'],
      membersCount: community['members_count'],
      joined: community["joined"],
    );
  }
}