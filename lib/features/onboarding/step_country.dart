import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/di/locator.dart';
import 'package:onepan/features/onboarding/onboarding_widgets.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';
// Country picker is navigated via go_router route; no direct import needed here.

class OnboardingCountryScreen extends ConsumerStatefulWidget {
  const OnboardingCountryScreen({super.key});

  @override
  ConsumerState<OnboardingCountryScreen> createState() => _OnboardingCountryScreenState();
}

class _OnboardingCountryScreenState extends ConsumerState<OnboardingCountryScreen> {
  bool _showValidationError = false;

  void _handleCountrySelected(String country) {
    ref.read(onboardingControllerProvider.notifier).selectCountry(country);
    setState(() {
      _showValidationError = false;
    });
  }

  void _handleMissingSelection() {
    if (_showValidationError) {
      return;
    }
    setState(() {
      _showValidationError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final canProceed = state.country != null && state.country!.isNotEmpty;

    final bodyChildren = <Widget>[
      const ExcludeSemantics(
        child: SectionHeader(
          stepLabel: 'Country',
          title: 'Where are you?',
          subtitle: 'We\'ll tailor defaults based on your location.',
        ),
      ),
      const SizedBox(height: AppSpacing.xl),
      _CountryField(
        value: state.country,
        onTap: () async {
          final selected = await context.push<String>(
            Routes.countryPicker,
            extra: state.country,
          );
          if (selected != null) {
            _handleCountrySelected(selected);
          }
        },
        showError: _showValidationError && !canProceed,
      ),
      if (_showValidationError && !canProceed) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Pick your country so we can personalise your recipes.',
          style: AppTextStyles.body.copyWith(color: AppColors.danger),
        ),
      ],
      const Spacer(),
      _buildPrimaryAction(context: context, canProceed: canProceed),
    ];

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
            children: bodyChildren,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryAction({required BuildContext context, required bool canProceed}) {
    final button = PrimaryCTA(
      label: 'Next',
      onPressed: canProceed
          ? () async {
              // Use push to retain back stack so BackButton works on Step 2.
              context.push(Routes.onboardingLevel);
            }
          : null,
    );

    if (canProceed) {
      return button;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleMissingSelection,
      child: AbsorbPointer(child: button),
    );
  }
}

class _CountryField extends StatelessWidget {
  const _CountryField({required this.value, required this.onTap, required this.showError});
  final String? value;
  final VoidCallback onTap;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    final borderColor = showError ? AppColors.danger : AppColors.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          container: true,
          label: 'Country',
          button: true,
          value: hasValue ? value : null,
          hint: hasValue ? null : 'Select your country',
          onTap: onTap,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadii.md),
            child: Container(
              decoration: ShapeDecoration(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  side: BorderSide(color: borderColor, width: AppThickness.hairline),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ExcludeSemantics(child: Text('Country', style: AppTextStyles.body)),
                        // Use labelStyle via Semantics label above; exclude from semantics here.
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          hasValue ? value! : 'Select your country',
                          style: AppTextStyles.body.copyWith(color: AppColors.onSurface),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.onSurface,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showError) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Please choose a country to continue.',
            style: AppTextStyles.body.copyWith(color: AppColors.danger),
          ),
        ],
      ],
    );
  }
}
