import 'package:flutter_test/flutter_test.dart';
import 'package:reddit/services/community_service.dart';
import 'package:reddit/test_files/test_communities.dart';

void main() {
  group('CommunityService Tests', () {
    final CommunityService communityService = CommunityService();

    test('test_getCommunityData_with_valid_name', () {
      var expectedCommunity = communities.firstWhere((community) => community.communityName == 'Hyatt___Tillman');
      var result = communityService.getCommunityData('Hyatt___Tillman');
      expect(result, equals(expectedCommunity));
    });

    test('test_getCommunityData_with_invalid_name', () {
      var result = communityService.getCommunityData('NonExistentCommunity');
      expect(result, isNull);
    });

    test('test_getCommunityNames_returns_all_names', () {
      var expectedNames = communities.map((community) => community.communityName).toList();
      var result = communityService.getCommunityNames();
      expect(result, equals(expectedNames));
    });
  });
}