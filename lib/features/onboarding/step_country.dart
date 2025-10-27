import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:onepan/features/onboarding/country_data.dart';
import 'package:onepan/di/locator.dart';
import 'package:onepan/features/onboarding/onboarding_widgets.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/app_dropdown.dart';

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
      const SectionHeader(
        stepLabel: 'Country',
        title: 'Where are you?',
        subtitle: 'We\'ll tailor defaults based on your location.',
      ),
      const SizedBox(height: AppSpacing.xl),
      AppDropdown(
        fieldKey: const ValueKey('country-dropdown'),
        label: 'Country',
        placeholder: 'Select your country',
        options: kCommonCountries,
        value: state.country,
        onChanged: _handleCountrySelected,
        errorText:
            _showValidationError && !canProceed ? 'Please choose a country to continue.' : null,
        semanticsLabel: 'Country',
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
