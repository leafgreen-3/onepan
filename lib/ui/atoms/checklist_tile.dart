import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';

class ChecklistTile extends StatelessWidget {
  const ChecklistTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.checked,
    required this.onChanged,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final subtitleStyle = Theme.of(context).textTheme.bodyMedium;

    final trailing = Checkbox(
      value: checked,
      onChanged: (_) => onChanged(!checked),
      side: BorderSide(color: scheme.outline),
      activeColor: scheme.primary,
      checkColor: scheme.onPrimary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return Semantics(
      checked: checked,
      button: true,
      container: true,
      label: title,
      child: InkWell(
        onTap: () => onChanged(!checked),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: AppSizes.minTouchTarget,
                height: AppSizes.minTouchTarget,
                alignment: Alignment.center,
                child: leading,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: titleStyle),
                    if (subtitle != null)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: AppSpacing.xs),
                        child: Text(
                          subtitle!,
                          style: subtitleStyle!.copyWith(
                            color: scheme.onSurface
                                .withValues(alpha: AppOpacity.mediumText),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
