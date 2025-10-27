import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';

class AppSegment<T> {
  const AppSegment({required this.value, required this.label});
  final T value;
  final String label;
}

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
  }) : assert(segments.length >= 2 && segments.length <= 4);

  final List<AppSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppRadii.lg);
    final textStyle = Theme.of(context).textTheme.labelLarge!;

    return Semantics(
      toggled: true,
      container: true,
      child: Container(
        decoration: ShapeDecoration(
          color: scheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: scheme.outlineVariant),
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final itemWidth = width / segments.length;
            final index = segments.indexWhere((s) => s.value == value);

            return Stack(
              children: [
                AnimatedPositioned(
                  duration: AppDurations.normal,
                  curve: Curves.easeOut,
                  left: itemWidth * index,
                  width: itemWidth,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: scheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: radius,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (final segment in segments)
                      Expanded(
                        child: _SegmentButton<T>(
                          label: segment.label,
                          selected: segment.value == value,
                          onTap: () => onChanged(segment.value),
                          textStyle: textStyle,
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SegmentButton<T> extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.textStyle,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Container(
          alignment: Alignment.center,
          height: AppSizes.minTouchTarget,
          child: Text(
            label,
            style: textStyle.copyWith(
              color: selected
                  ? scheme.onPrimaryContainer
                  : scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
