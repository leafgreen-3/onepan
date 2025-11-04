import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/theme/tokens.dart';

import 'skill_level.dart';
import 'skill_provider.dart';

class SkillSelector extends ConsumerWidget {
  const SkillSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(skillLevelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          child: _SkillCard(
            key: const Key('skill_beginner'),
            level: SkillLevel.beginner,
            selected: current == SkillLevel.beginner,
            onSelect: () {
              if (current != SkillLevel.beginner) {
                ref.read(skillLevelProvider.notifier).state = SkillLevel.beginner;
                HapticFeedback.selectionClick();
              }
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: _SkillCard(
            key: const Key('skill_intermediate'),
            level: SkillLevel.intermediate,
            selected: current == SkillLevel.intermediate,
            onSelect: () {
              if (current != SkillLevel.intermediate) {
                ref.read(skillLevelProvider.notifier).state = SkillLevel.intermediate;
                HapticFeedback.selectionClick();
              }
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: _SkillCard(
            key: const Key('skill_advanced'),
            level: SkillLevel.advanced,
            selected: current == SkillLevel.advanced,
            onSelect: () {
              if (current != SkillLevel.advanced) {
                ref.read(skillLevelProvider.notifier).state = SkillLevel.advanced;
                HapticFeedback.selectionClick();
              }
            },
          ),
        ),
      ],
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({super.key, required this.level, required this.selected, required this.onSelect});
  final SkillLevel level;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final base = scheme.surfaceContainerLow;
    final tint = scheme.primary.withValues(alpha: 0.06);
    final bg = selected ? Color.alphaBlend(tint, base) : base;
    final borderColor = selected ? scheme.primary : scheme.outlineVariant;

    final titleStyle = AppTextStyles.title.copyWith(
      color: scheme.onSurface,
      fontWeight: selected ? FontWeight.w700 : AppTextStyles.title.fontWeight,
    );
    final subtitleStyle = AppTextStyles.body.copyWith(
      color: scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
    );

    return Semantics(
      selected: selected,
      button: true,
      label: level.title,
      hint: level.subtitle,
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
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(level.title, style: titleStyle, textAlign: TextAlign.left),
                const SizedBox(height: AppSpacing.xs),
                Text(level.subtitle, style: subtitleStyle, textAlign: TextAlign.left),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
