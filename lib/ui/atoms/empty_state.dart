import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message, this.icon, this.action});

  final String message;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final iconColor = scheme.onSurface.withValues(alpha: AppOpacity.mediumText);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, size: AppSizes.icon, color: iconColor),
            if (icon != null) const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(color: scheme.onSurface),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

