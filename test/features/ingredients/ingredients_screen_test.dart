import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/step.dart' as v1;
import 'package:onepan/data/repositories/recipe_repository.dart' as v1;
import 'package:onepan/features/ingredients/ingredients_screen.dart';

class _MockRecipeRepository extends Mock implements v1.RecipeRepository {}

Widget _buildRouterApp({required Widget home, required Map<String, dynamic> extra}) {
  final router = GoRouter(
    initialLocation: '/ingredients/r1',
    routes: [
      GoRoute(
        path: '/ingredients/:id',
        builder: (context, state) => ProviderScope(
          overrides: const [],
          child: home,
        ),
      ),
      GoRoute(
        path: '/finalizer/:id',
        builder: (context, state) {
          final payload = state.extra as Map<String, dynamic>? ?? const {};
          final recipeId = state.pathParameters['id'] ?? '';
          final available = (payload['availableIds'] as List?)?.join(',') ?? '';
          final missing = (payload['missingIds'] as List?)?.join(',') ?? '';
          return Scaffold(
            appBar: AppBar(title: const Text('Finalizer')),
            body: Column(
              children: [
                Text('rid:$recipeId', key: const Key('fin_recipe')),
                Text('avail:$available', key: const Key('fin_avail')),
                Text('miss:$missing', key: const Key('fin_miss')),
              ],
            ),
          );
        },
      ),
    ],
  );

  // Navigate with extra before build
  router.go('/ingredients/${extra['recipeId'] ?? 'r1'}', extra: extra);

  return MaterialApp.router(routerConfig: router);
}

void main() {
  final getIt = GetIt.instance;
  late _MockRecipeRepository repo;

  setUp(() async {
    await getIt.reset();
    repo = _MockRecipeRepository();
    getIt.registerSingleton<v1.RecipeRepository>(repo);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('Ingredients screen shows headers, search -> results, Next payload', (tester) async {
    const ingredients = [
      v1.Ingredient(id: 'garlic', name: 'Garlic', qty: 1, unit: 'piece', category: 'spice'),
      v1.Ingredient(id: 'onion-yellow', name: 'Yellow onion', qty: 1, unit: 'piece', category: 'vegetable'),
      v1.Ingredient(id: 'oil-olive', name: 'Olive oil', qty: 1, unit: 'tbsp', category: 'core'),
      v1.Ingredient(id: 'spinach', name: 'Spinach', qty: 1, unit: 'cup', category: 'vegetable'),
    ];
    const recipe = v1.Recipe(
      schemaVersion: 1,
      id: 'r1',
      title: 'r1',
      timeTotalMin: 10,
      diet: 'veg',
      imageAsset: 'x',
      ingredients: ingredients,
      steps: [v1.StepItem(num: 1, text: 's')],
    );

    when(() => repo.list()).thenAnswer((_) async => [recipe]);
    when(() => repo.getById('r1')).thenAnswer((_) async => recipe);

    // Build index from repo via provider
    const app = ProviderScope(
      overrides: [],
      child: IngredientsScreen(),
    );

    // Supply extra payload
    final widget = _buildRouterApp(home: app, extra: {
      'recipeId': 'r1',
      'customize': 'x',
    });

    await tester.pumpWidget(widget);
    // Let providers resolve
    await tester.pumpAndSettle();

    // Headers present
    expect(find.byKey(const Key('header_core')), findsOneWidget);
    expect(find.byKey(const Key('header_vegetable')), findsOneWidget);

    // Search triggers results header
    await tester.enterText(find.byKey(const Key('ing_search')), 'gar');
    await tester.pump();
    expect(find.byKey(const Key('header_results')), findsOneWidget);

    // Select an ingredient
    await tester.tap(find.byKey(const Key('ing_check_garlic')));
    await tester.pump();

    // Next navigates with payload
    await tester.tap(find.byKey(const Key('ing_next')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('fin_recipe')), findsOneWidget);
    expect(find.text('rid:r1'), findsOneWidget);
    // With defaults, core items are selected. After toggling garlic off via search,
    // missing should include garlic and spinach (not onion-yellow).
    expect(find.byKey(const Key('fin_avail')), findsOneWidget);
    expect(find.byKey(const Key('fin_miss')), findsOneWidget);
    final missText = tester.widget<Text>(find.byKey(const Key('fin_miss'))).data ?? '';
    expect(missText.contains('garlic'), true);
    expect(missText.contains('spinach'), true);
  });
}
