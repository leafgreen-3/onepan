import 'dart:async';

import 'package:flutter/material.dart';

import 'package:onepan/theme/tokens.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.stepLabel,
    required this.title,
    required this.subtitle,
  });

  final String stepLabel;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stepLabel,
          style: AppTextStyles.label.copyWith(
            color: AppColors.onSurface.withValues(alpha: AppOpacity.mediumText),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          title,
          style: AppTextStyles.headline.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: AppTextStyles.body.copyWith(
            color: AppColors.onSurface.withValues(alpha: AppOpacity.mediumText),
          ),
        ),
      ],
    );
  }
}

enum OptionGridStyle { grid, segmented }

class OptionGrid extends StatelessWidget {
  const OptionGrid({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    this.style = OptionGridStyle.grid,
  });

  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String> onSelected;
  final OptionGridStyle style;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case OptionGridStyle.grid:
        return LayoutBuilder(
          builder: (context, constraints) {
            final canShowTwoColumns =
                constraints.maxWidth >= (AppSizes.minTouchTarget * 2) + AppSpacing.md;
            final itemWidth = canShowTwoColumns
                ? (constraints.maxWidth - AppSpacing.md) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: options
                  .map(
                    (option) => SizedBox(
                      width: itemWidth,
                      child: _OptionTile(
                        label: option,
                        selected: option == selectedOption,
                        onTap: () => onSelected(option),
                        centerLabel: false,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        );
      case OptionGridStyle.segmented:
        return Row(
          children: [
            for (var index = 0; index < options.length; index++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : AppSpacing.sm,
                    right: index == options.length - 1 ? 0 : AppSpacing.sm,
                  ),
                  child: _OptionTile(
                    label: options[index],
                    selected: options[index] == selectedOption,
                    onTap: () => onSelected(options[index]),
                    centerLabel: true,
                  ),
                ),
              ),
          ],
        );
    }
  }
}

class PrimaryCTA extends StatelessWidget {
  const PrimaryCTA({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed:
            onPressed == null ? null : () => unawaited(onPressed!.call()),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: AppTextStyles.title,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.centerLabel,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool centerLabel;

  @override
  Widget build(BuildContext context) {
    final baseStyle = selected ? AppTextStyles.title : AppTextStyles.body;
    final textStyle = baseStyle.copyWith(
      color: selected ? AppColors.onPrimary : AppColors.onSurface,
    );

    final backgroundColor = selected ? AppColors.primary : AppColors.surface;
    final borderColor = selected
        ? AppColors.primary
        : AppColors.onSurface.withValues(alpha: AppOpacity.hover);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.md),
          onTap: onTap,
          child: AnimatedContainer(
            duration: AppDurations.fast,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(
                color: borderColor,
                width: AppThickness.stroke,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSizes.minTouchTarget,
              ),
              child: Align(
                alignment:
                    centerLabel ? Alignment.center : Alignment.centerLeft,
                child: Text(label, textAlign: centerLabel ? TextAlign.center : TextAlign.start, style: textStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
