import '../models/recipe.dart';

/// Contract for fetching recipes.
abstract class RecipeRepository {
  /// List recipes with optional filters.
  Future<List<Recipe>> list({
    String? diet,
    String? timeMode,
  });

  Future<Recipe?> getById(String id);
}
