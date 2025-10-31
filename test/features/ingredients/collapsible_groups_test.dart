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

class _MockRepo extends Mock implements v1.RecipeRepository {}

Widget _app(Widget page, {required Map<String, dynamic> extra}) {
  final router = GoRouter(
    initialLocation: '/ingredients',
    routes: [
      GoRoute(
        path: '/ingredients',
        builder: (context, state) => ProviderScope(child: page),
      ),
    ],
  );
  router.go('/ingredients', extra: extra);
  return MaterialApp.router(routerConfig: router);
}

void main() {
  final getIt = GetIt.instance;
  late _MockRepo repo;

  setUp(() async {
    await getIt.reset();
    repo = _MockRepo();
    getIt.registerSingleton<v1.RecipeRepository>(repo);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('headers toggle collapse and expand; search bypasses collapse', (tester) async {
    const ingredients = [
      v1.Ingredient(id: 'oil-olive', name: 'Olive oil', qty: 1, unit: 'tbsp', category: 'core'),
      v1.Ingredient(id: 'tofu-firm', name: 'Tofu', qty: 1, unit: 'piece', category: 'protein'),
      v1.Ingredient(id: 'spinach', name: 'Spinach', qty: 1, unit: 'cup', category: 'vegetable'),
      v1.Ingredient(id: 'garlic', name: 'Garlic', qty: 1, unit: 'piece', category: 'spice'),
      v1.Ingredient(id: 'miso', name: 'Miso', qty: 1, unit: 'tbsp', category: 'other'),
    ];
    const recipe = v1.Recipe(
      schemaVersion: 1,
      id: 'r1',
      title: 'Demo',
      timeTotalMin: 10,
      diet: 'veg',
      imageAsset: 'x',
      ingredients: ingredients,
      steps: [v1.StepItem(num: 1, text: 's')],
    );

    when(() => repo.list()).thenAnswer((_) async => [recipe]);
    when(() => repo.getById('r1')).thenAnswer((_) async => recipe);

    final widget = _app(const IngredientsScreen(), extra: {'recipeId': 'r1'});
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    // Ensure headers exist
    expect(find.byKey(const Key('header_core')), findsOneWidget);
    expect(find.byKey(const Key('header_protein')), findsOneWidget);

    // Collapse protein
    final proteinRow = find.byKey(const Key('ing_row_tofu-firm'));
    expect(proteinRow, findsOneWidget);
    await tester.tap(find.byKey(const Key('toggle_protein')));
    await tester.pumpAndSettle(const Duration(milliseconds: 250));
    expect(proteinRow, findsNothing);

    // Expand again
    await tester.tap(find.byKey(const Key('toggle_protein')));
    await tester.pumpAndSettle(const Duration(milliseconds: 250));
    expect(proteinRow, findsOneWidget);

    // Collapse persists after scroll
    await tester.tap(find.byKey(const Key('toggle_vegetable')));
    await tester.pumpAndSettle(const Duration(milliseconds: 250));
    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ing_row_spinach')), findsNothing);

    // Search bypasses collapse
    await tester.enterText(find.byKey(const Key('ing_search')), 'gar');
    await tester.pump();
    expect(find.byKey(const Key('header_results')), findsOneWidget);
    // Garlic row visible even if its group was collapsed
    expect(find.byKey(const Key('ing_row_garlic')), findsOneWidget);
  });
}

