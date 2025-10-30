@Tags(['legacy'])
import 'package:flutter_test/flutter_test.dart';

import 'package:onepan/models/recipe.dart';
import 'package:onepan/repository/recipe_repository.dart';
import 'package:onepan/repository/seed_recipe_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SeedRecipeRepository', () {
    late RecipeRepository repo;

    setUp(() {
      repo = SeedRecipeRepository();
    });

    test('loads seeds once; list() returns > 0', () async {
      final list1 = await repo.list();
      expect(list1.length, greaterThan(0));
      // Call again to ensure no errors on cached access
      final list2 = await repo.list();
      expect(list2.length, equals(list1.length));
    });

    test('getById(existing) returns a Recipe', () async {
      final r = await repo.getById('spicy-tomato-pasta');
      expect(r, isA<Recipe>());
      expect(r.id, 'spicy-tomato-pasta');
    });

    test('filters: list(maxMinutes: 20) excludes long recipes', () async {
      final results = await repo.list(maxMinutes: 20);
      expect(results, isNotEmpty);
      expect(results.every((r) => r.minutes <= 20), isTrue);
      // Ensure a known long recipe is excluded
      expect(results.any((r) => r.id == 'slow-beef-ragu'), isFalse);
    });

    test('filters: list(maxSpice: SpiceLevel.mild) excludes hotter ones', () async {
      final results = await repo.list(maxSpice: SpiceLevel.mild);
      expect(results, isNotEmpty);
      expect(results.every((r) => r.spice.index <= SpiceLevel.mild.index), isTrue);
      // Known hot recipe should be excluded
      expect(results.any((r) => r.id == 'chana-masala'), isFalse);
    });
  });
}

