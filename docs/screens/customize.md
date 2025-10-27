# Customize

## Overview
- Purpose: allow users to set default filters (Servings, Max Time, Spice tolerance) that drive recipe results on Home and subsequent screens.
- Scope: one primary CTA (Save) applies changes and returns to Home with filters active.

## User Flow
- Open Customize
- Adjust Servings / Max Time / Spice
- Preview result count updates (planned)
- Save
- Return to Home with filters applied to the recipe list

## UI & Interactions
- Controls
  - Servings: stepper or slider constrained to 1–12
  - Max Time: slider constrained to 1–240 minutes
  - Spice: segmented control with enum options [mild, medium, hot, inferno]
- Interactions
  - Save: primary button; disabled if no changes (planned)
  - Cancel/back: system back or secondary action discards changes
- Tokens (from `lib/theme/tokens.dart`)
  - Spacing: base spacing units for container padding and control gaps
  - Typography: titles/subtitles per heading/body scale
  - Colors: primary/accent for CTA; surface/background for containers; content on-contrast rules
- Edge states
  - Clamp input to min/max ranges
  - Disable Save if unchanged from persisted values (planned)
  - Show inline help text for out-of-range attempts (if applicable)

## State & Data
- Current implementation: `CustomizeScreen` is a placeholder StatelessWidget.
- Planned state: Riverpod provider or ViewModel holding servings/time/spice with immediate UI updates.
- Persistence: `SharedPreferences`-backed `PreferencesService` to read/write defaults.
- Mapping to filters: `mapCustomizeToFilter()` converts selections to repository filter params used on Home.

## Routing
- Path: `/customize`
- Defined in: `lib/router/routes.dart` and `lib/router/app_router.dart`
- Entry points: from Home via a Customize action (planned) or deep link

## File Locations
- Screen widget: `lib/features/customize/customize_screen.dart`
- Router config: `lib/router/app_router.dart`, `lib/router/routes.dart`
- Theme tokens: `lib/theme/tokens.dart`
- Planned
  - Preferences service: `lib/data/preferences/preferences_service.dart`
  - Provider/ViewModel: `lib/features/customize/customize_state.dart`
  - UI sub-widgets: `lib/features/customize/widgets/{labeled_slider.dart, spice_selector.dart}`

## Validation Rules
- Servings: integer 1–12; clamp in UI and re-validate in service layer
- Max Time: integer minutes 1–240; clamp in UI and re-validate in service layer
- Spice: enum one of [mild, medium, hot, inferno]

## Theming
- Primary CTA uses brand primary color and button style tokens
- Sliders/segmented control use component themes aligned to tokens (track height, active color, thumb radius)
- Layout respects spacing tokens for vertical rhythm and tap target spacing

## Accessibility
- Labels and semantics for each control with current value announced
- Minimum tap targets: 48x48 logical pixels
- Sufficient color contrast for text and controls in light/dark modes
- Keyboard/focus order and visible focus indicators for all interactive elements

## Testing Notes
- Widget tests (planned)
  - Adjusting controls updates on-screen values and preview count
  - Save persists selections via `PreferencesService`
  - Reopening screen restores last saved values
  - Save disabled when no changes
- Unit tests (planned)
  - `mapCustomizeToFilter()` maps values to expected repository parameters
  - `PreferencesService` handles read/write and error cases

## Future Enhancements
- Reset to defaults action
- Presets: Quick (<=20m), Family (servings 4–6), Spicy (spice>=hot)
- Inline dietary filters (e.g., vegetarian, gluten-free)
- Live results preview grid beneath controls
- Haptic feedback on control changes

