import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:better_polls/better_polls.dart';
import '../lib/widgets/poll_widget.dart';
import '../lib/Services/post_service.dart';

class MockPostService extends Mock implements PostService {}

void main() {
  setUpAll(() {
    GetIt.instance.registerSingleton<PostService>(MockPostService());
  });

  testWidgets('test_poll_view_initialization_and_display',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PollView(
        id: 'poll1',
        options: [
          {'Option 1': 30.0},
          {'Option 2': 70.0}
        ],
        question: 'What is your favorite color?',
        option1UserVotes: ['user1', 'user2'],
        option2UserVotes: ['user3'],
        currentUser: 'user1',
        currentUserId: 'user1',
        isExpired: false,
        optionId: ['opt1', 'opt2'],
        onPollVote: (String id, int choice, String user) {},
      ),
    ));

    expect(find.text('What is your favorite color?'), findsOneWidget);
    expect(find.text('Option 1'), findsOneWidget);
    expect(find.text('Option 2'), findsOneWidget);
  });

  testWidgets('test_poll_behavior', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PollView(
        id: 'poll1',
        options: [
          {'Option 1': 30.0},
          {'Option 2': 70.0}
        ],
        question: 'What is your favorite color?',
        option1UserVotes: ['user1', 'user2'],
        option2UserVotes: ['user3'],
        currentUser: 'user1',
        currentUserId: 'user1',
        isExpired: false,
        optionId: ['opt1', 'opt2'],
        onPollVote: (String id, int choice, String user) {},
      ),
    ));

    await tester.tap(find.text('Option 1'));
    await tester.pumpAndSettle();

    expect(find.text("70.0%"), findsOneWidget);
  });

}
