## [Unreleased]

- Added: Home Screen tests (loading/empty/error/data, refresh/retry, navigation, favorite toggle).

## 0.2.0

- Migrated to Recipe Schema v1 (data/models) and seed-backed repository (data/repositories).
- Added SeedLoader with aggregated validation and SeedLoadException; curated assets/recipes.json.
- Wired DI to provide v1 RecipeRepository via SeedRecipeRepository + SeedLoader.
- Quarantined legacy schema and tests using @Tags(['legacy']); CI excludes them.
- Updated Home to use v1 models; updated Recipe screen to Ingredient Picker first, with thumbnails and a Next button to Steps.
- Added focused tests for seed loader, seed repository, Home, and Recipe screen.

## 0.1.0

- Added design tokens under `lib/theme/tokens.dart` (colors, typography, spacing, radii, elevations).
- Implemented light/dark `AppTheme` mapping tokens to `ThemeData` in `lib/theme/app_theme.dart`.
- Added unit tests in `test/theme_test.dart` to validate primary color, text sizes, and theme compilation.
- Next: wire `AppTheme.light()/dark()` into `MaterialApp` in `lib/app.dart` and update stub screens to use tokens (AppBars, Text styles, demo Chip/Button).

