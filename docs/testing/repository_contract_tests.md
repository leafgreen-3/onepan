# Repository Contract Tests

## What The Tests Assert
- Determinism (SubstitutionRepository)
  - Same `SubstitutionRequest` → identical `SubstitutionResponse` JSON across runs.
  - Reordering `availableIds`/`missingIds` does not change the result.
- Invalid Handling (SubstitutionRepository)
  - Empty `recipeId` throws `RecipeValidationError(field: 'recipeId', ...)`.
  - Negative `servings` or `time` throws validation errors.
  - Unknown `recipeId` throws a validation error.
- Filter Behavior (RecipeRepository)
  - `list()` returns > 0 and caches seeds.
  - `getById(existing)` returns a `Recipe`.
  - `list(maxMinutes: N)` excludes recipes with minutes > N.
  - `list(maxSpice: X)` excludes recipes with spice greater than X.

## Equality via JSON Round-trip
- Use: `jsonEncode(resp.toJson())` to assert deep equality of responses.
- This avoids ordering discrepancies in object keys and ensures canonical comparison.

## Ordering Notes
- Input ID arrays (`availableIds`, `missingIds`) are normalized (sorted) internally by the mock repository, so callers need not maintain order.
- The resulting `finalIngredients` preserve the recipe’s original ingredient order.

## Files Under Test
- `test/repository/recipe_repository_test.dart`
- `test/repository/substitution_repository_test.dart`

