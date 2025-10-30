import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/router/app_router.dart';
import 'package:onepan/di/locator.dart';
import 'package:onepan/theme/app_theme.dart';

class OnePanApp extends StatelessWidget {
  const OnePanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: _OnePanAppView(),
    );
  }
}

class _OnePanAppView extends ConsumerWidget {
  const _OnePanAppView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure DI is initialized even when tests construct OnePanApp directly
    // without calling main(), where setupLocator() is normally invoked.
    // setupLocator() is idempotent due to get_it registration guards.
    // This prevents provider construction failures in Home/Saved screens.
    // (No side effects beyond safe singleton registration.)
    // ignore: invalid_use_of_visible_for_testing_member
    // Note: keep this lightweight; it simply no-ops if already set up.
    // Import is at top-level in this file via router/app_router.dart usage tree.
    // To be explicit, bring the locator in scope.
    // We keep it here to avoid altering build order in main().
    // ignore: unnecessary_statements
    setupLocator();
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'OnePan',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}

