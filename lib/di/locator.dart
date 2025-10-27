import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'package:onepan/app/services/preferences_service.dart';
import 'package:onepan/app/state/onboarding_state.dart';
import 'package:onepan/repository/mock_substitution_repository.dart';
import 'package:onepan/repository/seed_recipe_repository.dart';
import 'package:onepan/repository/recipe_repository.dart';
import 'package:onepan/repository/substitution_repository.dart';

// Toggle for substitution repository. True => use mock implementation.
const bool kUseMockSubstitution = true;

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Recipe repository (seeded from assets)
  if (!getIt.isRegistered<RecipeRepository>()) {
    getIt.registerLazySingleton<RecipeRepository>(() => SeedRecipeRepository());
  }

  // Substitution repository
  if (!getIt.isRegistered<SubstitutionRepository>()) {
    if (kUseMockSubstitution) {
      getIt.registerLazySingleton<SubstitutionRepository>(
        () => MockSubstitutionRepository(recipes: getIt<RecipeRepository>()),
      );
    } else {
      // Future real implementation; fallback to mock for now
      getIt.registerLazySingleton<SubstitutionRepository>(
        () => MockSubstitutionRepository(recipes: getIt<RecipeRepository>()),
      );
    }
  }
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
