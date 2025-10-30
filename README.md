# OnePan

A minimal Flutter application skeleton for the OnePan project.

## Getting Started

Run the following to set up and verify locally:

```sh
flutter pub get
flutter analyze
flutter test --exclude-tags=legacy
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
- `/recipe/:id` -> RecipeScreen

Dependencies
- Routing: `go_router`
- DI: Minimal `AppDependencies` placeholder. Swappable with Riverpod/get_it later.

Screenshot/GIF
- [Placeholder: architecture-shell.png]

## Data Layer (Schema v1)

- Seeds & Loader � Curated seed recipes live in assets/recipes.json for fast, deterministic development. They validate against Schema v1 models in lib/data/models/* when loaded through the seed loader, which aggregates per-item validation errors with indices.
  - Models (v1): lib/data/models/{recipe.dart, ingredient.dart, step.dart}
  - Loader: lib/data/sources/local/seed_loader.dart
  - Seed JSON: assets/recipes.json

### Repositories
- RecipeRepository (seed-backed, v1)
  - Interface: lib/data/repositories/recipe_repository.dart
  - Impl: lib/data/repositories/seed_recipe_repository.dart (loads once; sorts by timeTotalMin then title; filters by diet and timeMode fast/regular).
- Legacy substitution mock remains under lib/repository/* and is tagged for removal post-MVP.

UI depends on these interfaces via DI and is source-agnostic. Repositories are registered in lib/di/locator.dart and consumed via locator<Interface>() or Riverpod providers.

### Viewing seeds in the app
- Complete onboarding (Country -> Level -> Diet) to reach Home.
- Tap a recipe card to open the Ingredient Picker.
- Ingredient Picker shows a thumbnail, name, quantity, and a checkbox per ingredient, plus a Next button to Steps.## Component Library

OnePan ships a small, token-only component library for building consistent UI quickly. All atoms use design tokens from `lib/theme/tokens.dart` and colors/typography from the active `ThemeData` — no raw numbers or hex values inside widgets.

Atoms available
- Button (`AppButton`) — filled/tonal/text variants; md/lg sizes; loading/disabled
- Card (`AppCard`) — token paddings, optional header/media/footer, elevation
- Chip (`AppChip`) — selectable/filter styles; selected/disabled states
- ChecklistTile (`ChecklistTile`) — leading icon area, title/subtitle, trailing checkbox
- SegmentedControl (`AppSegmentedControl`) — 2–4 options with animated thumb
- Tabs (`AppTabs`) — primary tabs with tokenized indicator
- Skeleton (`AppSkeleton`) — rectangular/circular shimmer placeholders

Docs and demo
- Full API and usage: `docs/ui/components.md`
- Dev demo route: `/dev/components` (open in the running app to see variants and states)

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

## Onboarding (3 steps)

Note: Country uses a dropdown — a familiar pattern with large touch targets.

What it does
- Guides first-time users through Country → Level → Diet selections using a single primary CTA on each screen.
- Captures choices with Riverpod state and persists them to `SharedPreferences` so the flow only runs once per user.
- Redirects completed users straight to Home on subsequent launches via the go_router startup guard.

Where the code lives
- Step screens: `lib/features/onboarding/step_country.dart`, `lib/features/onboarding/step_level.dart`, `lib/features/onboarding/step_diet.dart`
- Shared widgets: `lib/features/onboarding/onboarding_widgets.dart`
- State & persistence: `lib/app/state/onboarding_state.dart`, `lib/app/services/preferences_service.dart`
- Routing: `lib/router/app_router.dart`, `lib/router/routes.dart`

How it fits
- Fulfills the onboarding portion of the six-screen MVP flow before delivering personalized recipes on Home.
- Stores core dietary preferences that downstream features can read without re-prompting the user.
- Uses the same design tokens as the rest of the app to stay visually consistent and accessible.

Dependencies
- State: `riverpod`
- Persistence: `shared_preferences`
- Routing: `go_router`

Screenshot/GIF
- [Placeholder: onboarding-country.png]
- [Placeholder: onboarding-level.png]
- [Placeholder: onboarding-diet.png]



