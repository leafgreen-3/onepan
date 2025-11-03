import 'package:flutter/material.dart';

/// Central design tokens for OnePan.
/// Strongly-typed constants – no magic numbers in widgets.
class AppColors {
  AppColors._();

  static AppColorsAccessor of(BuildContext context) => AppColorsAccessor(Theme.of(context).brightness);

  // Core palette
  static const Color primary = Color(0xFF3E7C59); // warm green
  static const Color onPrimary = Colors.white;

  static const Color surface = Color(0xFFF8F6F3); // warm off-white
  static const Color onSurface = Color(0xFF1F1D1B);

  // Status
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color danger = Color(0xFFC62828);

  // Spice heat scale accents
  static const Color spiceL = Color(0xFF81C784); // mild
  static const Color spiceM = Color(0xFFFFB74D); // medium
  static const Color spiceH = Color(0xFFEF5350); // hot

  // Dark mode surfaces
  static const Color surfaceDark = Color(0xFF151412);
  static const Color onSurfaceDark = Color(0xFFE9E6E1);
}

// Semantic AI accent colors for light theme.
class AppColorsLight {
  AppColorsLight._();

  static const Color aiAccent = Color(0xFFCC5146);
  static const Color onAiAccent = Color(0xFFFFFFFF);
}

// Semantic AI accent colors for dark theme.
class AppColorsDark {
  AppColorsDark._();

  static const Color aiAccent = Color(0xFFDC655B);
  static const Color onAiAccent = Color(0xFFFFFFFF);
}

// Access semantic tokens that depend on theme brightness.
class AppColorsAccessor {
  AppColorsAccessor(this.brightness);
  final Brightness brightness;

  Color get aiAccent => brightness == Brightness.dark
      ? AppColorsDark.aiAccent
      : AppColorsLight.aiAccent;
  Color get onAiAccent => brightness == Brightness.dark
      ? AppColorsDark.onAiAccent
      : AppColorsLight.onAiAccent;
}

class AppTextStyles {
  AppTextStyles._();

  // Sizes chosen for readability and hierarchy per UI principles
  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.2,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.2,
  );
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

class AppRadii {
  AppRadii._();

  static const double sm = 6.0;
  static const double md = 10.0;
  static const double lg = 16.0;
}

class AppElevation {
  AppElevation._();

  static const double e0 = 0.0;
  static const double e1 = 1.0;
  static const double e2 = 2.0;
  static const double e3 = 3.0;
}

/// Durations for animations and transitions.
class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration shimmerPeriod = Duration(milliseconds: 1200);
}

/// Opacity scales for visual states.
class AppOpacity {
  AppOpacity._();

  static const double disabled = 0.38;
  static const double focus = 0.12;
  static const double hover = 0.08;
  static const double mediumText = 0.80;
  static const double shimmerHighlight = 0.22;
  static const double max = 1.0;
}

/// Visual effects constants.
class AppEffects {
  AppEffects._();

  static const List<double> shimmerStops = [0.1, 0.3, 0.6];
  static const double shimmerTranslateStart = -1.0;
  static const double shimmerTranslateEnd = 2.0;
}

/// Common sizes and thickness tokens.
class AppSizes {
  AppSizes._();

  // Minimum interactive target per accessibility guidance.
  static const double minTouchTarget = 48.0;
  static const double icon = 24.0;
}

class AppThickness {
  AppThickness._();

  static const double hairline = 1.0;
  static const double indicator = 3.0;
  static const double stroke = 2.0;
}

