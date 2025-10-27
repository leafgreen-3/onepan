import 'package:flutter/material.dart';

import 'tokens.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.spiceM,
      onSecondary: AppColors.onSurface,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.danger,
      onError: Colors.white,
      tertiary: AppColors.success,
      onTertiary: Colors.white,
      surfaceContainerHighest: AppColors.surface.withValues(alpha: 0.96),
      surfaceContainerHigh: AppColors.surface.withValues(alpha: 0.92),
      surfaceContainer: AppColors.surface.withValues(alpha: 0.88),
      surfaceContainerLow: AppColors.surface.withValues(alpha: 0.84),
      surfaceContainerLowest: AppColors.surface.withValues(alpha: 0.80),
      outline: AppColors.onSurface.withValues(alpha: 0.12),
      outlineVariant: AppColors.onSurface.withValues(alpha: 0.06),
      primaryContainer: AppColors.primary.withValues(alpha: 0.12),
      onPrimaryContainer: AppColors.primary,
      secondaryContainer: AppColors.spiceM.withValues(alpha: 0.12),
      onSecondaryContainer: AppColors.onSurface,
      surfaceTint: AppColors.primary,
      inverseSurface: AppColors.onSurface,
      inversePrimary: AppColors.onPrimary,
      scrim: Colors.black.withValues(alpha: 0.54),
      shadow: Colors.black.withValues(alpha: 0.24),
    );

    final textTheme = _textTheme(baseColor: colorScheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: AppElevation.e0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.title.copyWith(color: colorScheme.onSurface),
      ),
      chipTheme: _chipTheme(colorScheme, isDark: false),
      filledButtonTheme: _filledButtonTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      sliderTheme: _sliderTheme(colorScheme),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: AppElevation.e1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: AppSpacing.lg,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: AppTextStyles.body.copyWith(color: colorScheme.surface),
        actionTextColor: colorScheme.secondary,
        elevation: AppElevation.e2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.spiceM,
      onSecondary: AppColors.onSurfaceDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      error: AppColors.danger,
      onError: Colors.white,
      tertiary: AppColors.success,
      onTertiary: Colors.white,
      surfaceContainerHighest: AppColors.surfaceDark.withValues(alpha: 0.98),
      surfaceContainerHigh: AppColors.surfaceDark.withValues(alpha: 0.94),
      surfaceContainer: AppColors.surfaceDark.withValues(alpha: 0.90),
      surfaceContainerLow: AppColors.surfaceDark.withValues(alpha: 0.86),
      surfaceContainerLowest: AppColors.surfaceDark.withValues(alpha: 0.82),
      outline: AppColors.onSurfaceDark.withValues(alpha: 0.16),
      outlineVariant: AppColors.onSurfaceDark.withValues(alpha: 0.10),
      primaryContainer: AppColors.primary.withValues(alpha: 0.24),
      onPrimaryContainer: AppColors.onPrimary,
      secondaryContainer: AppColors.spiceM.withValues(alpha: 0.20),
      onSecondaryContainer: AppColors.onSurfaceDark,
      surfaceTint: AppColors.primary,
      inverseSurface: AppColors.surface,
      inversePrimary: AppColors.primary,
      scrim: Colors.black.withValues(alpha: 0.64),
      shadow: Colors.black.withValues(alpha: 0.50),
    );

    final textTheme = _textTheme(baseColor: colorScheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: AppElevation.e0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.title.copyWith(color: colorScheme.onSurface),
      ),
      chipTheme: _chipTheme(colorScheme, isDark: true),
      filledButtonTheme: _filledButtonTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      sliderTheme: _sliderTheme(colorScheme),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        elevation: AppElevation.e1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: AppSpacing.lg,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: AppTextStyles.body.copyWith(color: colorScheme.surface),
        actionTextColor: colorScheme.secondary,
        elevation: AppElevation.e2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
    );
  }

  static TextTheme _textTheme({required Color baseColor}) {
    return TextTheme(
      displayLarge: AppTextStyles.display.copyWith(color: baseColor),
      displayMedium: AppTextStyles.display.copyWith(color: baseColor),
      displaySmall: AppTextStyles.headline.copyWith(color: baseColor),
      headlineLarge: AppTextStyles.headline.copyWith(color: baseColor),
      headlineMedium: AppTextStyles.title.copyWith(color: baseColor),
      headlineSmall: AppTextStyles.title.copyWith(color: baseColor),
      titleLarge: AppTextStyles.title.copyWith(color: baseColor),
      titleMedium: AppTextStyles.body.copyWith(color: baseColor, fontWeight: FontWeight.w600),
      titleSmall: AppTextStyles.label.copyWith(color: baseColor),
      bodyLarge: AppTextStyles.body.copyWith(color: baseColor),
      bodyMedium: AppTextStyles.body.copyWith(color: baseColor),
      bodySmall: AppTextStyles.label.copyWith(color: baseColor.withValues(alpha: 0.8)),
      labelLarge: AppTextStyles.label.copyWith(color: baseColor),
      labelMedium: AppTextStyles.label.copyWith(color: baseColor.withValues(alpha: 0.9), fontSize: 12),
      labelSmall: AppTextStyles.label.copyWith(color: baseColor.withValues(alpha: 0.8), fontSize: 11),
    );
  }

  static ChipThemeData _chipTheme(ColorScheme scheme, {required bool isDark}) {
    return ChipThemeData(
      labelStyle: AppTextStyles.label.copyWith(color: scheme.onSurface),
      backgroundColor: isDark ? scheme.surfaceContainerLow : scheme.surface,
      selectedColor: scheme.primaryContainer,
      secondarySelectedColor: scheme.secondaryContainer,
      checkmarkColor: scheme.onPrimary,
      side: BorderSide(color: scheme.outlineVariant),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
    );
  }

  static FilledButtonThemeData _filledButtonTheme(ColorScheme scheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
        textStyle: AppTextStyles.label,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        elevation: AppElevation.e1,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme scheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.secondary,
        foregroundColor: scheme.onSecondary,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        textStyle: AppTextStyles.label,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        elevation: AppElevation.e2,
      ),
    );
  }

  static SliderThemeData _sliderTheme(ColorScheme scheme) {
    return SliderThemeData(
      activeTrackColor: scheme.primary,
      inactiveTrackColor: scheme.outlineVariant,
      thumbColor: scheme.primary,
      overlayColor: scheme.primary.withValues(alpha: 0.12),
      valueIndicatorColor: scheme.primary,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
    );
  }
}
