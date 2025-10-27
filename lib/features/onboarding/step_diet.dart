import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/di/locator.dart';
import 'package:onepan/features/onboarding/onboarding_widgets.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';

class OnboardingDietScreen extends ConsumerWidget {
  const OnboardingDietScreen({super.key});

  static const _diets = <String>[
    'Omnivore',
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Gluten-Free',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final canFinish = state.diet != null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: AppElevation.e0,
        iconTheme: const IconThemeData(color: AppColors.onSurface),
        title: Text(
          'Step 3 of 3',
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
                stepLabel: 'Diet',
                title: 'Any dietary preferences?',
                subtitle: 'We keep ingredient swaps aligned to your needs.',
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: SingleChildScrollView(
                  child: OptionGrid(
                    options: _diets,
                    selectedOption: state.diet,
                    onSelected: controller.selectDiet,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryCTA(
                label: 'Finish',
                onPressed: canFinish
                    ? () async {
                        if (state.diet == null) {
                          return;
                        }
                        await controller.complete();
                        if (!context.mounted) {
                          return;
                        }
                        context.go(Routes.home);
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
