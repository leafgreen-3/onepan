import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:onepan/di/locator.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/app_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final preferences = ref.read(preferencesServiceProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: AppTextStyles.display.copyWith(
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Version 1.0.0',
                style: AppTextStyles.body.copyWith(
                  color: scheme.onSurface.withValues(
                    alpha: AppOpacity.mediumText,
                  ),
                ),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Reset onboarding',
                  variant: AppButtonVariant.tonal,
                  onPressed: () async {
                    // Clear persisted + in-memory state, then route to onboarding.
                    await preferences.clearOnboarding();
                    ref.read(onboardingControllerProvider.notifier).clear();
                    if (!context.mounted) return;
                    // Route directly to onboarding first step.
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    context.go(Routes.onboardingCountry);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
