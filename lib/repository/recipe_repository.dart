import 'package:onepan/models/recipe.dart';

/// Contract for fetching recipes, independent of data source.
abstract class RecipeRepository {
  Future<List<Recipe>> list({
    int? maxMinutes,
    SpiceLevel? maxSpice,
    bool? favoritesOnly,
  });

  Future<Recipe> getById(String id);
}

