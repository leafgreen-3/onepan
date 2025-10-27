import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onepan/main.dart';

void main() {
  testWidgets('renders OnePan text on home screen', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding.complete': true,
      'onboarding.country': 'US',
      'onboarding.level': 'Beginner',
      'onboarding.diet': 'Omnivore',
    });
    await tester.pumpWidget(const OnePanApp());
    await tester.pumpAndSettle();

    expect(find.text('OnePan'), findsOneWidget);
  });
}
