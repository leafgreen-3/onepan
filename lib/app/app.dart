import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onepan/router/app_router.dart';
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
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'OnePan',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}

