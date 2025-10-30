import '../models/recipe.dart';
import '../sources/local/seed_loader.dart';
import 'recipe_repository.dart';

/// Recipes with timeTotalMin <= kFastThresholdMin are considered "fast".
const kFastThresholdMin = 25;

/// Recipe repository backed by bundled seed data.
class SeedRecipeRepository implements RecipeRepository {
  SeedRecipeRepository({required SeedLoader seedLoader})
      : _seedLoader = seedLoader {
    _recipesFuture = _load();
  }

  final SeedLoader _seedLoader;
  late final Future<List<Recipe>> _recipesFuture;

  Future<List<Recipe>> _load() async {
    final recipes = await _seedLoader.load();
    final sorted = List<Recipe>.from(recipes)
      ..sort((a, b) {
        final timeCompare = a.timeTotalMin.compareTo(b.timeTotalMin);
        if (timeCompare != 0) {
          return timeCompare;
        }
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });
    return sorted;
  }

  @override
  Future<List<Recipe>> list({String? diet, String? timeMode}) async {
    final recipes = await _recipesFuture;
    Iterable<Recipe> results = recipes;

    if (diet != null && diet.isNotEmpty) {
      final normalized = diet.toLowerCase();
      results = results.where((recipe) => recipe.diet == normalized);
    }

    if (timeMode != null && timeMode.isNotEmpty) {
      final normalized = timeMode.toLowerCase();
      if (normalized == 'fast') {
        results = results.where((recipe) => recipe.timeTotalMin <= kFastThresholdMin);
      } else if (normalized == 'regular') {
        results = results.where((recipe) => recipe.timeTotalMin > kFastThresholdMin);
      }
    }

    return results.toList(growable: false);
  }

  @override
  Future<Recipe?> getById(String id) async {
    if (id.trim().isEmpty) {
      return null;
    }
    final recipes = await _recipesFuture;
    for (final recipe in recipes) {
      if (recipe.id == id) {
        return recipe;
      }
    }
    return null;
  }
}
