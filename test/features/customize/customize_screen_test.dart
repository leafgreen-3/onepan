import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:onepan/features/customize/customize_screen.dart';

Widget _buildRouterApp({required String initialLocation}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/customize/:id',
        builder: (context, state) => const CustomizeScreen(),
      ),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return Scaffold(
            appBar: AppBar(title: const Text('Recipe')),
            body: Center(
              key: Key('recipe_detail_$id'),
              child: Text('Recipe: $id'),
            ),
          );
        },
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('CustomizeScreen', () {
    testWidgets('defaults and interactions, then navigate with payload', (tester) async {
      await tester.pumpWidget(_buildRouterApp(initialLocation: '/customize/r1'));
      await tester.pumpAndSettle();

      // Defaults
      expect(find.byKey(const Key('servings_value')), findsOneWidget);
      expect(find.text('2'), findsWidgets);

      // Clamp 1..6
      await tester.tap(find.byKey(const Key('servings_dec')));
      await tester.pump();
      expect(find.text('1'), findsWidgets);

      // Increase to 6 and try one more
      for (var i = 0; i < 6; i++) {
        await tester.tap(find.byKey(const Key('servings_inc')));
        await tester.pump();
      }
      expect(find.text('6'), findsWidgets);

      // Set to 3 for final payload
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byKey(const Key('servings_dec')));
        await tester.pump();
      }
      expect(find.text('3'), findsWidgets);

      // Toggle time to fast then back to regular, then fast for final
      await tester.tap(find.byKey(const Key('time_fast')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('time_regular')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('time_fast')));
      await tester.pump();

      // Toggle spice to spicy
      await tester.tap(find.byKey(const Key('spice_spicy')));
      await tester.pump();

      // Next → navigates to recipe (original ingredient picker screen)
      await tester.tap(find.byKey(const Key('customize_next')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recipe_detail_r1')), findsOneWidget);
    });
  });
}
