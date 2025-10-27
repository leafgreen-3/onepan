import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/di/locator.dart';
import 'package:onepan/features/onboarding/onboarding_widgets.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';

class OnboardingCountryScreen extends ConsumerWidget {
  const OnboardingCountryScreen({super.key});

  static const _countries = <String>[
    'Europe',
    'Asia',
    'Americas',
    'Africa',
    'Oceania',
    'Middle East',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final canProceed = state.country != null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: AppElevation.e0,
        iconTheme: const IconThemeData(color: AppColors.onSurface),
        title: Text(
          'Step 1 of 3',
          style: AppTextStyles.label.copyWith(color: AppColors.onSurface),
        ),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                stepLabel: 'Country',
                title: 'Where are you cooking from?',
                subtitle: 'Pick your region to surface region-friendly recipes.',
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: SingleChildScrollView(
                  child: OptionGrid(
                    options: _countries,
                    selectedOption: state.country,
                    onSelected: controller.selectCountry,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryCTA(
                label: 'Next',
                onPressed: canProceed
                    ? () async {
                        if (state.country == null) {
                          return;
                        }
                        context.go(Routes.onboardingLevel);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
