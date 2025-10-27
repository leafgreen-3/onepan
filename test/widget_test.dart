// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onepan/main.dart';

void main() {
  testWidgets('renders OnePan home route', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.complete': true,
      'onboarding.country': 'US',
      'onboarding.level': 'Beginner',
      'onboarding.diet': 'Omnivore',
    });
    await tester.pumpWidget(const OnePanApp());
    await tester.pumpAndSettle();

    // When onboarding is complete, home shows centered text 'OnePan'.
    expect(find.text('OnePan'), findsOneWidget);
  });
}
