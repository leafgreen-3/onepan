// TODO(legacy): Remove after MVP once all references are gone.
import 'package:onepan/data/recipe_loader.dart';
import 'package:onepan/models/recipe.dart';
import 'package:onepan/repository/recipe_repository.dart';

class SeedRecipeRepository implements RecipeRepository {
  final String assetPath;
  List<Recipe>? _cache;

  SeedRecipeRepository({this.assetPath = 'assets/recipes.json'});

  Future<List<Recipe>> _ensureLoaded() async {
    final existing = _cache;
    if (existing != null) return existing;
    final loaded = await loadRecipesFromAsset(assetPath);
    _cache = loaded;
    return loaded;
  }

  @override
  Future<List<Recipe>> list({int? maxMinutes, SpiceLevel? maxSpice, bool? favoritesOnly}) async {
    if (maxMinutes != null && maxMinutes < 0) {
      throw ArgumentError.value(maxMinutes, 'maxMinutes', 'must be >= 0');
    }
    final list = await _ensureLoaded();
    Iterable<Recipe> results = list;
    if (maxMinutes != null) {
      results = results.where((r) => r.minutes <= maxMinutes);
    }
    if (maxSpice != null) {
      results = results.where((r) => r.spice.index <= maxSpice.index);
    }
    // favoritesOnly is ignored in seed data (no persistence yet)
    return results.toList(growable: false);
  }

  @override
  Future<Recipe> getById(String id) async {
    final trimmed = id.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(id, 'id', 'must be non-empty');
    }
    final list = await _ensureLoaded();
    final match = list.where((r) => r.id == trimmed);
    if (match.isEmpty) {
      throw StateError('Recipe not found: $trimmed');
    }
    return match.first;
  }
}

