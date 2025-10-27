# OnePan

A minimal Flutter application skeleton for the OnePan project.

## Getting Started

Run the following to set up and verify locally:

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

## Architecture Shell (Issue #1)

What it does
- Establishes app entry, routing, and six MVP route stubs.
- Uses go_router with MaterialApp.router.
- Provides a minimal DI surface for future services.

Where the code lives
- App entry: `lib/main.dart`
- App widget: `lib/app/app.dart`
- Router config: `lib/router/app_router.dart`
- Route constants: `lib/router/routes.dart`
- Screen stubs:
  - `lib/features/onboarding/onboarding_screen.dart`
  - `lib/features/home/home_screen.dart`
  - `lib/features/customize/customize_screen.dart`
  - `lib/features/ingredients/ingredients_screen.dart`
  - `lib/features/finalizer/finalizer_screen.dart`
  - `lib/features/recipe/recipe_screen.dart`
- DI placeholder: `lib/app/providers.dart`

How it fits
- Forms the backbone of the 6-screen MVP flow defined in Project_Plan.md.
- Keeps navigation decoupled via route constants and a central router.
- Preps DI for swappable repositories and services.

Routes (go_router)
- `/onboarding` → OnboardingScreen
- `/home` → HomeScreen (initial route)
- `/customize` → CustomizeScreen
- `/ingredients` → IngredientsScreen
- `/finalizer` → FinalizerScreen
- `/recipe` → RecipeScreen

Dependencies
- Routing: `go_router`
- DI: Minimal `AppDependencies` placeholder. Swappable with Riverpod/get_it later.

Screenshot/GIF
- [Placeholder: architecture-shell.png]

## Data Layer

- Seeds & Loader — Curated seed recipes live in `assets/recipes.json` for fast, deterministic development. They validate against Schema v1 (`lib/models/recipe.dart`) when loaded through the loader utility, which aggregates per-item validation errors with indices. A tiny dev list/detail flow exists to preview this data end-to-end without the full UI. See docs for details:
  - docs/data/seeds_and_loader.md
  - docs/dev/seed_preview_routes.md

## Customize

What it does
- Lets users set default filters for Servings, Max Time, and Spice tolerance.
- Used from the main flow to tailor results before browsing; saved values influence Home results by constraining repository queries.
- Applies design tokens for spacing/typography/colors and persists selections as user preferences.

Dependencies
- Design tokens: `lib/theme/tokens.dart`
- Repository filtering: maps selections to query params for recipe data sources
- Preferences storage: planned `SharedPreferences` service for persistence

Screenshot/GIF
- [Placeholder: customize-screen.png]

Full doc
- See `docs/screens/customize.md` for flow, UI, state, routing, and testing notes.

## Onboarding (Issue #2)

What it does
- Adds an Onboarding screen stub wired into routing.
- Serves as the first step in the 6-screen flow, to be expanded with preferences and first-run logic.

Where the code lives
- Screen: `lib/features/onboarding/onboarding_screen.dart`
- Route: `/onboarding` in `lib/router/app_router.dart` and `lib/router/routes.dart`

How it fits
- Entry point for user setup before browsing and customizing recipes.
- Will set initial preferences (time, servings, spice) and mark onboarding as complete for future launches.

Dependencies
- Routing: `go_router`
- Planned: `SharedPreferences` for first-run flag and onboarding completion state

Screenshot/GIF
- [Placeholder: onboarding-screen.png]
