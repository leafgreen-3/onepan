import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepan/features/home/home_screen.dart';
import 'package:onepan/models/recipe.dart';
import 'package:onepan/repository/recipe_repository.dart';
import 'package:onepan/router/routes.dart';

class _MockRecipeRepository extends Mock implements RecipeRepository {}

Widget _buildRouterApp(Widget home) {
  final router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => home,
      ),
      GoRoute(
        path: '${Routes.recipe}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return Scaffold(
            appBar: AppBar(title: Text('Recipe: $id')),
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
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

Recipe makeRecipe({String id = 'r1', String title = 'Chickpea OnePan'}) => Recipe(
      id: id,
      title: title,
      minutes: 22,
      servings: 2,
      spice: SpiceLevel.mild,
      image: null,
      ingredients: const ['a'],
      steps: const ['b'],
    );

void main() {
  final getIt = GetIt.instance;
  late _MockRecipeRepository repo;

  setUp(() async {
    await getIt.reset();
    repo = _MockRecipeRepository();
    getIt.registerSingleton<RecipeRepository>(repo);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('HomeScreen', () {
    testWidgets('loading state shows loading skeleton', (tester) async {
      final completer = Completer<List<Recipe>>();
      when(() => repo.list()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(_buildRouterApp(const HomeScreen()));
      await tester.pump();

      expect(find.byKey(const Key('home_loading_skeleton')), findsOneWidget);
    });

    testWidgets('empty state shows message and refresh; tapping refresh re-calls list()', (tester) async {
      when(() => repo.list()).thenAnswer((_) async => <Recipe>[]);

      await tester.pumpWidget(_buildRouterApp(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_empty_message')), findsOneWidget);
      expect(find.byKey(const Key('home_refresh_button')), findsOneWidget);

      // Tap refresh
      await tester.tap(find.byKey(const Key('home_refresh_button')));
      await tester.pump();

      verify(() => repo.list()).called(greaterThanOrEqualTo(2));
    });

    testWidgets('error state shows message and retry; tapping retry re-calls list()', (tester) async {
      var callCount = 0;
      when(() => repo.list()).thenAnswer((_) async {
        callCount++;
        throw Exception('network');
      });

      await tester.pumpWidget(_buildRouterApp(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_error_message')), findsOneWidget);
      expect(find.byKey(const Key('home_retry_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('home_retry_button')));
      await tester.pump();

      expect(callCount, greaterThanOrEqualTo(2));
    });

    testWidgets('data state renders one card and navigates to recipe detail', (tester) async {
      when(() => repo.list()).thenAnswer((_) async => [makeRecipe(id: 'r1')]);

      await tester.pumpWidget(_buildRouterApp(const HomeScreen()));
      await tester.pumpAndSettle();

      final cardFinder = find.byKey(const Key('recipe_card_r1'));
      expect(cardFinder, findsOneWidget);

      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('recipe_detail_r1')), findsOneWidget);
    });

    testWidgets('favorite toggle updates icon state', (tester) async {
      when(() => repo.list()).thenAnswer((_) async => [makeRecipe(id: 'r1')]);

      await tester.pumpWidget(_buildRouterApp(const HomeScreen()));
      await tester.pumpAndSettle();

      final favFinder = find.byKey(const Key('favorite_r1'));
      expect(favFinder, findsOneWidget);

      // Initially not favorited
      Icon iconBefore = tester.widget<Icon>(find.descendant(of: favFinder, matching: find.byType(Icon)).first);
      expect(iconBefore.icon, equals(Icons.favorite_border));

      await tester.tap(favFinder);
      await tester.pump();

      Icon iconAfter = tester.widget<Icon>(find.descendant(of: favFinder, matching: find.byType(Icon)).first);
      expect(iconAfter.icon, equals(Icons.favorite));
    });
  });
}
