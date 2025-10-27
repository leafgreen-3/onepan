# Onboarding (Country → Level → Diet)

## Overview & Rationale
- First-run funnel that gathers the minimum preferences needed to personalize OnePan recommendations.
- Keeps the experience focused: three lightweight decisions that influence recipe surfaces without overwhelming the user.
- Runs once per install unless preferences are cleared, thanks to SharedPreferences-backed persistence.

## Steps & UI Rules
1. **Country** — grid of regional chips; select exactly one to continue.
2. **Level** — segmented control for Beginner, Intermediate, Advanced.
3. **Diet** — checklist-style chips for Omnivore, Vegetarian, Vegan, Pescatarian, and Gluten-Free.

Design constraints
- Token-only spacing, typography, radii, colors, and elevation (no raw values).
- One primary CTA per screen (“Next” or “Finish”), disabled until a selection exists.
- Touch targets ≥48dp achieved through tokenized padding in `OptionGrid` and CTA widgets.
- Back navigation via AppBar leading icon; selection states expose semantics for accessibility.

## State & Persistence
- **OnboardingController** (`lib/app/state/onboarding_state.dart`) stores in-progress selections with a Riverpod `StateNotifier`.
- **PreferencesService** (`lib/app/services/preferences_service.dart`) persists `country`, `level`, `diet`, and `onboarding.complete` keys to `SharedPreferences`.
- `complete()` validates that all selections exist, saves them, and marks onboarding complete for future launches.

### Preference Keys
- `onboarding.country`
- `onboarding.level`
- `onboarding.diet`
- `onboarding.complete`

## Routing
- `go_router` startup redirect reads the `OnboardingController` state (restored from `PreferencesService`) before resolving the initial route.
- First-run users start at `/onboarding/country`, progress through `/onboarding/level` and `/onboarding/diet`, then land on `/home` after completion.
- Returning users bypass onboarding entirely and load `/home` immediately.

## How to Test
- Inject a mocked `PreferencesService` via provider overrides to simulate stored values.
- Pump each onboarding step widget with Riverpod test harness to verify CTA enablement, semantics, and navigation callbacks.
- Verify redirect logic by seeding the `OnboardingController` state (complete/incomplete) and asserting the initial location.

## File Locations
- `lib/app/services/preferences_service.dart`
- `lib/app/state/onboarding_state.dart`
- `lib/di/locator.dart`
- `lib/router/app_router.dart`
- `lib/features/onboarding/onboarding_widgets.dart`
- `lib/features/onboarding/step_country.dart`
- `lib/features/onboarding/step_level.dart`
- `lib/features/onboarding/step_diet.dart`

## Future Enhancements
- Add “Skip for now” affordance with persistence toggle.
- Surface an “Edit preferences” entry in Settings/Home once flows exist.
- Localize copy and diversify imagery post-MVP.

