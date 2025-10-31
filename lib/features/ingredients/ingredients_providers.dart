import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepan/di/locator.dart';
import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/data/repositories/recipe_repository.dart' as v1;
import 'ingredient_index.dart';

// 1) Ingredient index from repository
final ingredientIndexProvider = FutureProvider<IngredientIndex>((ref) async {
  final repo = locator<v1.RecipeRepository>();
  return buildIngredientIndex(repo);
});

// 2) Selected ingredient ids state
class SelectedIngredientsController extends StateNotifier<Set<String>> {
  SelectedIngredientsController() : super(<String>{});

  void toggle(String id) {
    final next = Set<String>.from(state);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = next;
  }

  void setAll(Iterable<String> ids) {
    state = ids.toSet();
  }

  void clear() {
    state = <String>{};
  }
}

final selectedIngredientIdsProvider =
    StateNotifierProvider<SelectedIngredientsController, Set<String>>(
        (ref) => SelectedIngredientsController());

// 3) Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// 4) Filtered groups provider: empty => original groups; non-empty => single results group
final filteredGroupsProvider = Provider<List<IngredientGroup>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final indexAsync = ref.watch(ingredientIndexProvider);
  return indexAsync.maybeWhen(
    data: (index) {
      if (query.isEmpty) return index.groups;
      final results = index.all
          .where((ing) =>
              ing.name.toLowerCase().contains(query) ||
              ing.id.toLowerCase().contains(query))
          .toList(growable: false);
      return [
        IngredientGroup(
          key: 'header_results',
          title: 'Results',
          items: results,
        )
      ];
    },
    orElse: () => const <IngredientGroup>[],
  );
});

// Collapse state for groups
class CollapseController extends StateNotifier<Map<String, bool>> {
  CollapseController(super.state);

  void toggle(String group) {
    final current = state[group] ?? true;
    state = {...state, group: !current};
  }
}

final collapseStateProvider = StateNotifierProvider.autoDispose
    .family<CollapseController, Map<String, bool>, void>((ref, _) {
  return CollapseController({
    'core': true, // default expanded
    'protein': true,
    'vegetable': true,
    'spice': true,
    'other': true,
  });
});
