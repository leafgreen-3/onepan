import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepan/features/home/home_controller.dart';
import 'package:onepan/models/recipe.dart';
import 'package:onepan/repository/recipe_repository.dart';

class _MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  late _MockRecipeRepository repo;

  setUp(() {
    repo = _MockRecipeRepository();
  });

  Recipe makeRecipe({String id = 'r1', String title = 'A'}) => Recipe(
        id: id,
        title: title,
        minutes: 10,
        servings: 2,
        spice: SpiceLevel.mild,
        ingredients: const ['x'],
        steps: const ['y'],
      );

  group('HomeController', () {
    test('loads success -> AsyncData length 1', () async {
      when(() => repo.list()).thenAnswer((_) async => [makeRecipe()]);

      final controller = HomeController(repo);

      // Ensure load completes deterministically
      await controller.refresh();

      expect(controller.state.recipes, isA<AsyncData<List<Recipe>>>());
      final data = (controller.state.recipes as AsyncData<List<Recipe>>).value;
      expect(data.length, 1);
    });

    test('loads error -> AsyncError', () async {
      when(() => repo.list()).thenThrow(Exception('boom'));

      final controller = HomeController(repo);

      await controller.refresh();

      expect(controller.state.recipes, isA<AsyncError>());
    });

    test('toggleFavorite add/remove', () async {
      when(() => repo.list()).thenAnswer((_) async => <Recipe>[]);

      final controller = HomeController(repo);
      await controller.refresh();

      expect(controller.state.favorites.contains('r1'), isFalse);

      controller.toggleFavorite('r1');
      expect(controller.state.favorites.contains('r1'), isTrue);

      controller.toggleFavorite('r1');
      expect(controller.state.favorites.contains('r1'), isFalse);
    });
  });
}
