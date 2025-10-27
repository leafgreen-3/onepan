import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:onepan/theme/app_theme.dart';
import 'package:onepan/theme/tokens.dart';

void main() {
  group('AppTheme', () {
    test('light theme compiles with expected primary color', () {
      final theme = AppTheme.light();
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.brightness, Brightness.light);
    });

    test('dark theme compiles with expected primary color', () {
      final theme = AppTheme.dark();
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.brightness, Brightness.dark);
    });

    test('text styles sizes match tokens', () {
      final light = AppTheme.light();
      final textTheme = light.textTheme;

      expect(textTheme.displayLarge!.fontSize, AppTextStyles.display.fontSize);
      expect(textTheme.headlineLarge!.fontSize, AppTextStyles.headline.fontSize);
      expect(textTheme.titleLarge!.fontSize, AppTextStyles.title.fontSize);
      expect(textTheme.bodyLarge!.fontSize, AppTextStyles.body.fontSize);
      expect(textTheme.labelLarge!.fontSize, AppTextStyles.label.fontSize);
    });
  });
}

