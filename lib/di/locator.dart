import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:onepan/app/services/preferences_service.dart';
import 'package:onepan/app/state/onboarding_state.dart';
import 'package:onepan/data/sources/local/seed_loader.dart';
import 'package:onepan/data/repositories/seed_recipe_repository.dart' as v1;
import 'package:onepan/data/repositories/recipe_repository.dart' as v1;

// Toggle for substitution repository. True => use mock implementation.
const bool kUseMockSubstitution = true;

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Recipe repository (v1 schema, seeded from assets)
  if (!getIt.isRegistered<v1.RecipeRepository>()) {
    final loader = SeedLoader();
    getIt.registerLazySingleton<v1.RecipeRepository>(() => v1.SeedRecipeRepository(seedLoader: loader));
  }

  // TODO(legacy): Substitution repository wiring depends on legacy schema.
  // Remove/replace after MVP when v1-compatible substitution is available.
}

// Convenience accessor to keep UI concise and source-agnostic.
T locator<T extends Object>() => getIt<T>();

/// Shared preferences wrapper for onboarding and other persisted settings.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});

/// State holder for onboarding selections and completion persistence.
final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  final service = ref.read(preferencesServiceProvider);
  return OnboardingController(service);
});
