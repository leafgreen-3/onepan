import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/step.dart' as v1;
import 'package:onepan/data/repositories/recipe_repository.dart' as v1;
import 'package:onepan/features/instructions/instructions_screen.dart';
import 'package:onepan/features/recipe/recipe_mode.dart';

class _MockRecipeRepository extends Mock implements v1.RecipeRepository {}

v1.Recipe _makeRecipe({String id = 'r1', String title = 'Sample'}) => v1.Recipe(
      schemaVersion: 1,
      id: id,
      title: title,
      timeTotalMin: 10,
      diet: 'veg',
      imageAsset: 'assets/images/recipes/$id.png',
      ingredients: const [
        v1.Ingredient(id: 'oil', qty: 1, unit: 'tbsp', category: 'core'),
      ],
      steps: const [
        v1.StepItem(num: 1, text: 'Cook it'),
      ],
    );

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

  testWidgets('shows Ingredients and Recipe tabs in simple mode', (tester) async {
    when(() => repo.getById('r1')).thenAnswer((_) async => _makeRecipe());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: InstructionsScreen(recipeId: 'r1', mode: RecipeMode.simple),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('Recipe'), findsOneWidget);

    // Switch to Recipe tab
    await tester.tap(find.text('Recipe'));
    await tester.pumpAndSettle();

    expect(find.text('Cook it'), findsOneWidget);
  });

  testWidgets('shows Ingredients (AI) tab in ai mode', (tester) async {
    when(() => repo.getById('r1')).thenAnswer((_) async => _makeRecipe());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: InstructionsScreen(recipeId: 'r1', mode: RecipeMode.ai),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Ingredients (AI)'), findsOneWidget);
    expect(find.text('Recipe'), findsOneWidget);
  });
}
