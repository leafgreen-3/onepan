import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/features/ingredients/state/selected_ingredients_provider.dart'
    as picked;

void main() {
  test('write/read set for a given recipeId', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Initially empty for r1
    expect(container.read(picked.selectedIngredientIdsProvider('r1')), isEmpty);

    // Write
    container
        .read(picked.selectedIngredientIdsProvider('r1').notifier)
        .state = {'ing-1', 'ing-3'};

    // Read back
    expect(container.read(picked.selectedIngredientIdsProvider('r1')), {
      'ing-1',
      'ing-3'
    });

    // Separate recipe id has its own namespace
    expect(container.read(picked.selectedIngredientIdsProvider('r2')), isEmpty);
  });
}

