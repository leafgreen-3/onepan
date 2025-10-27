## 0.1.0

- Added design tokens under `lib/theme/tokens.dart` (colors, typography, spacing, radii, elevations).
- Implemented light/dark `AppTheme` mapping tokens to `ThemeData` in `lib/theme/app_theme.dart`.
- Added unit tests in `test/theme_test.dart` to validate primary color, text sizes, and theme compilation.
- Next: wire `AppTheme.light()/dark()` into `MaterialApp` in `lib/app.dart` and update stub screens to use tokens (AppBars, Text styles, demo Chip/Button).

