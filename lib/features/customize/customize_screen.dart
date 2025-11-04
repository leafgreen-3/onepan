import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:onepan/features/customize/customize_providers.dart';
import 'package:onepan/theme/tokens.dart';
import 'package:onepan/features/customize/spice/spice_selector.dart';
import 'package:onepan/features/customize/time/time_selector.dart';
import 'package:onepan/router/routes.dart';
import 'package:onepan/ui/atoms/app_button.dart';

class CustomizeScreen extends ConsumerWidget {
  const CustomizeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = GoRouterState.of(context).pathParameters['id']!;
    final model = ref.watch(customizeStateProvider(id));
    final ctrl = ref.read(customizeStateProvider(id).notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Customize'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
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

              // Time selection: stacked cards using per-recipe provider
              _SectionCard(
                title: 'Time',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      final scheme = Theme.of(context).colorScheme;
                      return Text(
                        'How would you like to prepare this recipe?',
                        style: AppTextStyles.body.copyWith(
                          color: scheme.onSurface
                              .withValues(alpha: AppOpacity.mediumText),
                        ),
                      );
                    }),
                    const SizedBox(height: AppSpacing.md),
                    TimeSelector(recipeId: id),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Spice level slider card (in-memory via provider)
              _SectionCard(
                title: 'Spice level',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      final scheme = Theme.of(context).colorScheme;
                      return Text(
                        "Choose how spicy you'd like this recipe to be.",
                        style: AppTextStyles.body.copyWith(
                          color: scheme.onSurface
                              .withValues(alpha: AppOpacity.mediumText),
                        ),
                      );
                    }),
                    const SizedBox(height: AppSpacing.md),
                    SpiceSelector(recipeId: id),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AnimatedPadding(
          duration: AppDurations.normal,
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.md,
            bottom: AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AppButton(
            key: const Key('customize_next'),
            label: 'Next',
            expand: true,
            onPressed: () {
              // Navigate to the ingredient picker with payload via extra
              context.push(
                '${Routes.ingredients}/$id',
                extra: {
                  'recipeId': id,
                  'customize': model,
                },
              );
            },
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

// Legacy time segmented control removed; replaced by TimeSelector.
