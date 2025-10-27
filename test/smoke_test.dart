import 'package:flutter_test/flutter_test.dart';
import 'package:onepan/main.dart';

void main() {
  testWidgets('renders OnePan text on home screen', (tester) async {
    await tester.pumpWidget(const OnePanApp());

    expect(find.text('OnePan'), findsOneWidget);
  });
}
