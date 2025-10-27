# Repositories

## Overview
- Purpose: decouple UI from data sources via repository interfaces and dependency injection.
- DI: `get_it` is configured in `lib/di/locator.dart`. UI obtains instances via `locator<Interface>()`.

## Interfaces
- RecipeRepository
  - File: `lib/repository/recipe_repository.dart`
  - Signatures:
    - `Future<List<Recipe>> list({int? maxMinutes, SpiceLevel? maxSpice, bool? favoritesOnly});`
    - `Future<Recipe> getById(String id);`
- SubstitutionRepository
  - File: `lib/repository/substitution_repository.dart`
  - Contract: `Future<SubstitutionResponse> substitute(SubstitutionRequest req);`

## Implementations
- SeedRecipeRepository
  - File: `lib/repository/seed_recipe_repository.dart`
  - Behavior: loads curated seeds from `assets/recipes.json` through the loader, caches in memory, and applies simple filters (≤ `maxMinutes`, ≤ `maxSpice`).
- MockSubstitutionRepository
  - File: `lib/repository/mock_substitution_repository.dart`
  - Behavior: deterministic mock. For any request, the same normalized input yields the exact same output. Uses a stable FNV-1a hash of normalized fields to make consistent selections. Preserves ingredient order and proposes at most two substitutions from a small lookup table.

## Determinism Rules
- Normalize request inputs:
  - Sort `availableIds` and `missingIds` and lowercase/trim tokens.
  - Coerce `params.spice` to a recognized enum name; ignore unknown keys for noise stability.
  - `servings` must be > 0 if present; `time` must be ≥ 0 if present.
- Stable hash → stable selection:
  - Hash payload: `recipeId|p:<normalizedParams>|a:<sortedAvailable>|m:<sortedMissing>`.
  - Use hash bits to deterministically pick substitutions when not explicitly marked available/missing.
- Response is stable and preserves ingredient list order.

## Contract (copyable)
```json
// request
{
  "recipe_id": "spicy-tomato-pasta",
  "params": { "servings": 2, "time": 30, "spice": "medium" },
  "available_ids": ["pan","knife","salt"],
  "missing_ids": ["butter"]
}
// response
{
  "final_ingredients": ["200g spaghetti", "..."],
  "substitutions": [
    { "from": "butter", "to": "olive oil", "note": "mock: availability-based" }
  ]
}
```

Note: In-app models use camelCase keys (e.g., `recipeId`, `availableIds`).

## File Locations
- Interfaces: `lib/repository/recipe_repository.dart`, `lib/repository/substitution_repository.dart`
- Models: `lib/models/recipe.dart`, `lib/models/substitution.dart`
- Implementations: `lib/repository/seed_recipe_repository.dart`, `lib/repository/mock_substitution_repository.dart`
- DI: `lib/di/locator.dart`

## Extending
- To swap in a real substitution service:
  - Implement `SubstitutionRepository` in `lib/repository/` (e.g., `remote_substitution_repository.dart`).
  - Validate inputs using `SubstitutionRequest.validate()` and mirror determinism where helpful for tests.
  - Register it in `lib/di/locator.dart` (flip the `kUseMockSubstitution` flag or introduce an environment-specific registration).
  - UI remains unchanged since it depends on the interface via DI.

