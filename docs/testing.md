# Testing Guide

This project uses three testing layers:

- Unit tests: Pure logic (controllers, models, repositories). Fast and deterministic.
- Widget tests: UI states, interactions, and navigation using a lightweight `WidgetTester` harness.
- Golden tests: Snapshot-based visual checks. Planned post‑MVP.

The Home Screen PR added both unit and widget tests that validate the four UI states (loading/empty/error/data), refresh/retry actions, navigation to recipe detail, and the favorite toggle behavior.

## How to run tests

- All tests: `flutter test`
- Single file: `flutter test test/features/home/home_screen_test.dart`
- By test name (exact match):
  - `flutter test --plain-name "data state renders one card and navigates to recipe detail"`
- With expanded reporter: `flutter test -r expanded`

Optional coverage:

- Generate coverage locally: `flutter test --coverage`
- The report is written to `coverage/lcov.info`. You can view it with tools like `genhtml` or IDE coverage plugins.

## Widget testing patterns

- Wrap apps in `ProviderScope` and `MaterialApp.router` or `MaterialApp` as needed. For navigation checks, use `GoRouter` with minimal routes.
- Prefer `pumpAndSettle()` after actions that trigger animations or navigation; use a plain `pump()` to advance a single frame after simple state changes.
- Provide stable finders using Keys (see conventions below) and avoid matching by free‑form text where duplicates may exist.

### Mocking data sources (mocktail)

We rely on a `RecipeRepository` abstraction and a global `get_it` locator:

```dart
class _MockRecipeRepository extends Mock implements RecipeRepository {}

setUp(() async {
  await GetIt.instance.reset();
  final repo = _MockRecipeRepository();
  GetIt.instance.registerSingleton<RecipeRepository>(repo);
});
```

This enables widget tests to control repository behavior without network or asset reads. For unit tests, instantiate controllers with the mock directly.

If a provider doesn’t use the locator, prefer Riverpod provider overrides:

```dart
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      myRepoProvider.overrideWithValue(mockRepo),
    ],
    child: MyApp(),
  ),
);
```

### Determinism and flake prevention

- Use `Completer` to hold a pending Future when you need to assert loading state:
  ```dart
  final completer = Completer<List<Recipe>>();
  when(() => repo.list()).thenAnswer((_) => completer.future);
  ```
- Avoid real timers or network. Everything should be synchronous or controlled Futures.
- After user interactions that cause navigation or async work, prefer `await tester.pumpAndSettle()`.
- Keep animations implicit; if needed, reduce motion by keeping interactions minimal in tests.

## Keys conventions

- Empty message: `Key('home_empty_message')`
- Refresh button: `Key('home_refresh_button')`
- Error message: `Key('home_error_message')`
- Retry button: `Key('home_retry_button')`
- Recipe card: `Key('recipe_card_<id>')`
- Favorite button: `Key('favorite_<id>')`
- Optional loading list/skeleton: `Key('home_loading_skeleton')`

These Keys are intended for test finders and must remain stable.

