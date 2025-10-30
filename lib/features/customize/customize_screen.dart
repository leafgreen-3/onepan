import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:onepan/features/customize/customize_providers.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/ui/atoms/app_button.dart';

class CustomizeScreen extends ConsumerWidget {
  const CustomizeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = GoRouterState.of(context).pathParameters['id']!;
    final model = ref.watch(customizeStateProvider(id));
    final ctrl = ref.read(customizeStateProvider(id).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionCard(
                title: 'Servings',
                child: _ServingsStepper(
                  value: model.servings,
                  onDec: () => ctrl.setServings(model.servings - 1),
                  onInc: () => ctrl.setServings(model.servings + 1),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Time segmented (Regular on the left, Fast on the right)
              _SectionCard(
                title: 'Time',
                child: _TimeSegmented(
                  value: model.time,
                  onSelect: (t) => ctrl.setTime(t),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Spice segmented with emoji and heat colors
              _SectionCard(
                title: 'Spice',
                child: _SpiceSegmented(
                  value: model.spice,
                  onSelect: (s) => ctrl.setSpice(s),
                ),
              ),

              const Spacer(),

              AppButton(
                key: const Key('customize_next'),
                label: 'Next',
                expand: true,
                onPressed: () {
                  // Navigate to the original ingredient picker screen (Recipe)
                  context.push('/recipe/$id');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      elevation: AppElevation.e1,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.title.copyWith(color: scheme.onSurface)),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}

class _ServingsStepper extends StatelessWidget {
  const _ServingsStepper({
    required this.value,
    required this.onDec,
    required this.onInc,
  });

  final int value;
  final VoidCallback onDec;
  final VoidCallback onInc;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        _BigIconButton(
          key: const Key('servings_dec'),
          icon: Icons.remove,
          onTap: onDec,
        ),
        Expanded(
          child: Center(
            child: Text(
              '$value',
              key: const Key('servings_value'),
              style: AppTextStyles.display.copyWith(color: scheme.onSurface),
            ),
          ),
        ),
        _BigIconButton(
          key: const Key('servings_inc'),
          icon: Icons.add,
          onTap: onInc,
        ),
      ],
    );
  }
}

class _BigIconButton extends StatelessWidget {
  const _BigIconButton({super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: Container(
        width: AppSizes.minTouchTarget,
        height: AppSizes.minTouchTarget,
        decoration: ShapeDecoration(
          color: scheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
            side: BorderSide(color: scheme.outlineVariant),
          ),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: AppSizes.icon, color: scheme.onSurface),
      ),
    );
  }
}

class _TimeSegmented extends StatelessWidget {
  const _TimeSegmented({required this.value, required this.onSelect});
  final String value; // 'regular' | 'fast'
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadii.lg);
    final selectedIndex = value == 'fast' ? 1 : 0;

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final segW = w / 2;
      return Container(
        decoration: ShapeDecoration(
          color: scheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: scheme.outlineVariant),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.xs),
        height: AppSizes.minTouchTarget,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: AppDurations.normal,
              curve: Curves.easeOut,
              left: segW * selectedIndex,
              width: segW,
              top: 0,
              bottom: 0,
              child: Container(
                decoration: ShapeDecoration(
                  color: scheme.primaryContainer,
                  shape: RoundedRectangleBorder(borderRadius: radius),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    key: const Key('time_regular'),
                    onTap: () => onSelect('regular'),
                    borderRadius: radius,
                    child: Center(
                      child: Text(
                        '⏳ Regular',
                        style: AppTextStyles.label.copyWith(
                          color: selectedIndex == 0
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    key: const Key('time_fast'),
                    onTap: () => onSelect('fast'),
                    borderRadius: radius,
                    child: Center(
                      child: Text(
                        '⚡ Fast',
                        style: AppTextStyles.label.copyWith(
                          color: selectedIndex == 1
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _SpiceSegmented extends StatelessWidget {
  const _SpiceSegmented({required this.value, required this.onSelect});
  final String value; // 'mild' | 'medium' | 'spicy'
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadii.lg);
    final index = switch (value) {
      'mild' => 0,
      'spicy' => 2,
      _ => 1,
    };
    final color = switch (value) {
      'mild' => AppColors.spiceL,
      'spicy' => AppColors.spiceH,
      _ => AppColors.spiceM,
    };

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final segW = w / 3;
      return Container(
        decoration: ShapeDecoration(
          color: scheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: scheme.outlineVariant),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.xs),
        height: AppSizes.minTouchTarget,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: AppDurations.normal,
              curve: Curves.easeOut,
              left: segW * index,
              width: segW,
              top: 0,
              bottom: 0,
              child: Container(
                decoration: ShapeDecoration(
                  color: color,
                  shape: RoundedRectangleBorder(borderRadius: radius),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    key: const Key('spice_mild'),
                    onTap: () => onSelect('mild'),
                    borderRadius: radius,
                    child: Center(
                      child: Text(
                        'Mild 🌶️',
                        style: AppTextStyles.label.copyWith(
                          color: index == 0
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    key: const Key('spice_medium'),
                    onTap: () => onSelect('medium'),
                    borderRadius: radius,
                    child: Center(
                      child: Text(
                        'Medium 🌶️🌶️',
                        style: AppTextStyles.label.copyWith(
                          color: index == 1
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    key: const Key('spice_spicy'),
                    onTap: () => onSelect('spicy'),
                    borderRadius: radius,
                    child: Center(
                      child: Text(
                        'Spicy 🌶️🌶️🌶️',
                        style: AppTextStyles.label.copyWith(
                          color: index == 2
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

