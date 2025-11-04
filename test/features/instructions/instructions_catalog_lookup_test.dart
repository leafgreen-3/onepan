import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:onepan/features/instructions/instructions_screen.dart';
import 'package:onepan/features/recipe/recipe_mode.dart';
import 'package:onepan/features/recipe/recipe_providers.dart';
import 'package:onepan/data/repositories/recipe_repository.dart' as v1repo;
import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/ingredient.dart' as v1i;
import 'package:onepan/data/models/step.dart' as v1s;

class _FakeRepo implements v1repo.RecipeRepository {
  _FakeRepo(this.recipe);
  final v1.Recipe recipe;
  @override
  Future<v1.Recipe?> getById(String id) async {
    return id == recipe.id ? recipe : null;
  }

  @override
  Future<List<v1.Recipe>> list({String? diet, String? timeMode}) async {
    return <v1.Recipe>[recipe];
  }
}

void main() {
  testWidgets('InstructionsScreen uses catalog-only names/images with placeholder fallback', (tester) async {
    // Known id in catalog (spinach), fallback (oil-olive with asset), and unknown-no-asset
    const ingKnown = v1i.Ingredient(
      id: 'spinach',
      qty: 2,
      unit: 'cup',
      category: 'vegetable',
    );
    const ingFallback = v1i.Ingredient(
      id: 'not-in-catalog-asset',
      qty: 1,
      unit: 'tbsp',
      category: 'core',
    );
    const ingUnknown = v1i.Ingredient(
      id: 'unknown-no-asset',
      qty: 1,
      unit: 'piece',
      category: 'other',
    );

    const recipe = v1.Recipe(
      schemaVersion: 1,
      id: 'r_test',
      title: 'Test Recipe',
      timeTotalMin: 10,
      diet: 'veg',
      imageAsset: 'assets/images/recipes/chickpea-spinach-onepan.png',
      ingredients: <v1i.Ingredient>[ingKnown, ingFallback, ingUnknown],
      steps: <v1s.StepItem>[
        v1s.StepItem(num: 1, text: 'Do something'),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipeRepositoryProvider.overrideWithValue(_FakeRepo(recipe)),
        ],
        child: const MaterialApp(
          home: InstructionsScreen(recipeId: 'r_test', mode: RecipeMode.simple),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Catalog-known: name from catalog ('Spinach' from assets/ingredient_catalog.json)
    expect(find.text('Spinach'), findsWidgets);

    // Unknown to catalog: show id as name and placeholder
    expect(find.text('not-in-catalog-asset'), findsWidgets);
    expect(find.byKey(const Key('ing_thumb_placeholder_not-in-catalog-asset')), findsOneWidget);

    // Unknown id should show placeholder
    expect(find.byKey(const Key('ing_thumb_placeholder_unknown-no-asset')), findsOneWidget);
  });
}
