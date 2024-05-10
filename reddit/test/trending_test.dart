import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit/widgets/Search/search_trending.dart';
import 'package:reddit/widgets/trending_card.dart';

void main() {
  group('TrendingPost Widget Tests', () {
    testWidgets(
        'The widget should correctly initialize and display with the provided `title` and `imageUrl`.',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TrendingPost(
            title: 'Test Title', imageUrl: 'http://example.com/image.jpg'),
      ));
      debugDumpApp();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets(
        'The widget should handle the tap event and navigate to the `SearchTrending` page with the correct `title`.',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: TrendingPost(
            title: 'Test Title', imageUrl: 'http://example.com/image.jpg'),
      ));

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(SearchTrending), findsOneWidget);
      expect(find.text('Test Title'), findsWidgets);
    });
  });
}
