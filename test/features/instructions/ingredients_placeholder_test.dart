import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/step.dart' as v1;
import 'package:onepan/features/instructions/instructions_screen.dart';
import 'package:onepan/features/recipe/recipe_mode.dart';
import 'package:onepan/features/recipe/recipe_providers.dart';

void main() {
  testWidgets('ingredient without image shows placeholder', (tester) async {
    const recipe = v1.Recipe(
      schemaVersion: 1,
      id: 'r1',
      title: 'Demo',
      timeTotalMin: 10,
      diet: 'veg',
      imageAsset: 'x',
      ingredients: [
        v1.Ingredient(id: 'ing-1', name: 'One', qty: 1, unit: 'piece', category: 'other'),
      ],
      steps: [v1.StepItem(num: 1, text: 'Cook')],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipeByIdProvider('r1').overrideWith((ref) async => recipe),
        ],
        child: const MaterialApp(
          home: InstructionsScreen(recipeId: 'r1', mode: RecipeMode.simple),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('ing_thumb_placeholder_ing-1')), findsOneWidget);
  });
}

