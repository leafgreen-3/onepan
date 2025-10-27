import 'package:flutter/material.dart';

/// Central design tokens for OnePan.
/// Strongly-typed constants – no magic numbers in widgets.
class AppColors {
  AppColors._();

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

