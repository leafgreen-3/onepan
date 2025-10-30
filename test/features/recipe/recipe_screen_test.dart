
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/step.dart' as v1;
import 'package:onepan/data/repositories/recipe_repository.dart' as v1;
import 'package:onepan/features/recipe/recipe_screen.dart';

class _MockRecipeRepository implements v1.RecipeRepository {
  _MockRecipeRepository(this._map);
  final Map<String, v1.Recipe?> _map;

  @override
  Future<v1.Recipe?> getById(String id) async => _map[id];

  @override
  Future<List<v1.Recipe>> list({String? diet, String? timeMode}) async => _map.values.whereType<v1.Recipe>().toList();
}

Widget _buildRouterApp(Widget home) {
  final router = GoRouter(
    initialLocation: '/recipe/r1',
    routes: [
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) => home,
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  final getIt = GetIt.instance;

  setUp(() async {
    await getIt.reset();
    const recipe = v1.Recipe(
      schemaVersion: 1,
      id: 'r1',
      title: 'Test Recipe',
      timeTotalMin: 25,
      diet: 'veg',
      imageAsset: 'assets/images/recipes/r1.png',
      ingredients: [
        v1.Ingredient(id: 'i1', name: 'One', qty: 1, unit: 'tbsp', category: 'core'),
        v1.Ingredient(id: 'i2', name: 'Two', qty: 2, unit: 'tsp', category: 'spice'),
        v1.Ingredient(id: 'i3', name: 'Three', qty: 3, unit: 'g', category: 'other'),
      ],
      steps: [
        v1.StepItem(num: 1, text: 'Do one'),
        v1.StepItem(num: 2, text: 'Do two', timerSec: 30),
        v1.StepItem(num: 3, text: 'Do three'),
      ],
    );
    getIt.registerSingleton<v1.RecipeRepository>(_MockRecipeRepository({'r1': recipe}));
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('RecipeScreen shows title, ingredients(3), steps(3)', (tester) async {
    await tester.pumpWidget(_buildRouterApp(const RecipeScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('recipe_title')), findsOneWidget);

    expect(find.byKey(const Key('ingredient_tile_i1')), findsOneWidget);
    expect(find.byKey(const Key('ingredient_tile_i2')), findsOneWidget);
    await tester.scrollUntilVisible(find.byKey(const Key('ingredient_tile_i3')), 200);
    expect(find.byKey(const Key('ingredient_tile_i3')), findsOneWidget);

    // Tap NEXT to navigate to Steps
    await tester.tap(find.byKey(const Key('next_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('step_1')), findsOneWidget);
    expect(find.byKey(const Key('step_2')), findsOneWidget);
    expect(find.byKey(const Key('step_3')), findsOneWidget);
  });
}
