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
