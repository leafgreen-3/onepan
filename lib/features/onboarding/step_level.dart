import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/di/locator.dart';
import 'package:onepan/features/onboarding/onboarding_widgets.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';

class OnboardingLevelScreen extends ConsumerWidget {
  const OnboardingLevelScreen({super.key});

  static const _levels = <String>[
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final canProceed = state.level != null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: AppElevation.e0,
        iconTheme: const IconThemeData(color: AppColors.onSurface),
        title: Text(
          'Step 2 of 3',
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
                stepLabel: 'Skill Level',
                title: 'How confident are you in the kitchen?',
                subtitle: 'We tune instructions and shortcuts to your comfort level.',
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: OptionGrid(
                    options: _levels,
                    selectedOption: state.level,
                    onSelected: controller.selectLevel,
                    style: OptionGridStyle.segmented,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryCTA(
                label: 'Next',
                onPressed: canProceed
                    ? () async {
                        if (state.level == null) {
                          return;
                        }
                        context.push(Routes.onboardingDiet);
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
