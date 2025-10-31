import 'package:onepan/data/models/ingredient.dart' as v1;
import 'package:onepan/data/models/recipe.dart' as v1;
import 'package:onepan/data/repositories/recipe_repository.dart' as v1;

class IngredientGroup {
  IngredientGroup({required this.key, required this.title, required this.items});
  final String key; // e.g., header_core, header_results
  final String title; // e.g., Core, Protein
  final List<v1.Ingredient> items;
}

class IngredientIndex {
  IngredientIndex({required this.all, required this.groups});
  final List<v1.Ingredient> all;
  // Ordered groups: core, protein, vegetable, spice, other
  final List<IngredientGroup> groups;
}

/// Build an ingredient index from all recipes in the repository.
/// - Dedupes by id across all seeds
/// - Sorts A→Z by name
/// - Computes groups with Core pinned (category "core" + pinned ids)
Future<IngredientIndex> buildIngredientIndex(v1.RecipeRepository repo) async {
  final recipes = await repo.list();
  final byId = <String, v1.Ingredient>{};

  for (final v1.Recipe r in recipes) {
    for (final v1.Ingredient ing in r.ingredients) {
      byId.putIfAbsent(ing.id, () => ing);
    }
  }

  final all = byId.values.toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  // Core pin list: exact or prefix match for 'onion' support (e.g., onion-yellow)
  const pinnedBases = <String>{'oil-olive', 'salt', 'pepper', 'onion', 'garlic'};
  bool isPinned(v1.Ingredient ing) {
    for (final base in pinnedBases) {
      if (ing.id == base) return true;
      if (ing.id.startsWith(base)) return true;
    }
    return false;
  }

  final core = <v1.Ingredient>[];
  final protein = <v1.Ingredient>[];
  final vegetable = <v1.Ingredient>[];
  final spice = <v1.Ingredient>[];
  final other = <v1.Ingredient>[];

  for (final ing in all) {
    if (ing.category == 'core' || isPinned(ing)) {
      core.add(ing);
      continue;
    }
    switch (ing.category) {
      case 'protein':
        protein.add(ing);
        break;
      case 'vegetable':
        vegetable.add(ing);
        break;
      case 'spice':
        spice.add(ing);
        break;
      default:
        other.add(ing);
    }
  }

  final groups = <IngredientGroup>[
    IngredientGroup(key: 'header_core', title: 'Core', items: core),
    IngredientGroup(key: 'header_protein', title: 'Protein', items: protein),
    IngredientGroup(key: 'header_vegetable', title: 'Vegetable', items: vegetable),
    IngredientGroup(key: 'header_spice', title: 'Spice', items: spice),
    IngredientGroup(key: 'header_other', title: 'Other', items: other),
  ];

  return IngredientIndex(all: all, groups: groups);
}

