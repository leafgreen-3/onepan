import 'package:flutter_test/flutter_test.dart';
import 'package:onepan/features/ingredients/ingredient_utils.dart';

void main() {
  group('computeMissingIds', () {
    test('returns empty when recipe has no ingredients', () {
      expect(computeMissingIds(recipeIngredients: const [], availableIds: const []), isEmpty);
    });

    test('returns all when none are available', () {
      final result = computeMissingIds(
        recipeIngredients: const ['a', 'b', 'c'],
        availableIds: const [],
      );
      expect(result, ['a', 'b', 'c']);
    });

    test('filters out available while preserving order', () {
      final result = computeMissingIds(
        recipeIngredients: const ['x', 'y', 'z', 'x2'],
        availableIds: const ['y', 'x2'],
      );
      expect(result, ['x', 'z']);
    });
  });
}

