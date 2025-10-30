import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/recipe_repository.dart' as seed_repo;
import '../data/repositories/seed_recipe_repository.dart';
import '../data/sources/local/seed_loader.dart';

// Simple DI placeholder for app-wide dependencies.
// This keeps structure ready without pulling extra packages yet.

class AppDependencies {
  const AppDependencies();
  // Add service getters or factories here when needed.
}

// Global singleton for now; replace with a proper container later.
const appDependencies = AppDependencies();

/// Provides access to the JSON seed loader.
final seedLoaderProvider = Provider<SeedLoader>((ref) {
  return SeedLoader();
});

/// Provides the recipe repository backed by local seed data.
final recipeRepositoryProvider = Provider<seed_repo.RecipeRepository>((ref) {
  final loader = ref.watch(seedLoaderProvider);
  return SeedRecipeRepository(seedLoader: loader);
});

/// Convenience provider for loading all recipes once for UI consumers.
final recipesListProvider = FutureProvider((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.list();
});
