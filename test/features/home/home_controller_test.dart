import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepan/features/home/home_controller.dart';
import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/data/models/step.dart' as v1;
import 'package:onepan/data/repositories/recipe_repository.dart' as v1;

class _MockRecipeRepository extends Mock implements v1.RecipeRepository {}

void main() {
  late _MockRecipeRepository repo;

  setUp(() {
    repo = _MockRecipeRepository();
  });

  v1.Recipe makeRecipe({String id = 'r1', String title = 'A'}) => v1.Recipe(
        schemaVersion: 1,
        id: id,
        title: title,
        timeTotalMin: 10,
        diet: 'veg',
        imageAsset: 'assets/images/recipes/$id.png',
        ingredients: const [
          v1.Ingredient(
            id: 'oil',
            qty: 1,
            unit: 'tbsp',
            category: 'core',
          ),
        ],
        steps: const [
          v1.StepItem(num: 1, text: 'Cook'),
        ],
      );

  group('HomeController', () {
    test('loads success -> AsyncData length 1', () async {
      when(() => repo.list()).thenAnswer((_) async => [makeRecipe()]);

      final controller = HomeController(repo as v1.RecipeRepository);

      // Ensure load completes deterministically
      await controller.refresh();

      expect(controller.state.recipes, isA<AsyncData<List<v1.Recipe>>>());
      final data = (controller.state.recipes as AsyncData<List<v1.Recipe>>).value;
      expect(data.length, 1);
    });

    test('loads error -> AsyncError', () async {
      when(() => repo.list()).thenThrow(Exception('boom'));

      final controller = HomeController(repo as v1.RecipeRepository);

      await controller.refresh();

      expect(controller.state.recipes, isA<AsyncError>());
    });

    test('toggleFavorite add/remove', () async {
      when(() => repo.list()).thenAnswer((_) async => <v1.Recipe>[]);

      final controller = HomeController(repo as v1.RecipeRepository);
      await controller.refresh();

      expect(controller.state.favorites.contains('r1'), isFalse);

      controller.toggleFavorite('r1');
      expect(controller.state.favorites.contains('r1'), isTrue);

      controller.toggleFavorite('r1');
      expect(controller.state.favorites.contains('r1'), isFalse);
    });
  });
}
