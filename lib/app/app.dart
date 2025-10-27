import 'package:flutter/material.dart';
import 'package:onepan/router/app_router.dart';

class OnePanApp extends StatelessWidget {
  const OnePanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OnePan',
      routerConfig: appRouter,
    );
  }
}

