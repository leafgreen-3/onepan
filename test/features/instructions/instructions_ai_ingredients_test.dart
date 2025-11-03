import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/step.dart' as v1;
import 'package:onepan/features/instructions/instructions_screen.dart';
import 'package:onepan/features/recipe/recipe_mode.dart';
import 'package:onepan/features/recipe/recipe_providers.dart';
import 'package:onepan/features/ingredients/state/selected_ingredients_provider.dart'
    as picked;

void main() {
  const recipe = v1.Recipe(
    schemaVersion: 1,
    id: 'r1',
    title: 'Demo',
    timeTotalMin: 10,
    diet: 'veg',
    imageAsset: 'x',
    ingredients: [
      v1.Ingredient(id: 'ing-1', name: 'One', qty: 1, unit: 'piece', category: 'other'),
      v1.Ingredient(id: 'ing-2', name: 'Two', qty: 2, unit: 'piece', category: 'other'),
      v1.Ingredient(id: 'ing-3', name: 'Three', qty: 3, unit: 'piece', category: 'other'),
    ],
    steps: [v1.StepItem(num: 1, text: 'Cook')],
  );

  testWidgets('AI mode shows only picked ingredients', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipeByIdProvider('r1').overrideWith((ref) async => recipe),
          picked
              .selectedIngredientIdsProvider('r1')
              .overrideWith((ref) => {'ing-1', 'ing-3'}),
        ],
        child: const MaterialApp(
          home: InstructionsScreen(recipeId: 'r1', mode: RecipeMode.ai),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('One'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);
    expect(find.text('Two'), findsNothing);
  });

  testWidgets('Simple mode shows all ingredients', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipeByIdProvider('r1').overrideWith((ref) async => recipe),
          picked
              .selectedIngredientIdsProvider('r1')
              .overrideWith((ref) => {'ing-1'}),
        ],
        child: const MaterialApp(
          home: InstructionsScreen(recipeId: 'r1', mode: RecipeMode.simple),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);
  });

  testWidgets('AI mode with empty picks shows banner and full list', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipeByIdProvider('r1').overrideWith((ref) async => recipe),
          picked.selectedIngredientIdsProvider('r1').overrideWith((ref) => <String>{}),
        ],
        child: const MaterialApp(
          home: InstructionsScreen(recipeId: 'r1', mode: RecipeMode.ai),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('AI mode active'), findsOneWidget);
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);
  });
}

