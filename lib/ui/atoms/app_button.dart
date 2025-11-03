import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';

enum AppButtonVariant { filled, tonal, text }
enum AppButtonRole { primary, danger, aiAccent }
enum AppButtonSize { md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.role = AppButtonRole.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.loading = false,
    this.expand = false,
    this.minHeight,
    this.radius,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonRole role;
  final AppButtonSize size;
  final Widget? icon;
  final bool loading;
  final bool expand;
  final double? minHeight;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Color labelColor;
    switch (variant) {
      case AppButtonVariant.filled:
        labelColor = switch (role) {
          AppButtonRole.aiAccent => AppColors.of(context).onAiAccent,
          _ => scheme.onPrimary,
        };
        break;
      case AppButtonVariant.tonal:
        labelColor = scheme.onPrimaryContainer;
        break;
      case AppButtonVariant.text:
        labelColor = scheme.primary;
        break;
    }
    final TextStyle textStyle = AppTextStyles.label.copyWith(color: labelColor);

    final bool enabled = onPressed != null && !loading;
    final VoidCallback? effectiveOnPressed = enabled ? onPressed : null;

    final EdgeInsetsGeometry padding = switch (size) {
      AppButtonSize.md => const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      AppButtonSize.lg => const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.md),
    };

    final double minH = minHeight ?? AppSizes.minTouchTarget;
    final BorderRadius r = BorderRadius.circular(radius ?? AppRadii.lg);

    final Widget content = AnimatedSwitcher(
      duration: AppDurations.fast,
      child: loading
          ? SizedBox(
              key: const ValueKey('spinner'),
              height: AppSizes.icon,
              width: AppSizes.icon,
              child: CircularProgressIndicator(
                strokeWidth: AppThickness.stroke,
                valueColor:
                    AlwaysStoppedAnimation<Color>(_spinnerColor(context, scheme)),
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
      minimumSize: WidgetStatePropertyAll(Size(minH, minH)),
      padding: WidgetStatePropertyAll(padding),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: r),
      ),
      animationDuration: AppDurations.normal,
    );

    final Widget button = switch (variant) {
      AppButtonVariant.filled => FilledButton(
          onPressed: effectiveOnPressed,
          style: baseStyle.merge(
            ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                Color base = switch (role) {
                  AppButtonRole.aiAccent => AppColors.of(context).aiAccent,
                  _ => scheme.primary,
                };
                if (states.contains(WidgetState.disabled)) {
                  return base.withValues(alpha: AppOpacity.disabled);
                }
                return base;
              }),
              foregroundColor: WidgetStatePropertyAll(labelColor),
              overlayColor: WidgetStateProperty.resolveWith((states) {
                final Color fg = role == AppButtonRole.aiAccent
                    ? AppColors.of(context).onAiAccent
                    : scheme.onPrimary;
                if (states.contains(WidgetState.pressed) ||
                    states.contains(WidgetState.focused)) {
                  return fg.withValues(alpha: AppOpacity.focus);
                }
                if (states.contains(WidgetState.hovered)) {
                  return fg.withValues(alpha: AppOpacity.hover);
                }
                return null;
              }),
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

  Color _spinnerColor(BuildContext context, ColorScheme scheme) {
    switch (variant) {
      case AppButtonVariant.filled:
        return role == AppButtonRole.aiAccent
            ? AppColors.of(context).onAiAccent
            : scheme.onPrimary;
      case AppButtonVariant.tonal:
        return scheme.onPrimaryContainer;
      case AppButtonVariant.text:
        return scheme.primary;
    }
  }
}
