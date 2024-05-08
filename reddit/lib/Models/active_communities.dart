class ActiveCommunities {
  String id;
  String name;
  String description;
  String title;
  String profilePicture;
  String bannerPicture;
  int membersCount;

  ActiveCommunities({
    required this.id,
    required this.name,
    required this.description,
    required this.title,
    required this.profilePicture,
    required this.bannerPicture,
    required this.membersCount,
  });

  factory ActiveCommunities.fromJson(Map<String, dynamic> json) {
    return ActiveCommunities(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      title: json['title'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      bannerPicture: json['banner_picture'] ?? '',
      membersCount: json['members_count'] ?? '',
    );
  }
}

class ActiveCommunitiesResult {
  List<ActiveCommunities> activeCommunities;
  bool showActiveCommunities;

  ActiveCommunitiesResult({
    required this.activeCommunities,
    required this.showActiveCommunities,
  });

  static ActiveCommunitiesResult fromJson(json) {
    ActiveCommunitiesResult activeCommunitiesResult = ActiveCommunitiesResult(
      activeCommunities: List<ActiveCommunities>.from(json['active_communities']
          .map((community) => ActiveCommunities.fromJson(community))),
      showActiveCommunities: json['showActiveCommunities'] ?? false,
    );
    return activeCommunitiesResult;
  }
}
