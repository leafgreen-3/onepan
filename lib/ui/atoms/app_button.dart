import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';

enum AppButtonVariant { filled, tonal, text }
enum AppButtonSize { md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.md,
    this.icon,
    this.loading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.labelLarge;

    final bool enabled = onPressed != null && !loading;
    final VoidCallback? effectiveOnPressed = enabled ? onPressed : null;

    final EdgeInsetsGeometry padding = switch (size) {
      AppButtonSize.md => const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      AppButtonSize.lg => const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.md),
    };

    const double minHeight = AppSizes.minTouchTarget;
    final BorderRadius radius = BorderRadius.circular(AppRadii.lg);

    final Widget content = AnimatedSwitcher(
      duration: AppDurations.fast,
      child: loading
          ? SizedBox(
              key: const ValueKey('spinner'),
              height: AppSizes.icon,
              width: AppSizes.icon,
              child: CircularProgressIndicator(
                strokeWidth: AppThickness.stroke,
                valueColor: AlwaysStoppedAnimation<Color>(_spinnerColor(scheme)),
              ),
            )
          : Row(
              key: const ValueKey('label'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(label, style: textStyle),
              ],
            ),
    );

    final ButtonStyle baseStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(minHeight, minHeight)),
      padding: WidgetStatePropertyAll(padding),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: radius),
      ),
      animationDuration: AppDurations.normal,
    );

    final Widget button = switch (variant) {
      AppButtonVariant.filled => FilledButton(
          onPressed: effectiveOnPressed,
          style: baseStyle.merge(
            ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return scheme.primary.withValues(alpha: AppOpacity.disabled);
                }
                return scheme.primary;
              }),
              foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
              elevation: const WidgetStatePropertyAll(AppElevation.e2),
            ),
          ),
          child: content,
        ),
      AppButtonVariant.tonal => FilledButton.tonal(
          onPressed: effectiveOnPressed,
          style: baseStyle.merge(
            ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(scheme.onPrimaryContainer),
            ),
          ),
          child: content,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          style: baseStyle.merge(
            ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(scheme.primary),
              overlayColor: WidgetStatePropertyAll(
                scheme.primary.withValues(alpha: AppOpacity.hover),
              ),
            ),
          ),
          child: content,
        ),
    };

    final Widget semanticsWrapped = Semantics(
      button: true,
      enabled: enabled,
      label: label,
      liveRegion: loading,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.minTouchTarget),
        child: expand ? SizedBox(width: double.infinity, child: button) : button,
      ),
    );

    return semanticsWrapped;
  }

  Color _spinnerColor(ColorScheme scheme) {
    switch (variant) {
      case AppButtonVariant.filled:
        return scheme.onPrimary;
      case AppButtonVariant.tonal:
        return scheme.onPrimaryContainer;
      case AppButtonVariant.text:
        return scheme.primary;
    }
  }
}
