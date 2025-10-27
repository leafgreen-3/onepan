# Architecture Shell

## Purpose
- Provide a clean foundation for navigation, DI, and feature growth.
- Enforce a central router and clear route contracts for the six MVP screens.

## Routing (go_router)
- Uses `MaterialApp.router` with a single `GoRouter` instance.
- Initial route: `/home` to support current tests.
- Routes:
  - `/onboarding` → OnboardingScreen
  - `/home` → HomeScreen
  - `/customize` → CustomizeScreen
  - `/ingredients` → IngredientsScreen
  - `/finalizer` → FinalizerScreen
  - `/recipe` → RecipeScreen

Key files
- `lib/app/app.dart` — App widget with `MaterialApp.router`
- `lib/router/app_router.dart` — `GoRouter` configuration
- `lib/router/routes.dart` — Route path constants
- `lib/main.dart` — App entrypoint

## DI Overview
Current
- Minimal DI placeholder via `lib/app/providers.dart`:
  - `AppDependencies` global constant to host shared services later.

Planned (drop-in)
- Use `get_it` or Riverpod for production DI/state:
  - Register repositories/services at startup.
  - Inject via constructor or providers.
- Example (get_it sketch):
  ```dart
  // import 'package:get_it/get_it.dart';
  final getIt = GetIt.instance;

  void setupDI() {
    // getIt.registerLazySingleton<RecipesRepository>(() => LocalRecipesRepository());
  }

  // Access in widget
  // final repo = getIt<RecipesRepository>();
  ```

## How To Add A New Screen (under 5 steps)
1) Create the screen widget
- Add `lib/features/<feature>/<feature>_screen.dart`.

2) Add a route constant
- In `lib/router/routes.dart`:
  ```dart
  static const details = '/details';
  ```

3) Register the route
- In `lib/router/app_router.dart`:
  ```dart
  GoRoute(
    path: Routes.details,
    name: 'details',
    builder: (context, state) => const DetailsScreen(),
  ),
  ```

4) Navigate to it
- From any widget:
  ```dart
  context.go(Routes.details);
  ```

5) Optional: Add a basic widget test
- Ensure the route renders the expected text.

## Relevant File Paths
- App: `lib/app/app.dart`
- Router: `lib/router/app_router.dart`
- Routes: `lib/router/routes.dart`
- Screens:
  - `lib/features/onboarding/onboarding_screen.dart`
  - `lib/features/home/home_screen.dart`
  - `lib/features/customize/customize_screen.dart`
  - `lib/features/ingredients/ingredients_screen.dart`
  - `lib/features/finalizer/finalizer_screen.dart`
  - `lib/features/recipe/recipe_screen.dart`
- DI: `lib/app/providers.dart`

