import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/theme/tokens.dart';

import 'time_mode.dart';
import 'time_provider.dart';

class TimeSelector extends ConsumerWidget {
  const TimeSelector({super.key, required this.recipeId});
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(timeModeProvider(recipeId));

    return Column(
      children: [
        _TimeCard(
          key: const Key('time_regular'),
          mode: TimeMode.regular,
          selected: current == TimeMode.regular,
          onSelect: () {
            if (current != TimeMode.regular) {
              ref.read(timeModeProvider(recipeId).notifier).state = TimeMode.regular;
              HapticFeedback.selectionClick();
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _TimeCard(
          key: const Key('time_fast'),
          mode: TimeMode.fast,
          selected: current == TimeMode.fast,
          onSelect: () {
            if (current != TimeMode.fast) {
              ref.read(timeModeProvider(recipeId).notifier).state = TimeMode.fast;
              HapticFeedback.selectionClick();
            }
          },
        ),
      ],
    );
  }
}

class _TimeCard extends StatelessWidget {
  const _TimeCard({super.key, required this.mode, required this.selected, required this.onSelect});
  final TimeMode mode;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final base = scheme.surfaceContainerLow;
    final tint = scheme.primary.withValues(alpha: 0.06);
    final bg = selected ? Color.alphaBlend(tint, base) : base;
    final borderColor = selected ? scheme.primary : scheme.outlineVariant;

    return Semantics(
      selected: selected,
      button: true,
      label: '${mode.title} time',
      hint: mode.subtitle,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          splashColor: scheme.primary.withValues(alpha: AppOpacity.hover),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            curve: Curves.easeOut,
            decoration: ShapeDecoration(
              color: bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                side: BorderSide(color: borderColor, width: AppThickness.hairline),
              ),
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(mode.icon, style: AppTextStyles.title),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      mode.title,
                      style: AppTextStyles.title.copyWith(color: scheme.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  mode.subtitle,
                  style: AppTextStyles.body.copyWith(
                    color: scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

