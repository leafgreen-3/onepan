import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';

enum AppChipVariant { selectable, filter }

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.enabled = true,
    this.onSelected,
    this.leading,
    this.variant = AppChipVariant.selectable,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final ValueChanged<bool>? onSelected;
  final Widget? leading;
  final AppChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = selected
        ? (variant == AppChipVariant.filter
            ? scheme.secondaryContainer
            : scheme.primaryContainer)
        : Theme.of(context).chipTheme.backgroundColor;
    final labelStyle = Theme.of(context).textTheme.labelLarge!;

    final sideColor = scheme.outlineVariant;

    final chip = Container(
      decoration: ShapeDecoration(
        color: enabled
            ? background
            : background!.withValues(alpha: AppOpacity.disabled),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          side: BorderSide(color: sideColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(label, style: labelStyle),
          if (selected)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: Icon(
                Icons.check_rounded,
                size: AppSizes.icon,
                color: _checkColor(scheme),
              ),
            ),
        ],
      ),
    );

    return Semantics(
      selected: selected,
      enabled: enabled,
      button: true,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.md),
        onTap: enabled && onSelected != null
            ? () => onSelected!(!selected)
            : null,
        child: chip,
      ),
    );
  }

  Color _checkColor(ColorScheme scheme) {
    return variant == AppChipVariant.filter
        ? scheme.onSecondaryContainer
        : scheme.onPrimaryContainer;
  }
}

