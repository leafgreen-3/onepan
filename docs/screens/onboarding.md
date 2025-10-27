# Onboarding

## Purpose
- Introduce OnePan, collect initial preferences, and set first-run state for future launches.

## User Flow
1) Launch app and see onboarding.
2) Set core preferences (time, servings, spice) — planned.
3) Continue to Home and mark onboarding complete.

## Technical Flow
- Route: `/onboarding` (go_router).
- Preferences: planned `SharedPreferences` key (e.g., `onboarding_completed = true`).
- First-run logic: if not completed, start at `/onboarding`; else go to `/home`.

Current Status
- Screen stub with title text.
- Router wiring in place.
- No preferences or first-run guard implemented yet.

## Relevant File Paths
- Screen: `lib/features/onboarding/onboarding_screen.dart`
- Router: `lib/router/app_router.dart`, `lib/router/routes.dart`

## How To Change Onboarding Behavior
- Update the widget in `lib/features/onboarding/onboarding_screen.dart`.
- Add preferences logic:
  - Write completion flag via `SharedPreferences`.
  - Add redirect in `GoRouter` (e.g., `redirect` callback) to send first-run users to `/onboarding`.
- Update tests to cover:
  - First run (onboarding shows).
  - Subsequent runs (home shows).

## Future Enhancements
- Persist onboarding completion to `SharedPreferences`.
- Capture and store preferences (time/servings/spice).
- Accessibility sizing and state handling per UI_Principles.md.
- Localized copy and illustrations.
- Analytics hooks (post-MVP).

