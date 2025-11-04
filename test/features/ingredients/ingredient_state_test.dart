import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/features/ingredients/ingredient_index.dart';
import 'package:onepan/features/ingredients/ingredients_providers.dart';

void main() {
  group('SelectedIngredientsController', () {
    test('toggle add/remove', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(selectedIngredientIdsProvider.notifier);
      expect(container.read(selectedIngredientIdsProvider), isEmpty);
      notifier.toggle('salt');
      expect(container.read(selectedIngredientIdsProvider), {'salt'});
      notifier.toggle('salt');
      expect(container.read(selectedIngredientIdsProvider), isEmpty);
    });
  });

  group('filteredGroupsProvider', () {
    test('empty search returns original groups; non-empty returns results', () async {
      const ingA = v1.Ingredient(id: 'garlic', qty: 1, unit: 'piece', category: 'spice');
      const ingB = v1.Ingredient(id: 'spinach', qty: 1, unit: 'cup', category: 'vegetable');
      final index = IngredientIndex(
        all: [ingA, ingB],
        groups: [
          IngredientGroup(key: 'header_core', title: 'Core', items: const []),
          IngredientGroup(key: 'header_vegetable', title: 'Vegetable', items: [ingB]),
          IngredientGroup(key: 'header_spice', title: 'Spice', items: [ingA]),
        ],
      );

      final container = ProviderContainer(overrides: [
        ingredientIndexProvider.overrideWith((ref) async => index),
      ]);
      addTearDown(container.dispose);

      // Empty search: expect original groups
      expect(container.read(searchQueryProvider), '');
      // Ensure index is available
      await container.read(ingredientIndexProvider.future);
      final groupsEmpty = container.read(filteredGroupsProvider);
      expect(groupsEmpty.length, 3);
      expect(groupsEmpty.first.key, 'header_core');

      // Non-empty: results only
      container.read(searchQueryProvider.notifier).state = 'gar';
      final groupsSearch = container.read(filteredGroupsProvider);
      expect(groupsSearch.length, 1);
      expect(groupsSearch.first.key, 'header_results');
      expect(groupsSearch.first.items.map((e) => e.id), contains('garlic'));
    });
  });
}
