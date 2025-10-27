import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    this.header,
    this.media,
    this.footer,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.elevation = AppElevation.e1,
    this.onTap,
    this.child,
  });

  final Widget? header;
  final Widget? media;
  final Widget? footer;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final card = Material(
      color: scheme.surface,
      elevation: elevation,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        splashColor: scheme.primary.withValues(alpha: AppOpacity.hover),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (media != null) media!,
            if (header != null)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleLarge!,
                  child: header!,
                ),
              ),
            if (child != null)
              Padding(
                padding: padding,
                child: child!,
              ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: footer!,
              ),
          ],
        ),
      ),
    );

    return Semantics(
      button: onTap != null,
      container: true,
      child: card,
    );
  }
}

