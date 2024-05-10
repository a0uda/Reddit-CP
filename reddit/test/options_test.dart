// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:get_it/get_it.dart';
// import 'package:reddit/Controllers/post_controller.dart';
// import 'package:reddit/Controllers/user_controller.dart';
// import 'package:reddit/Services/post_service.dart';
// import 'package:reddit/widgets/options.dart';

// void main() {
//   group('Options Widget Tests', () {
//     testWidgets('test_toggle_save_unsave_post', (WidgetTester tester) async {
//       final testWidget = MaterialApp(
//         home: Provider<UserController>(
//           create: (_) => UserController(),
//           child: Options(
//             username: 'testUser',
//             postId: '123',
//             saved: false,
//             islocked: false,
//             isMyPost: true,
//             onSaveChanged: (bool value) {},
//             onLockChanged: (bool value) {},
// onEditChanged: (String value) {},
// onDeleteChanged: (bool value) {},
//           ),
//         ),
//       );

//       await tester.pumpWidget(testWidget);
//       await tester.tap(find.byIcon(Icons.save));
//       await tester.pump();

//       // Check if the save icon changes to unsave after tap
//       expect(find.byIcon(Icons.save), findsNothing);
//       expect(find.byIcon(Icons.save_alt), findsOneWidget);
//     });

//     testWidgets('test_post_owner_options_visibility', (WidgetTester tester) async {
//       final testWidget = MaterialApp(
//         home: Provider<UserController>(
//           create: (_) => UserController(),
//           child: Options(
//             username: 'testUser',
//             postId: '123',
//             saved: false,
//             islocked: false,
//             isMyPost: true,
//             onSaveChanged: (bool value) {},
//             onLockChanged: (bool value) {},
// onEditChanged: (String value) {},
// onDeleteChanged: (bool value) {},
//           ),
//         ),
//       );

//       await tester.pumpWidget(testWidget);

//       // Check if edit, delete, and lock/unlock comments are visible for the owner
//       expect(find.text('Edit'), findsOneWidget);
//       expect(find.text('Delete'), findsOneWidget);
//       expect(find.text('Lock Comments'), findsOneWidget);
//     });

//     testWidgets('test_null_postId_handling', (WidgetTester tester) async {
//       final testWidget = MaterialApp(
//         home: Provider<UserController>(
//           create: (_) => UserController(),
//           child: Options(
//             username: 'testUser',
//             postId: null,
//             saved: false,
//             islocked: false,
//             isMyPost: true,
//             onSaveChanged: (bool value) {},
//             onLockChanged: (bool value) {},
// onEditChanged: (String value) {},
// onDeleteChanged: (bool value) {},
//           ),
//         ),
//       );

//       await tester.pumpWidget(testWidget);

//       // Check if the widget builds without crashing
//       expect(find.byType(Options), findsOneWidget);
//     });
//   });
// }