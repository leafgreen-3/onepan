import 'package:flutter/material.dart';
import 'package:onepan/theme/tokens.dart';

class AppTabs extends StatelessWidget implements PreferredSizeWidget {
  const AppTabs({super.key, required this.tabs, this.controller});

  final List<Tab> tabs;
  final TabController? controller;

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.minTouchTarget);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TabBar(
      controller: controller,
      tabs: tabs,
      labelStyle: Theme.of(context).textTheme.labelLarge,
      indicatorColor: scheme.primary,
      indicatorWeight: AppThickness.indicator,
      labelColor: scheme.primary,
      unselectedLabelColor: scheme.onSurface
          .withValues(alpha: AppOpacity.mediumText),
      indicatorPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      overlayColor: WidgetStatePropertyAll(
        scheme.primary.withValues(alpha: AppOpacity.hover),
      ),
    );
  }
}

