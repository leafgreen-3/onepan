import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/di/locator.dart';
import 'package:onepan/features/onboarding/onboarding_widgets.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/features/onboarding/skill/skill_selector.dart';
import 'package:onepan/features/onboarding/skill/skill_provider.dart';
import 'package:onepan/features/onboarding/skill/skill_level.dart';

class OnboardingLevelScreen extends ConsumerStatefulWidget {
  const OnboardingLevelScreen({super.key});

  @override
  ConsumerState<OnboardingLevelScreen> createState() => _OnboardingLevelScreenState();
}

class _OnboardingLevelScreenState extends ConsumerState<OnboardingLevelScreen> {
  @override
  void initState() {
    super.initState();
    // Seed the skill selection from onboarding state if present.
    final current = ref.read(skillLevelProvider);
    if (current == null) {
      final st = ref.read(onboardingControllerProvider);
      final seed = st.skillLevel ?? _fromTitle(st.level);
      if (seed != null) {
        ref.read(skillLevelProvider.notifier).state = seed;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(onboardingControllerProvider.notifier);
    final selected = ref.watch(skillLevelProvider);
    final canProceed = selected != null;

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
              const Expanded(
                child: SingleChildScrollView(
                  child: SkillSelector(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryCTA(
                label: 'Next',
                onPressed: canProceed
                    ? () async {
                        final sel = ref.read(skillLevelProvider);
                        if (sel == null) return;
                        // Persist into onboarding controller for later steps.
                        controller.selectSkillLevel(sel);
                        controller.selectLevel(sel.title); // keep legacy string in sync
                        // Use push to retain back stack so BackButton works on Step 3.
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

SkillLevel? _fromTitle(String? title) {
  switch (title) {
    case 'Beginner':
      return SkillLevel.beginner;
    case 'Intermediate':
      return SkillLevel.intermediate;
    case 'Advanced':
      return SkillLevel.advanced;
    default:
      return null;
  }
}
