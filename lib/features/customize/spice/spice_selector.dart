import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/theme/tokens.dart';

import 'spice_level.dart';
import 'spice_provider.dart';

class SpiceSelector extends ConsumerWidget {
  const SpiceSelector({super.key, required this.recipeId});
  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spice = ref.watch(spiceLevelProvider(recipeId));
    final value = spice.index3.toDouble();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final tints = AppTints.of(context);
    final tint = switch (spice) {
      SpiceLevel.mild => tints.spiceMild,
      SpiceLevel.medium => tints.spiceMedium,
      SpiceLevel.spicy => tints.spiceSpicy,
    };
    final base = scheme.surfaceContainerLow;
    final bg = Color.alphaBlend(tint.withValues(alpha: 0.08), base);

    return Container(
      decoration: ShapeDecoration(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          // Optional thin outline could be added if desired:
          // side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              void updateFromDx(double dx) {
                const double pad = AppSpacing.lg;
                final double innerW = (constraints.maxWidth - 2 * pad).clamp(1, double.infinity);
                final double frac = ((dx - pad) / innerW).clamp(0.0, 1.0);
                final int idx = (frac * 2).round();
                final next = SpiceLevelX.fromIndex3(idx);
                if (next != spice) {
                  ref.read(spiceLevelProvider(recipeId).notifier).state = next;
                }
              }

              return Semantics(
                label: 'Spice level',
                value: spice.label,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: (d) => updateFromDx(d.localPosition.dx),
                  onTapUp: (_) => HapticFeedback.selectionClick(),
                  onHorizontalDragUpdate: (d) => updateFromDx(d.localPosition.dx),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: AppThickness.indicator,
                      activeTrackColor: scheme.primary,
                      inactiveTrackColor:
                          scheme.onSurface.withValues(alpha: AppOpacity.disabled),
                      activeTickMarkColor: scheme.primary,
                      inactiveTickMarkColor:
                          scheme.onSurface.withValues(alpha: AppOpacity.mediumText),
                      thumbColor: scheme.primary,
                      overlayColor:
                          scheme.primary.withValues(alpha: AppOpacity.focus),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: AppSizes.icon / 2,
                      ),
                    ),
                    child: Slider(
                      min: 0,
                      max: 2,
                      divisions: 2,
                      value: value,
                      onChanged: (v) {
                        final next = SpiceLevelX.fromIndex3(v.round());
                        if (next != spice) {
                          ref.read(spiceLevelProvider(recipeId).notifier).state = next;
                        }
                      },
                      // Keep end-haptic when dragging the thumb directly
                      onChangeEnd: (_) => HapticFeedback.selectionClick(),
                      semanticFormatterCallback: (v) =>
                          SpiceLevelX.fromIndex3(v.round()).label,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          _Labels(active: spice),
        ],
      ),
    );
  }
}

class _Labels extends StatelessWidget {
  const _Labels({required this.active});
  final SpiceLevel active;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).colorScheme.primary;

    TextStyle styleFor(SpiceLevel level) {
      final isActive = level == active;
      const base = AppTextStyles.label;
      return base.copyWith(
        fontWeight: isActive ? FontWeight.w700 : base.fontWeight,
        color: isActive
            ? primary
            : onSurface.withValues(alpha: AppOpacity.mediumText),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(SpiceLevel.mild.label, style: styleFor(SpiceLevel.mild)),
        Text(SpiceLevel.medium.label, style: styleFor(SpiceLevel.medium)),
        Text(SpiceLevel.spicy.label, style: styleFor(SpiceLevel.spicy)),
      ],
    );
  }
}
