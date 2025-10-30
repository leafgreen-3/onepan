import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/di/locator.dart';
import 'package:onepan/data/models/recipe.dart';
import 'package:onepan/data/repositories/recipe_repository.dart' as v1;

/// Provides the v1 RecipeRepository from the app's DI container.
final recipeRepositoryProvider = Provider<v1.RecipeRepository>((ref) {
  return locator<v1.RecipeRepository>();
});

/// Fetch a recipe by its stable ID.
final recipeByIdProvider = FutureProvider.family<Recipe?, String>((ref, id) async {
  final repo = ref.read(recipeRepositoryProvider);
  return repo.getById(id);
});
